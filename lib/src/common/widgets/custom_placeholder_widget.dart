import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../generated/colors.gen.dart';

class CustomLoading extends StatefulWidget {
  const CustomLoading({
    super.key,
    required this.isLoading,
    required this.child,
  });

  final bool isLoading;
  final Widget child;

  @override
  State<CustomLoading> createState() => _ShimmerLoadingState();
}

class _ShimmerLoadingState extends State<CustomLoading> {
  static const _shimmerGradient = LinearGradient(
    colors: [
      ColorName.primary,
      Colors.grey,
      ColorName.primary,
      Colors.grey,
    ],
    stops: [
      0.1,
      0.4,
      0.8,
      1.0
    ],
    begin: Alignment(-1.0, -0.3),
    end: Alignment(1.0, 0.3),
    tileMode: TileMode.mirror,
  );

  @override
  Widget build(BuildContext context) {
    if (!widget.isLoading) {
      return widget.child;
    }

    return Shimmer(
      gradient: _shimmerGradient,
      period: const Duration(milliseconds: 1000),
      child: widget.child,
    );
  }
}
