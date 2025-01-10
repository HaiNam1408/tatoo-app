import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';

import '../../../../../generated/colors.gen.dart';
import '../../../../common/extensions/build_context_x.dart';

class HeaderSignupWidget extends StatelessWidget {
  const HeaderSignupWidget(
      {super.key,
      required this.svg,
      required this.title,
      required this.subTitle});
  final SvgPicture svg;
  final String title;
  final String subTitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          backgroundColor: ColorName.dark,
          child: svg,
        ),
        const Gap(16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: context.textTheme.bodyLarge.copyWith(
                      fontWeight: FontWeight.w700, color: ColorName.dark)),
              Gap(4.h),
              Text(
                subTitle,
                softWrap: true,
                maxLines: 2,
                style: context.textTheme.bodyMedium
                    .copyWith(color: ColorName.dark),
              ),
            ],
          ),
        )
      ],
    );
  }
}
