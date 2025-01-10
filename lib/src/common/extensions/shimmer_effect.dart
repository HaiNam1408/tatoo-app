import 'package:skeletonizer/skeletonizer.dart';

import '../../../generated/colors.gen.dart';

class CustomShimmerEffect {
  static const shimmerEffect = ShimmerEffect(
    baseColor: ColorName.primary,
    highlightColor: ColorName.greyText,
    duration: Duration(seconds: 1),
  );
}
