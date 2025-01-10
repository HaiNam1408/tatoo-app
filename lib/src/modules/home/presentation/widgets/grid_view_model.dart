import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import '../../../../../generated/colors.gen.dart';
import '../../../../common/widgets/option_select_widget.dart';
import '../../../../common/widgets/v_shop_card.dart';
import '../../../../core/domain/enums/enums.dart';
import '../../application/home_cubit.dart';
import '../../application/home_state.dart';

Widget gridviewModeWidget(BuildContext context, HomeState state) {
  return SingleChildScrollView(
    controller: context.read<HomeCubit>().headerScrollController,
    child: Container(
      decoration: const BoxDecoration(
        color: ColorName.primary,
      ),
      child: Column(
        children: [
          Row(
            children: [
              OptionSelectWidget(
                  text: 'Gần tôi',
                  isSelected: state.sortOptions == HomeSortOption.near,
                  onTap: () => context
                      .read<HomeCubit>()
                      .onSelectedOption(HomeSortOption.near)),
              Gap(12.w),
              OptionSelectWidget(
                  text: 'Nổi bật',
                  isSelected: state.sortOptions == HomeSortOption.highlight,
                  onTap: () => context
                      .read<HomeCubit>()
                      .onSelectedOption(HomeSortOption.highlight)),
              Gap(12.w),
              OptionSelectWidget(
                  text: 'Đánh giá cao',
                  isSelected: state.sortOptions == HomeSortOption.start,
                  onTap: () => context
                      .read<HomeCubit>()
                      .onSelectedOption(HomeSortOption.start))
            ],
          ),
          Gap(24.h),
          GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.all(0),
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 177 / 240),
            itemCount:
                state.isGridHeaderLoading ? 6 : state.profileList!.length,
            itemBuilder: (context, index) {
              return VShopCard(
                isGridMode: true,
                isLoading: state.isHeaderLoading,
                width: 177.w,
                height: 240.h,
                profile: state.profileList![index],
              );
            },
          )
        ],
      ),
    ),
  );
}
