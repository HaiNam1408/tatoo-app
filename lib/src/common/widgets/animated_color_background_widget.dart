// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AnimatedColorContainer extends StatefulWidget {
  final Color beginColor;
  final Color endColor;

  AnimatedColorContainer({
    super.key,
    required this.beginColor,
    required this.endColor,
  });

  AnimationController? _controller;
  Animation<Color?>? _colorAnimation;

  @override
  AnimatedColorContainerState createState() => AnimatedColorContainerState();

  void forward() {
    _controller?.forward();
  }

  void reverse() {
    _controller?.reverse();
  }
}

class AnimatedColorContainerState extends State<AnimatedColorContainer>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    widget._controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    widget._colorAnimation = ColorTween(
      begin: widget.beginColor,
      end: widget.endColor,
    ).animate(widget._controller!);
  }

  @override
  void dispose() {
    widget._controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget._colorAnimation!,
      builder: (context, child) {
        return Column(
          children: [
            Container(
              width: MediaQuery.sizeOf(context).width,
              height: 240.h,
              decoration: BoxDecoration(
                  color: widget._colorAnimation!.value,
                  borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(24),
                      bottomRight: Radius.circular(24))),
            ),
            const Expanded(child: SizedBox())
          ],
        );
      },
    );
  }
}
