import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../../../generated/assets.gen.dart';
import '../../../../../generated/colors.gen.dart';
import '../../../../common/extensions/build_context_x.dart';
import '../../../../common/utils/logger.dart';
import '../../../../common/widgets/cache_network_widget.dart';
import '../../../../common/widgets/custom_placeholder_widget.dart';
import '../../../../common/widgets/loading_holder.dart';
import '../../../../core/infrastructure/models/attachment.dart';
import '../../../../core/infrastructure/models/post.dart';
import '../../../app/app_router.dart';
import '../../../home/application/home_cubit.dart';
import '../../../post_detail/presentation/pages/post_detail_page.dart';
import '../../application/account_cubit.dart';
import '../../application/account_state.dart';

class AccountBody extends StatelessWidget {
  const AccountBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AccountCubit, AccountState>(
      listener: (context, state) => {logger.d(state)},
      builder: (context, state) => Container(
        padding: EdgeInsets.only(top: 10.w),
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
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                            onTap: () =>
                                context
                                .read<HomeCubit>()
                                // TODO: flag
                                .onChangePage(0, authId: 0),
                            child: Assets.icons.shareInfo.svg()),
                        Gap(10.w),
                        InkWell(
                            onTap: () {
                              context.router.push(ShopInforRoute(profile: null));
                            },
                            child: Assets.icons.settingShop.svg())
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
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(32),
                              child: SizedBox(
                                width: double
                                    .infinity, 
                                child: state.imagePathBackground != null
                                    ? Image.file(
                                        state.imagePathBackground!,
                                        fit: BoxFit.cover,
                                        alignment:
                                            Alignment.center, 
                                      )
                                    : Image.network(
                                        'https://img4.thuthuatphanmem.vn/uploads/2019/11/07/hinh-xam-hoa-bi-ngan-nho-xinh-rat-dep_110233969.jpg',
                                        fit: BoxFit.cover,
                                        alignment:
                                            Alignment.center, 
                                      ),
                              ),
                            ),
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
                            left: 16.w,
                            right: 16.w,
                            bottom: 24.h,
                            child: Row(
                              children: [
                                CustomLoading(
                                  isLoading: state.isFooterLoading,
                                  child: Stack(children: [
                                    SizedBox(
                                      height: 64.h,
                                      width: 64.w,
                                      child: CircleAvatar(
                                        backgroundImage: state
                                                    .imagePathAvatar !=
                                                null
                                            ? FileImage(state.imagePathAvatar!)
                                            : const NetworkImage(
                                                    'https://img4.thuthuatphanmem.vn/uploads/2019/11/07/hinh-xam-hoa-bi-ngan-nho-xinh-rat-dep_110233969.jpg')
                                                as ImageProvider,
                                      ),
                                    ),
                                    Positioned(
                                        right: 0,
                                        bottom: 0,
                                        child: GestureDetector(
                                          onTap: () => context
                                              .read<AccountCubit>()
                                              .pickImageAvatar(),
                                          child: Container(
                                            padding: const EdgeInsets.all(2),
                                            height: 20.h,
                                            width: 20.w,
                                            decoration: BoxDecoration(
                                                color: ColorName.black,
                                                borderRadius:
                                                    BorderRadius.circular(50)),
                                            child: Assets.icons.cameraAccount
                                                .svg(color: ColorName.white),
                                          ),
                                        )),
                                  ]),
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
                                            '1998 Tattoo Studio',
                                            style: context.textTheme.bodyMedium
                                                .copyWith(
                                                    fontWeight: FontWeight.w800,
                                                    fontSize: 16),
                                          ),
                                    state.isFooterLoading
                                        ? LoadingHolder(
                                            width: 50.w, height: 12.h)
                                        : Row(
                                            children: [
                                              RatingBar.builder(
                                                initialRating: state.starNumber,
                                                minRating: 1,
                                                direction: Axis.horizontal,
                                                allowHalfRating: true,
                                                itemCount: 5,
                                                itemSize: 12,
                                                itemPadding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 1.0),
                                                itemBuilder: (context, _) =>
                                                    Assets.icons.starFilled.svg(
                                                        color: ColorName.white),
                                                onRatingUpdate: (rating) {
                                                  logger.d(rating);
                                                  // print(rating);
                                                },
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                '${state.starNumber.toStringAsFixed(1)} (${state.totalRatings} đánh giá)',
                                                style: context
                                                    .textTheme.bodyMedium
                                                    .copyWith(fontSize: 12),
                                              ),
                                            ],
                                          ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                              right: 15,
                              top: 15,
                              child: GestureDetector(
                                onTap: () =>
                                    context.read<AccountCubit>().pickImage(),
                                child: Container(
                                  padding: const EdgeInsets.all(2),
                                  height: 24.h,
                                  width: 24.w,
                                  decoration: BoxDecoration(
                                      color: ColorName.black,
                                      borderRadius: BorderRadius.circular(50)),
                                  child: Assets.icons.cameraAccount
                                      .svg(color: ColorName.white),
                                ),
                              )),
                        ],
                      ),
                    ),
                    Gap(16.h),
                    Flexible(
                      child: GridView.builder(
                          shrinkWrap: true,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  mainAxisSpacing: 12,
                                  crossAxisSpacing: 12,
                                  childAspectRatio: 1,
                                  crossAxisCount: 3),
                          itemCount: state.isFooterLoading ? 21 : 77,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                showModalBottomSheet(
                                    isScrollControlled: true,
                                    context: context,
                                    builder: (BuildContext context) {
                                      return const PostDetailPage(
                                          post: PostModel(
                                        id: 1,
                                        content: 'Hello',
                                        postImage: Attachment(
                                            filePath:
                                                'https://artaistry.com/cdn/shop/articles/Clock_Tattoo_5.png?v=1692023644&width=480'),
                                      ));
                                    });
                              },
                              child: CustomLoading(
                                isLoading: state.isFooterLoading,
                                child: const CacheImageWidget(
                                  radius: 16,
                                  url:
                                      'https://artaistry.com/cdn/shop/articles/Clock_Tattoo_5.png?v=1692023644&width=480',
                                ),
                              ),
                            );
                          }),
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
                    onTap: () {},
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
      ),
    );
  }
}
