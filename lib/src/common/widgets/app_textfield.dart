import 'package:flutter/material.dart';

import '../../../generated/colors.gen.dart';
import '../extensions/build_context_x.dart';

class AppTextfield extends StatelessWidget {
  const AppTextfield(
      {super.key,
      this.textInputAction,
      this.decoration,
      this.enabled = true,
      this.hintText,
      this.controller,
      this.secure = false,
      this.canRequestFocus = true,
      this.autoFocus = false,
      this.onChanged,
      this.errorText});

  final TextInputAction? textInputAction;
  final String? hintText;
  final InputDecoration? decoration;
  final String? errorText;
  final bool secure;
  final bool enabled;
  final bool autoFocus;
  final bool canRequestFocus;
  final TextEditingController? controller;
  final Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      enabled: enabled,
      onChanged: (value) => onChanged?.call(value),
      obscureText: secure,
      autofocus: autoFocus,
      controller: controller,
      style: context.textTheme.bodyMedium.copyWith(color: ColorName.dark),
      cursorColor: ColorName.black,
      canRequestFocus: canRequestFocus,
      decoration: decoration ??
          InputDecoration(
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: ColorName.dark),
            ),
            disabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: ColorName.dark),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: ColorName.dark),
            ),
            border: const UnderlineInputBorder(
              borderSide: BorderSide(color: ColorName.dark),
            ),
            focusColor: Colors.black,
            hintText: hintText,
            errorText: errorText,
            errorStyle: context.textTheme.bodySmall.copyWith(color: Colors.red),
            hintStyle: context.textTheme.bodyMedium
                .copyWith(color: ColorName.greyText),
          ),
      textInputAction: textInputAction,
    );
  }
}
