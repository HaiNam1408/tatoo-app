
import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/utils/getit_utils.dart';
import '../../application/login_cubit.dart';
import '../../domain/interfaces/login_repository_interfaces.dart';
import '../widgets/login_body.dart';

@RoutePage()
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        body: BlocProvider<LoginCubit>(
            create: (context) => LoginCubit(getIt<ILoginRepository>()),
            child: const LoginBody()),
      ),
    );
  }
}
