import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';

import '../../../../../generated/assets.gen.dart';
import '../../../../../generated/colors.gen.dart';
import '../../../../common/extensions/int_duration.dart';
import '../../../../common/utils/app_environment.dart';
import '../../../../common/utils/getit_utils.dart';
import '../../../../core/domain/enums/enums.dart';
import '../../../../core/infrastructure/datasources/remote/socket/socket_manager.dart';
import '../../../auth/application/auth_cubit.dart';
import '../../../app/app_router.dart';

@RoutePage()
class SplashPage extends StatelessWidget {
  SplashPage({super.key}) {
    fetchAll();
  }

  fetchAll() async {
    await Future.delayed(3.seconds);
    getIt<AuthCubit>().state.whenOrNull(
          authenticated: (user) => {
            SocketManager.instance
                .initialize(AppEnvironment.socketUrl, user.id),
            getIt<AppRouter>().replaceAll([
              TabBarRoute(
                  role: user.roles?.role == 'USER' ? Role.USER : Role.STORE)
            ])
          },
          unauthenticated: () =>
              getIt<AppRouter>().replaceAll([const AuthRoute()]),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            color: ColorName.dark,
            child: Center(child: Assets.images.logo.image())));
  }
}
