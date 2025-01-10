import 'package:flutter/material.dart';

class RotateWidget extends StatefulWidget {
  const RotateWidget({super.key, required this.child, required this.ontap});

  final Widget child;
  final Function(bool) ontap;

  @override
  RotateWidgetState createState() => RotateWidgetState();
}

class RotateWidgetState extends State<RotateWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0, end: 0.25).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () {
          if (_controller.isCompleted) {
            _controller.reverse();
             widget.ontap(true);
          } else {
            _controller.forward();
             widget.ontap(false);
          }
        },
        child: RotationTransition(turns: _animation, child: widget.child),
      ),
    );
  }
}
