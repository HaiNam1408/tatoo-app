import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:local_hero/local_hero.dart';
import '../../../../../generated/assets.gen.dart';
import '../../../../../generated/colors.gen.dart';
import '../../../../common/extensions/build_context_x.dart';
import '../../../../common/widgets/app_textfield.dart';
import '../../../../common/widgets/local_hero_overlay.dart';
import '../../../../common/widgets/tag_custom.dart';
import '../../application/store_signup_cubit.dart';
import '../../application/store_signup_state.dart';
import 'header_signup_widget.dart';

class StoreSignupStep3Widget extends StatefulWidget {
  const StoreSignupStep3Widget({super.key});

  @override
  State<StoreSignupStep3Widget> createState() => _StoreSignupStep3WidgetState();
}

class _StoreSignupStep3WidgetState extends State<StoreSignupStep3Widget> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StoreSignupCubit, StoreSignupState>(
      builder: (context, state) {
        return LocalHeroScope(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          child: LocalHeroOverlay(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HeaderSignupWidget(
                    svg: Assets.icons.hashtag.svg(),
                    title: 'Hashtag',
                    subTitle: 'Tìm kiếm phong cách của bạn',
                  ),
                  Gap(24.h),
                  AppTextfield(
                    controller:
                        context.read<StoreSignupCubit>().tagTxtController,
                    onChanged: (value) {
                      context.read<StoreSignupCubit>().onChangeSearchTag(value);
                    },
                    hintText: 'Vd: Japannese style',
                  ),
                  Gap(24.h),
                  if (state.selectedHashTags.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Wrap(
                        spacing: 10,
                        runSpacing: 12,
                        children: context
                            .read<StoreSignupCubit>()
                            .hashTags
                            .where(
                                (tag) => state.selectedHashTags.contains(tag))
                            .map((tag) {
                          return LocalHero(
                            tag: tag,
                            flightShuttleBuilder: (context, animation, child) {
                              return ScaleTransition(
                                scale: Tween<double>(begin: 0.0, end: 1.0)
                                    .animate(animation),
                                child: TagCustom(
                                  text: tag,
                                  bgColor: ColorName.greyBg,
                                  textColor: ColorName.dark,
                                ),
                              );
                            },
                            key: ValueKey(tag),
                            child: TagCustom(
                              text: tag,
                              onTap: () {
                                context
                                    .read<StoreSignupCubit>()
                                    .onUnSelectTag(tag);
                              },
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  Text(
                    'Đề xuất cho bạn',
                    style: context.textTheme.bodyMedium.copyWith(
                      color: ColorName.dark,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Gap(16.h),
                  Wrap(
                    spacing: 10,
                    runSpacing: 12,
                    children: context
                        .read<StoreSignupCubit>()
                        .hashTags
                        .where((tag) => !state.selectedHashTags.contains(tag))
                        .where((tag) => tag
                            .toLowerCase()
                            .contains(state.searchTagValue.toLowerCase()))
                        .map((tag) {
                      return LocalHero(
                        key: ValueKey(tag),
                        tag: tag,
                        child: TagCustom(
                          text: tag,
                          textColor: ColorName.dark,
                          bgColor: ColorName.greyBg,
                          onTap: () {
                            context.read<StoreSignupCubit>().onSelectTag(tag);
                          },
                        ),
                      );
                    }).toList(),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
