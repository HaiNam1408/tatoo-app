// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import '../../../generated/colors.gen.dart';
import 'animated_color_background_widget.dart';

class BaseBodyController {
  AnimatedColorContainer header = AnimatedColorContainer(
      beginColor: Colors.black, endColor: ColorName.primary);

  void forward() {
    header.forward();
  }

  void reverse() {
    header.reverse();
  }
}

class BaseBodyWidget extends StatefulWidget {
  BaseBodyWidget({super.key, required this.child, this.controller});
  final Widget child;
  BaseBodyController? controller;

  @override
  State<BaseBodyWidget> createState() => BaseBodyWidgetState();
}

class BaseBodyWidgetState extends State<BaseBodyWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: ColorName.primary,
      child: Stack(
        children: [
          Positioned.fill(
            child: widget.controller == null
                ? Container(
                    color: ColorName.primary,
                  )
                : Container(
                    color: ColorName.primary,
                    child: widget.controller!.header),
          ),
          Positioned.fill(
            child: Container(color: Colors.transparent, child: widget.child),
          ),
        ],
      ),
    );
  }
}
