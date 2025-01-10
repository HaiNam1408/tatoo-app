import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../generated/colors.gen.dart';
import '../extensions/build_context_x.dart';

class AppButton extends StatelessWidget {
  const AppButton(
      {super.key, required this.title, required this.darkButton, this.onTap});
  final String title;
  final bool darkButton;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap?.call();
      },
      child: Container(
        height: 53.h,
        decoration: BoxDecoration(
            color: darkButton ? ColorName.dark : ColorName.primary,
            borderRadius: BorderRadius.circular(53.h / 2),
            border: Border.all(color: ColorName.dark)),
        child: Center(
            child: Text(
          title,
          style: context.textTheme.bodyMedium
              .copyWith(color: darkButton ? ColorName.primary : Colors.black),
        )),
      ),
    );
  }
}
