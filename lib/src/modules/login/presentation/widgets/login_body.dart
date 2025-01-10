import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../../../generated/assets.gen.dart';
import '../../../../../generated/colors.gen.dart';
import '../../../../common/extensions/build_context_x.dart';
import '../../../../common/widgets/app_button.dart';
import '../../../../common/widgets/back_botton.dart';
import '../../../../common/widgets/text_error.dart';
import '../../application/login_cubit.dart';
import '../../application/login_state.dart';

class LoginBody extends StatefulWidget {
  const LoginBody({
    super.key,
  });

  @override
  State<LoginBody> createState() => _LoginBodyState();
}

class _LoginBodyState extends State<LoginBody> {
  bool securePwd = true;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: BlocBuilder<LoginCubit, LoginState>(builder: (context, state) {
          return Column(
            children: [
              const Row(
                children: [
                  AppBackButton(),
                ],
              ),
              Gap(24.h),
              Assets.images.logo.image(color: Colors.black),
              TextField(
                onChanged: (value) =>
                    context.read<LoginCubit>().onChangeAccount(value),
                controller: context.read<LoginCubit>().accountTxtController,
                style: context.textTheme.bodyMedium
                    .copyWith(color: ColorName.dark),
                cursorColor: ColorName.black,
                decoration: InputDecoration(
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: ColorName.dark),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: ColorName.dark),
                  ),
                  border: const UnderlineInputBorder(
                    borderSide: BorderSide(color: ColorName.dark),
                  ),
                  focusColor: Colors.black,
                  hintText: 'Tên tài khoản',
                  hintStyle:
                      context.textTheme.bodyMedium.copyWith(color: Colors.grey),
                ),
                textInputAction: TextInputAction.next,
              ),
              Gap(8.h),
              TextField(
                onChanged: (value) =>
                    context.read<LoginCubit>().onChangePwd(value),
                controller: context.read<LoginCubit>().pwdTxtController,
                style: context.textTheme.bodyMedium
                    .copyWith(color: ColorName.dark),
                cursorColor: ColorName.black,
                obscureText: securePwd,
                decoration: InputDecoration(
                  suffixIcon: GestureDetector(
                      onTap: () => setState(() {
                            securePwd = !securePwd;
                          }),
                      child: securePwd
                          ? Assets.images.eyeClose.image(width: 12, height: 12)
                          : Assets.images.eyeOpen.image(width: 12, height: 12)),
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: ColorName.dark),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: ColorName.dark),
                  ),
                  border: const UnderlineInputBorder(
                    borderSide: BorderSide(color: ColorName.dark),
                  ),
                  focusColor: Colors.black,
                  hintText: 'Mật khẩu',
                  hintStyle:
                      context.textTheme.bodyMedium.copyWith(color: Colors.grey),
                ),
                textInputAction: TextInputAction.done,
              ),
              Gap(16.h),
              if (state.errorMessage != '')
                Align(
                    alignment: Alignment.centerLeft,
                    child: TextError(text: state.errorMessage ?? '')),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    child: Text('Quên mật khẩu?',
                        style: context.textTheme.bodyMedium
                            .copyWith(color: ColorName.dark)),
                  )
                ],
              ),
              const Spacer(),
              AppButton(
                title: 'Đăng nhập',
                darkButton: true,
                onTap: () {
                  FocusManager.instance.primaryFocus?.unfocus(); 
                  context.read<LoginCubit>().login(context);
                },
              )
            ],
          );
        }),
      ),
    );
  }
}
