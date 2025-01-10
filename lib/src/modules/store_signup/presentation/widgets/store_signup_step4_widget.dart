import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:local_hero/local_hero.dart';
import '../../../../../generated/assets.gen.dart';
import '../../../../../generated/colors.gen.dart';
import '../../../../common/extensions/build_context_x.dart';
import '../../../../common/widgets/text_error.dart';
import '../../application/store_signup_cubit.dart';
import '../../application/store_signup_state.dart';
import 'header_signup_widget.dart';
import 'store_signup_image_picker.dart';

class StoreSignupStep4Widget extends StatefulWidget {
  const StoreSignupStep4Widget({super.key});

  @override
  State<StoreSignupStep4Widget> createState() => _StoreSignupStep4WidgetState();
}

class _StoreSignupStep4WidgetState extends State<StoreSignupStep4Widget> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StoreSignupCubit, StoreSignupState>(
        builder: (context, state) {
      return LocalHeroScope(
        onlyAnimateRemount: false,
        duration: const Duration(milliseconds: 300),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HeaderSignupWidget(
                  svg: Assets.icons.messageEdit.svg(),
                  title: 'Tin đăng đầu tiên',
                  subTitle: 'Tạo dấu ấn đầu tiên cho cửa hàng của bạn'),
              Gap(24.h),
              StoreSignUpImagePicker(
                key: UniqueKey(),
                image: state.postImg,
                title: 'Thêm ảnh',
                height: 238.h,
                onTap: context.read<StoreSignupCubit>().pickPostPhoto,
              ),
              if (state.postImgError!)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Center(
                    child: TextError(text: 'Vui lòng thêm hình cho bài đăng'),
                  ),
                ),
              Gap(16.h),
              TextField(
                controller: context.read<StoreSignupCubit>().descTxtController,
                onChanged: (value) {
                  context.read<StoreSignupCubit>().setPostDescription(value);
                },
                maxLines: 10,
                minLines: 5,
                style:
                    context.textTheme.bodySmall.copyWith(color: ColorName.dark),
                decoration: InputDecoration(
                  hintText: 'Bạn muốn chia sẻ điều gì',
                  hintStyle: context.textTheme.bodySmall
                      .copyWith(color: ColorName.greyText),
                  border: InputBorder.none,
                  errorText: state.postDesError!
                      ? 'Vui lòng thêm mô tả cho bài viết'
                      : null,
                ),
              )
            ],
          ),
        ),
      );
    });
  }
}
