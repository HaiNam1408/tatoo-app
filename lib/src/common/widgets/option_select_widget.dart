import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../generated/colors.gen.dart';
import '../extensions/build_context_x.dart';

class OptionSelectWidget extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  const OptionSelectWidget({
    super.key,
    required this.text,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 38.w,
        decoration: BoxDecoration(
          color: isSelected ? ColorName.dark : ColorName.primary,
          border: Border.all(color: ColorName.dark),
          borderRadius: BorderRadius.circular(19.0.w),
        ),
        padding: EdgeInsets.symmetric(horizontal: 16.0.w),
        child: Center(
          child: Text(
            text,
            style: context.textTheme.labelMedium.copyWith(
                color: isSelected ? ColorName.primary : ColorName.dark),
          ),
        ),
      ),
    );
  }
}
