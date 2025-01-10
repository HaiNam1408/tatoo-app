import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import '../../../generated/assets.gen.dart';
import '../../../generated/colors.gen.dart';
import '../../core/infrastructure/models/profile.dart';
import '../extensions/build_context_x.dart';
import 'cache_network_widget.dart';
import 'custom_placeholder_widget.dart';
import 'loading_holder.dart';
import 'star_rating.dart';

class VShopCard extends StatelessWidget {
  final double? width;
  final double? height;
  final bool? isGridMode;
  final bool isLoading;
  final ProfileModel profile;

  const VShopCard(
      {super.key,
      this.width,
      this.height,
      this.isGridMode = false,
      required this.isLoading,
      required this.profile});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(32),
      child: Stack(
        children: [
          CustomLoading(
            isLoading: isLoading,
            child: CacheImageWidget(
                width: width,
                height: height,
                radius: 32,
                url: profile.posts?[0].postImage?.filePath ?? ''),
          ),
          if (!isLoading)
            ClipRRect(
              borderRadius: BorderRadius.circular(32),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [Colors.black, Colors.black.withOpacity(0.5)],
                  ),
                ),
              ),
            ),
          SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CustomLoading(
                  isLoading: isLoading,
                  child: SizedBox(
                    height: isGridMode! ? 32.h : 80.h,
                    width: isGridMode! ? 32.w : 80.w,
                    child: CircleAvatar(
                      backgroundImage:
                          NetworkImage(profile.avatar?.filePath ?? ''),
                    ),
                  ),
                ),
                const Gap(8),
                isLoading
                    ? LoadingHolder(width: 150.w, height: 14.h)
                    : Text(
                        profile.storeName ?? '',
                        style: context.textTheme.bodyMedium
                            .copyWith(
                            fontWeight: FontWeight.w700,
                            fontSize: isGridMode! ? 12 : 16),
                      ),
                Gap(isGridMode! ? 0 : 4),
                isLoading
                    ? LoadingHolder(width: 100.w, height: 14.h)
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          StarRating(
                            rating: profile.averageRating ?? 5,
                            size: isGridMode! ? 12 : 16,
                          ),
                          Text(
                            ' (${profile.averageRating})',
                            style: context.textTheme.regular
                                .copyWith(fontSize: isGridMode! ? 12 : 14),
                          )
                        ],
                      ),
                Gap(isGridMode! ? 0 : 4),
                SizedBox(
                  width: width! * 0.7,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Assets.icons.location.svg(
                          colorFilter: const ColorFilter.mode(
                              ColorName.primary, BlendMode.srcIn),
                          height: 16),
                      const Gap(4),
                      isLoading
                          ? LoadingHolder(width: 100.w, height: 14.h)
                          : Flexible(
                              child: Text(
                                '${profile.address?.street}, ${profile.address?.city}',
                                style: context.textTheme.regular
                                    .copyWith(fontSize: 14),
                                overflow: TextOverflow.ellipsis,
                              ),
                          ),
                    ],
                  ),
                ),
                Gap(isGridMode! ? 12.h : 24.h),
              ],
            ),
          )
        ],
      ),
    );
  }
}
