import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import '../../../../../generated/assets.gen.dart';
import '../../../../../generated/colors.gen.dart';
import '../../../../common/extensions/build_context_x.dart';
import '../../../../common/widgets/app_textfield.dart';
import '../../application/store_signup_cubit.dart';
import '../../application/store_signup_state.dart';
import 'header_signup_widget.dart';

class StoreSignupStep1Widget extends StatefulWidget {
  const StoreSignupStep1Widget({super.key, required this.onSelected});

  final Function(bool) onSelected;

  @override
  State<StoreSignupStep1Widget> createState() => _StoreSignupStep1WidgetState();
}

class _StoreSignupStep1WidgetState extends State<StoreSignupStep1Widget> {
  bool securePwd = true;
  bool checked = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StoreSignupCubit, StoreSignupState>(
      builder: (context, state) => SingleChildScrollView(
        child: Column(
          children: [
            HeaderSignupWidget(
                svg: Assets.icons.profileOutline.svg(),
                title: 'Đăng ký',
                subTitle: 'Nhập tên tài khoản và mật khẩu '),
            Gap(24.h),
            AppTextfield(
              controller: context.read<StoreSignupCubit>().accountTxtController,
              onChanged: (value) =>
                  context.read<StoreSignupCubit>().setUserName(value),
              hintText: 'Tên tài khoản',
              textInputAction: TextInputAction.next,
              errorText: (state.usernameError ?? false)
                  ? 'Tài khoản cần ít nhất 6 kí tự, chỉ chứa chữ và số'
                  : null,
            ),
            Gap(8.h),
            AppTextfield(
              controller: context.read<StoreSignupCubit>().pwdTxtController,
              onChanged: (value) =>
                  context.read<StoreSignupCubit>().setPwd(value),
              secure: securePwd,
              decoration: InputDecoration(
                suffixIcon: GestureDetector(
                    onTap: () => setState(() {
                          securePwd = !securePwd;
                        }),
                    child: securePwd
                        ? Assets.images.eyeClose.image(width: 24, height: 24)
                        : Assets.images.eyeOpen.image(width: 24, height: 24)),
                enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: ColorName.dark),
                ),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: ColorName.dark),
                ),
                border: const UnderlineInputBorder(
                  borderSide: BorderSide(color: ColorName.dark),
                ),
                errorText: state.pwdError ?? false
                    ? 'Mật khẩu cần ít nhất 8 kí tự'
                    : null,
                focusColor: Colors.black,
                hintText: 'Mật khẩu',
                hintStyle:
                    context.textTheme.bodyMedium.copyWith(color: Colors.grey),
              ),
              textInputAction: TextInputAction.done,
            ),
            Gap(24.h),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                SizedBox(
                    width: 24,
                    height: 24,
                    child: Checkbox(
                        splashRadius: 0,
                        activeColor: ColorName.dark,
                        value: checked,
                        onChanged: (value) => setState(() {
                              checked = !checked;
                              widget.onSelected.call(checked);
                            }))),
                Gap(12.w),
                Expanded(
                  child: Text.rich(
                    TextSpan(
                      text: 'Bạn đồng ý với ',
                      style: context.textTheme.bodyMedium
                          .copyWith(color: ColorName.dark),
                      children: [
                        TextSpan(
                          text: 'Điều khoản dịch vụ',
                          style: context.textTheme.bodyMedium.copyWith(
                              color: ColorName.dark,
                              fontWeight: FontWeight.bold),
                          recognizer: TapGestureRecognizer()..onTap = () {},
                        ),
                        const TextSpan(text: ' và '),
                        TextSpan(
                          text: 'Chính sách bảo mật',
                          style: context.textTheme.bodyMedium.copyWith(
                              color: ColorName.dark,
                              fontWeight: FontWeight.bold),
                          recognizer: TapGestureRecognizer()..onTap = () {},
                        ),
                        const TextSpan(text: ' của chúng tôi'),
                      ],
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                )

              ],
            )
          ],
        ),
      ),
    );
  }
}
