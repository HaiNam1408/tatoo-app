import 'package:flutter/material.dart';

class TextError extends StatelessWidget {
  final String text;
  final double fontSize;
  final TextAlign textAlign;

  const TextError(
      {super.key,
      required this.text,
      this.fontSize = 14,
      this.textAlign = TextAlign.left});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(color: Colors.red, fontSize: fontSize),
      textAlign: textAlign,
    );
  }
}
