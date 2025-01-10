import 'package:flutter/material.dart';

import '../../../generated/colors.gen.dart';
import '../extensions/build_context_x.dart';

class TagCustom extends StatelessWidget {
  final Color? bgColor;
  final Color? textColor;
  final String text;
  final EdgeInsets? padding;
  final VoidCallback? onTap;
  const TagCustom(
      {super.key,
      this.bgColor,
      this.textColor,
      required this.text,
      this.padding,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding:
            padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: bgColor ?? ColorName.dark,
          borderRadius: BorderRadius.circular(32),
        ),
        child: Text(
          text,
          style: context.textTheme.regular
              .copyWith(fontSize: 12, color: textColor ?? ColorName.white),
        ),
      ),
    );
  }
}
