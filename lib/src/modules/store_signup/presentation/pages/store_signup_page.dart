import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../generated/colors.gen.dart';
import '../../../../common/utils/getit_utils.dart';
import '../../application/store_signup_cubit.dart';
import '../../domain/interfaces/store_signup_repository_interface.dart';
import '../widgets/store_signup_body.dart';

@RoutePage()
class StoreSignupPage extends StatelessWidget {
  const StoreSignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        // resizeToAvoidBottomInset: false,
        backgroundColor: ColorName.primary,
        body: BlocProvider<StoreSignupCubit>(
            create: (context) =>
                StoreSignupCubit(getIt<IStoreSignupRepository>()),
            child: const StoreSignupBody()),
      ),
    );
  }
}
