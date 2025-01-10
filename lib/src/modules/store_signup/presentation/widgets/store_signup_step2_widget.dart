import 'package:asuka/asuka.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import '../../../../../generated/assets.gen.dart';
import '../../../../../generated/colors.gen.dart';
import '../../../../common/extensions/build_context_x.dart';
import '../../../../common/widgets/address_search_widget.dart';
import '../../../../common/widgets/app_textfield.dart';
import '../../../../common/widgets/text_error.dart';
import '../../application/store_signup_cubit.dart';
import '../../application/store_signup_state.dart';
import 'header_signup_widget.dart';
import 'store_signup_image_picker.dart';

class StoreSignupStep2Widget extends StatefulWidget {
  const StoreSignupStep2Widget({super.key});

  @override
  State<StoreSignupStep2Widget> createState() => _StoreSignupStep2WidgetState();
}

class _StoreSignupStep2WidgetState extends State<StoreSignupStep2Widget> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StoreSignupCubit, StoreSignupState>(
        builder: (context, state) {
      return SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeaderSignupWidget(
                svg: Assets.icons.shop.svg(),
                title: 'Thông tin cửa hàng',
                subTitle: 'Thiết lập thông tin cho cửa hàng'),
            Gap(24.h),
            Text(
              'Ảnh đại diện',
              style: context.textTheme.bodyMedium
                  .copyWith(color: ColorName.dark, fontWeight: FontWeight.w600),
            ),
            Gap(16.h),
            Center(
              child: GestureDetector(
                onTap: () async {
                  context.read<StoreSignupCubit>().pickAvatar();
                },
                child: Stack(
                  children: [
                    SizedBox(
                      height: 80.w,
                      width: 80.w,
                      child: CircleAvatar(
                          backgroundColor: ColorName.greyText,
                          foregroundImage: state.avatar == null
                              ? Assets.images.logo
                                  .image(fit: BoxFit.cover)
                                  .image
                              : Image.file(state.avatar!).image),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: SizedBox(
                        height: 24.w,
                        width: 24.w,
                        child: CircleAvatar(
                            backgroundColor: ColorName.dark,
                            child: Assets.icons.camera.svg()),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (state.avatarError!)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Center(
                  child: TextError(text: 'Vui lòng chọn ảnh đại diện'),
                ),
              ),
            Text(
              'Ảnh bìa',
              style: context.textTheme.bodyMedium
                  .copyWith(color: ColorName.dark, fontWeight: FontWeight.w600),
            ),
            Gap(16.h),
            StoreSignUpImagePicker(
              key: UniqueKey(),
              image: state.coverImage,
              title: 'Thêm ảnh bìa',
              onTap: context.read<StoreSignupCubit>().pickCoverPhoto,
            ),
            if (state.coverImageError!)
              const Padding(
                padding: EdgeInsets.only(top: 8),
                child: Center(
                  child: TextError(text: 'Vui lòng chọn ảnh bìa'),
                ),
              ),
            Gap(24.h),
            Text(
              'Tên cửa hàng',
              style: context.textTheme.bodyMedium
                  .copyWith(color: ColorName.dark, fontWeight: FontWeight.w600),
            ),
            AppTextfield(
              controller: context.read<StoreSignupCubit>().nameTxtController,
              hintText: 'Tatto Shop 1',
              textInputAction: TextInputAction.done,
              onChanged: (value) {
                context.read<StoreSignupCubit>().setShopName(value);
              },
              errorText:
                  state.shopNameError! ? 'Vui lòng nhập tên cửa hàng' : null,
            ),
            Gap(24.h),
            Text(
              'Địa chỉ',
              style: context.textTheme.bodyMedium
                  .copyWith(color: ColorName.dark, fontWeight: FontWeight.w600),
            ),
            GestureDetector(
              onTap: () {
                FocusManager.instance.primaryFocus?.unfocus();
                Asuka.showModalBottomSheet(
                  isDismissible: true,
                  isScrollControlled: true,
                  builder: (_) {
                    return AddressSearchWidget(onSelected: (province) {
                      context
                          .read<StoreSignupCubit>()
                          .onSelectProvince(province);
                    });
                  },
                );
              },
              child: AppTextfield(
                controller:
                    context.read<StoreSignupCubit>().provinceTxtController,
                enabled: false,
                canRequestFocus: false,
                hintText: 'Chọn tỉnh/thành phố',
                errorText: state.cityError == true
                    ? 'Vui lòng chọn tỉnh/thành phố'
                    : null,
              ),
            ),
            const Gap(4),
            AppTextfield(
              controller: context.read<StoreSignupCubit>().addressTxtController,
              hintText: 'Địa chỉ chi tiết',
              textInputAction: TextInputAction.done,
              onChanged: (value) {
                context.read<StoreSignupCubit>().setAddress(value);
              },
              errorText: state.addressError!
                  ? 'Vui lòng nhập địa chỉ chi tiết của bạn'
                  : null,
            ),
            Gap(24.h),
          ],
        ),
      );
    });
  }
}
