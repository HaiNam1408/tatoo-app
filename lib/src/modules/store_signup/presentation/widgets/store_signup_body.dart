import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import '../../../../../generated/assets.gen.dart';
import '../../../../../generated/colors.gen.dart';
import '../../../../common/extensions/build_context_x.dart';
import '../../../../common/widgets/app_button.dart';
import '../../application/store_signup_cubit.dart';
import '../../application/store_signup_state.dart';
import 'store_signup_step1_widget.dart';
import 'store_signup_step2_widget.dart';
import 'store_signup_step3_widget.dart';
import 'store_signup_step4_widget.dart';

class StoreSignupBody extends StatelessWidget {
  const StoreSignupBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24.0.w, vertical: 24.0.h),
        child: BlocBuilder<StoreSignupCubit, StoreSignupState>(
          builder: (context, state) {
            return Column(
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        context.read<StoreSignupCubit>().backToStep(context);
                      },
                      child: Assets.icons.arrowLeft.svg(),
                    ),
                    const Spacer(),
                    Text(
                      'Bước ${state.step}/4',
                      style: context.textTheme.bodySmall
                          .copyWith(color: ColorName.dark),
                    )
                  ],
                ),
                Gap(24.h),
                Expanded(
                  child: PageView(
                    physics: const NeverScrollableScrollPhysics(),
                    controller: context.read<StoreSignupCubit>().stepController,
                    scrollDirection: Axis.horizontal,
                    children: [
                      StoreSignupStep1Widget(
                        onSelected: (isChecked) => context
                            .read<StoreSignupCubit>()
                            .checkedTerms(isChecked),
                      ),
                      const StoreSignupStep2Widget(),
                      const StoreSignupStep3Widget(),
                      const StoreSignupStep4Widget(),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: AppButton(
                        title: 'Quay lại',
                        darkButton: false,
                        onTap: () {
                          context.read<StoreSignupCubit>().backToStep(context);
                        },
                      ),
                    ),
                    Gap(12.w),
                    Expanded(
                      flex: 1,
                      child: AppButton(
                        title: 'Tiếp tục',
                        darkButton: true,
                        onTap: () =>
                            context
                            .read<StoreSignupCubit>()
                            .nextToStep(context),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
