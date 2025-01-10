import 'dart:async';
import 'dart:isolate';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talker_bloc_logger/talker_bloc_logger.dart';
import 'package:talker_flutter/talker_flutter.dart';

import 'src/common/extensions/locale_x.dart';
import 'src/common/utils/app_environment.dart';
import 'src/common/utils/getit_utils.dart';
import 'src/common/utils/logger.dart';
import 'src/core/domain/enums/enums.dart';
import 'src/modules/auth/application/auth_cubit.dart';
import 'src/core/application/cubits/device/app_device_cubit.dart';
import 'src/core/application/cubits/lang/lang_cubit.dart';
import 'src/core/domain/interfaces/lang_repository_interface.dart';
import 'src/core/infrastructure/datasources/local/storage.dart';
import 'src/modules/app/app_router.dart';
import 'src/modules/app/app_widget.dart';
import 'src/modules/tabbar/application/tabbar_cubit.dart';

void main() {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    await AppEnvironment.setup();
    await Storage.setup();
    await GetItUtils.setup();

    final langRepository = getIt<ILangRepository>();
    final talker = getIt<Talker>();
    _setupErrorHooks(talker);
    logger.d('deviceLocale - ${langRepository.getDeviceLocale().fullLanguageCode}');
    logger.d('currentLocale - ${langRepository.getLocale().fullLanguageCode}');

    Bloc.observer = TalkerBlocObserver(talker: talker);


    runApp(
      MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => getIt<AuthCubit>()),
          BlocProvider(create: (_) => getIt<LangCubit>()),
          BlocProvider(create: (_) => getIt<AppDeviceCubit>()),
          BlocProvider(create: (_) => getIt<TabbarCubit>()),
        ],
        child: MultiBlocListener(
          listeners: [
            BlocListener<AuthCubit, AuthState>(listener: (context, state) {
              final router = getIt<AppRouter>();
              state.whenOrNull(
                  authenticated: (user) => router.replaceAll([
                        TabBarRoute(
                            role: user.roles?.role == 'USER'
                                ? Role.USER
                                : Role.STORE)
                      ]),
                  unauthenticated: () => router.replaceAll([TabBarRoute()]));
            }),
          ],
          child: const AppWidget(),
        ),
      ),
    );
  }, (error, stack) {
    getIt<Talker>().handle(error, stack);
  });
}

Future _setupErrorHooks(Talker talker, {bool catchFlutterErrors = true}) async {
  if (catchFlutterErrors) {
    FlutterError.onError = (FlutterErrorDetails details) async {
      _reportError(details.exception, details.stack, talker);
    };
  }
  PlatformDispatcher.instance.onError = (error, stack) {
    _reportError(error, stack, talker);
    return true;
  };

  /// Web doesn't have Isolate error listener support
  if (!kIsWeb) {
    Isolate.current.addErrorListener(RawReceivePort((dynamic pair) async {
      final isolateError = pair as List<dynamic>;
      _reportError(
        isolateError.first.toString(),
        isolateError.last.toString(),
        talker,
      );
    }).sendPort);
  }
}

void _reportError(dynamic error, dynamic stackTrace, Talker talker) async {
  talker.error('Unhandled Exception', error, stackTrace);
}
