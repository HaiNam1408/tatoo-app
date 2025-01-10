import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import '../../../../../generated/assets.gen.dart';
import '../../../../../generated/colors.gen.dart';
import '../../../../common/extensions/build_context_x.dart';
import '../../../../common/widgets/cache_network_widget.dart';
import '../../../../common/widgets/custom_placeholder_widget.dart';
import '../../../../common/widgets/loading_holder.dart';
import '../../../../common/widgets/rotate_widget.dart';
import '../../../../common/widgets/star_rating.dart';
import '../../../app/app_router.dart';
import '../../../post_detail/presentation/pages/post_detail_page.dart';
import '../../application/home_cubit.dart';
import '../../application/home_state.dart';
import 'time_expanded.dart';

class FooterPage extends StatelessWidget {
  final HomeState state;
  const FooterPage(this.state, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ColorName.primary,
      child: Stack(
        children: [
          SafeArea(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              color: ColorName.primary,
              child: Column(
                children: [
                  Row(
                    children: [
                      InkWell(
                          onTap: () =>
                              context.read<HomeCubit>().onChangePage(0),
                          child: Assets.icons.arrowLeft.svg()),
                      const Spacer(),
                      InkWell(
                          onTap: state.profile != null
                              ? () {
                                  context.router.push(
                                      ShopInforRoute(profile: state.profile!));
                                }
                              : null,
                          child: Assets.icons.infoCircle.svg())
                    ],
                  ),
                  Gap(12.h),
                  SizedBox(
                    height: 240.h,
                    width: 358.w,
                    child: Stack(
                      children: [
                        CustomLoading(
                          isLoading: state.isFooterLoading,
                          child: CacheImageWidget(
                              radius: 32,
                              url: state.profile?.background?.filePath ?? ''),
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(32),
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                colors: [
                                  Colors.black,
                                  Colors.black.withOpacity(0.5)
                                ],
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          right: 16.w,
                          top: 16.h,
                          child: state.isFooterLoading
                              ? LoadingHolder(width: 40.w, height: 40.w)
                              : Container(
                                  decoration: BoxDecoration(
                                    color: ColorName.dark,
                                    borderRadius: BorderRadius.circular(32),
                                  ),
                                  child: Assets.icons.map.svg(),
                                ),
                        ),
                        Positioned(
                          left: 16.w,
                          right: 16.w,
                          bottom: 24.h,
                          child: Row(
                            children: [
                              CustomLoading(
                                isLoading: state.isFooterLoading,
                                child: CircleAvatar(
                                    child: CacheImageWidget(
                                  radius: 32,
                                  url: state.profile?.avatar?.filePath ?? '',
                                )),
                              ),
                              const Gap(8),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  state.isFooterLoading
                                      ? LoadingHolder(
                                          width: 100.w, height: 14.h)
                                      : Text(
                                          state.profile?.storeName ?? '',
                                          style: context.textTheme.bodyMedium
                                              .copyWith(
                                                  fontWeight: FontWeight.w700),
                                        ),
                                  state.isFooterLoading
                                      ? LoadingHolder(width: 50.w, height: 12.h)
                                      : Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            StarRating(
                                              rating: state
                                                      .profile?.averageRating ??
                                                  4,
                                              size: 12,
                                            ),
                                            Text(
                                              ' (${state.profile?.averageRating ?? 5})',
                                              style: context.textTheme.regular
                                                  .copyWith(fontSize: 12),
                                            )
                                          ],
                                        ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          right: 24.w,
                          bottom: 24.h,
                          child: state.isFooterLoading
                              ? LoadingHolder(width: 100.w, height: 12.h)
                              : Row(
                                  children: [
                                    Assets.icons.message.svg(),
                                    Text(
                                      ' 95% tỉ lệ phản hồi',
                                      style: context.textTheme.regular
                                          .copyWith(fontSize: 12),
                                    ),
                                  ],
                                ),
                        ),
                      ],
                    ),
                  ),
                  Gap(24.h),
                  CustomLoading(
                    isLoading: state.isFooterLoading,
                    child: Row(
                      children: [
                        Gap(8.w),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            state.isFooterLoading
                                ? LoadingHolder(width: 100.w, height: 14.h)
                                : Text(
                                    'Đang mở cửa',
                                    style: context.textTheme.bodyMedium
                                        .copyWith(
                                            color: ColorName.black,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 14),
                                  ),
                            const Gap(4),
                            state.isFooterLoading
                                ? LoadingHolder(width: 70.w, height: 12.h)
                                : Text(
                                    '08:00 - 20:00',
                                    style: context.textTheme.bodyMedium
                                        .copyWith(
                                            color: ColorName.greyText,
                                            fontSize: 12),
                                  )
                          ],
                        ),
                        const Spacer(),
                        if (!state.isFooterLoading)
                          RotateWidget(
                            child: Assets.icons.arrowRight.svg(),
                            ontap: (rollback) {
                              context.read<HomeCubit>().tapTimeExpanded();
                            },
                          ),
                        Gap(8.w)
                      ],
                    ),
                  ),
                  TweenAnimationBuilder<double>(
                    tween: Tween<double>(
                        begin: state.isExpandedTime ? 0 : 150,
                        end: state.isExpandedTime ? 150 : 0),
                    duration: const Duration(milliseconds: 300),
                    builder: (context, height, widget) => SizedBox(
                      height: height,
                      child: height > 0
                          ? timeExpandedWidget(context)
                          : const SizedBox.shrink(),
                    ),
                  ),
                  Gap(16.h),
                  Flexible(
                    child: GridView.builder(
                      controller: context.read<HomeCubit>().scrollController,
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.only(bottom: 100.h),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        childAspectRatio: 1,
                        crossAxisCount: 3,
                      ),
                      itemCount: state.isFooterLoading
                          ? 12
                          : (state.postList?.length ?? 0) +
                              (state.isLoadingPost ? 12 : 0),
                      itemBuilder: (context, index) {
                        final isSkeleton = state.isFooterLoading ||
                            index >= (state.postList?.length ?? 0);

                        return InkWell(
                          onTap: () {
                            if (!isSkeleton) {
                              showModalBottomSheet(
                                isScrollControlled: true,
                                context: context,
                                builder: (BuildContext context) {
                                  return PostDetailPage(
                                      post: state.postList?[index]);
                                },
                              );
                            }
                          },
                          child: CustomLoading(
                            isLoading: isSkeleton,
                            child: CacheImageWidget(
                              radius: 16,
                              url: isSkeleton
                                  ? 'https://picsum.photos/100/100'
                                  : state.postList?[index].postImage
                                          ?.filePath ??
                                      '',
                            ),
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
          Positioned(
              bottom: 24.h,
              left: 0,
              right: 0,
              child: Center(
                child: InkWell(
                  onTap: () {
                    context.router.push(ConversationRoute(
                      key: UniqueKey(),
                      userName: state.profile?.fullname ??
                          state.profile?.storeName ??
                          '',
                      avatarUrl: state.profile?.avatar?.filePath ?? '',
                      receiverId: state.profile?.id ?? 0,
                    ));
                  },
                  child: Container(
                    height: 56,
                    width: 142,
                    decoration: BoxDecoration(
                        color: ColorName.dark,
                        borderRadius: BorderRadius.circular(32)),
                    padding: const EdgeInsets.all(8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Assets.icons.messageOutline.svg(),
                        Gap(8.w),
                        Text('Nhắn tin',
                            style: context.textTheme.bodyMedium
                                .copyWith(fontWeight: FontWeight.w500))
                      ],
                    ),
                  ),
                ),
              ))
        ],
        // ),
      ),
    );
  }
}
