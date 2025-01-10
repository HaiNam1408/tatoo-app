import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../../../generated/assets.gen.dart';
import '../../../../../generated/colors.gen.dart';
import '../../../../common/extensions/build_context_x.dart';
import '../../../../common/widgets/base_body.dart';
import '../../../../common/widgets/cache_network_widget.dart';
import '../../../../common/widgets/custom_placeholder_widget.dart';
import '../../../../common/widgets/v_shop_card.dart';
import '../../application/home_cubit.dart';
import '../../application/home_state.dart';
import 'grid_view_model.dart';

class HeadPage extends StatelessWidget {
  final HomeState state;
  const HeadPage(this.state, {super.key});

  @override
  Widget build(BuildContext context) {
    return BaseBodyWidget(
      controller: context.read<HomeCubit>().bodyController,
      child: SingleChildScrollView(
        controller: context.read<HomeCubit>().headerScrollController,
        physics: !state.isGridMode
            ? const NeverScrollableScrollPhysics()
            : const NeverScrollableScrollPhysics(),
        child: Container(
          height: !state.isGridMode ? 844.h : 844.h,
          color: Colors.transparent,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                child: SafeArea(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0.w),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(children: [
                              Text(
                                'Chọn khu vực ',
                                textAlign: TextAlign.left,
                                style: context.textTheme.bodyMedium.copyWith(
                                    color: state.isGridMode
                                        ? ColorName.black
                                        : ColorName.primary),
                              ),
                              Assets.icons.arrowDownLight.svg(
                                  colorFilter: ColorFilter.mode(
                                      state.isGridMode
                                          ? ColorName.dark
                                          : ColorName.primary,
                                      BlendMode.srcIn))
                            ]),
                            Text(
                              'Hà Nội',
                              style: context.textTheme.headlineLarge.copyWith(
                                  fontSize: 28.sp,
                                  fontWeight: FontWeight.w700,
                                  color: state.isGridMode
                                      ? ColorName.black
                                      : ColorName.primary),
                            ),
                          ],
                        ),
                        InkWell(
                            onTap: () {
                              context.read<HomeCubit>().changeMode();
                            },
                            child: SizedBox(
                              height: 24.w,
                              width: 24.w,
                              child: PageView(
                                controller:
                                    context.read<HomeCubit>().iconModeControler,
                                physics: const NeverScrollableScrollPhysics(),
                                children: [
                                  Assets.icons.singleMode.svg(),
                                  Assets.icons.gridModeIcon.svg()
                                ],
                              ),
                            ))
                      ],
                    ),
                  ),
                ),
              ),
              Flexible(
                child: PageView(
                    physics: const NeverScrollableScrollPhysics(),
                    controller: context.read<HomeCubit>().modeController,
                    children: [
                      PageView.builder(
                        key: const PageStorageKey('headerPage'),
                        onPageChanged: (index) =>
                            context.read<HomeCubit>().changeProfileIndex(index),
                        itemCount: state.profileList?.length,
                        itemBuilder: (context, index) {
                          final profile = state.profileList?[index];
                          return Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 16.w, vertical: 16.h),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(32),
                              child: Column(
                                children: [
                                  Flexible(
                                      child: InkWell(
                                    onTap: () => {
                                      context.read<HomeCubit>().onChangePage(1)
                                    },
                                    child: VShopCard(
                                      isLoading: state.isHeaderLoading,
                                      width: 385.w,
                                      height: 497.h,
                                      profile: profile!,
                                    ),
                                  )),
                                  Gap(24.h),
                                  SizedBox(
                                    height: 69.h,
                                    child: Center(
                                      child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: List<Widget>.generate(
                                            profile.posts?.length ?? 0,
                                            (index) {
                                              return Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 8.0.w),
                                                child: CustomLoading(
                                                    isLoading:
                                                        state.isHeaderLoading,
                                                    child: AspectRatio(
                                                      aspectRatio: 1,
                                                      child: CacheImageWidget(
                                                        radius: 16,
                                                        url: profile
                                                                .posts?[index]
                                                                .postImage
                                                                ?.filePath ??
                                                            '',
                                                      ),
                                                    )),
                                              );
                                            },
                                          )),
                                    ),
                                  ),
                                  Gap(24.h + 60 + 24.h)
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0.w),
                        child: gridviewModeWidget(context, state),
                      ),
                    ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
