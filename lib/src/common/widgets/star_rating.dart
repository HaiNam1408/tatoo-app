import 'package:flutter/material.dart';

import '../../../generated/assets.gen.dart';
import '../../../generated/colors.gen.dart';

class StarRating extends StatelessWidget {
  final double rating;
  final int starCount;
  final Color filledStarColor;
  final Color unfilledStarColor;
  final double size;
  final double spacing;

  const StarRating({
    super.key,
    required this.rating,
    this.starCount = 5,
    this.filledStarColor = ColorName.primary,
    this.unfilledStarColor = ColorName.primary,
    this.size = 24,
    this.spacing = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(starCount, (index) {
        if (index < rating.floor()) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: spacing),
            child: Assets.icons.starFilled.svg(
                width: size,
                height: size,
                colorFilter:
                    ColorFilter.mode(filledStarColor, BlendMode.srcIn)),
          );
        } else {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: spacing),
            child: Assets.icons.starOutline.svg(
                width: size,
                height: size,
                colorFilter:
                    ColorFilter.mode(filledStarColor, BlendMode.srcIn)),
          );
        }
      }),
    );
  }
}
