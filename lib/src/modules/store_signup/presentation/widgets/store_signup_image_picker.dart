import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import '../../../../../generated/assets.gen.dart';
import '../../../../../generated/colors.gen.dart';
import '../../../../common/extensions/build_context_x.dart';

class StoreSignUpImagePicker extends StatelessWidget {
  final File? image;
  final String title;
  final double? width;
  final double? height;
  final Function? onTap;
  const StoreSignUpImagePicker(
      {super.key,
      required this.image,
      required this.title,
      this.width,
      this.height,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap?.call();
      },
      child: Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16.sp),
          child: DottedBorder(
            borderType: BorderType.RRect,
            radius: Radius.circular(16.sp),
            color: ColorName.greyText,
            child: SizedBox(
              width: width ?? 358.w,
              height: height ?? 160.h,
              child: Column(
                children: [
                  Stack(
                    children: [
                      SizedBox(
                        height: height ?? 160.h,
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Assets.icons.galleryAdd.svg(),
                            Gap(8.h),
                            Text(
                              title,
                              style: context.textTheme.bodySmall.copyWith(
                                  color: ColorName.greyText,
                                  fontWeight: FontWeight.w400),
                            )
                          ],
                        ),
                      ),
                      if (image != null)
                        SizedBox(
                            height: height ?? 160.h,
                            width: width ?? 358.w,
                            child: Image.file(
                              image!,
                              fit: BoxFit.fitWidth,
                            ))
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
