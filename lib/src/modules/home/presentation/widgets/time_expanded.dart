import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../../../../generated/colors.gen.dart';
import '../../../../common/extensions/build_context_x.dart';

Widget timeExpandedWidget(BuildContext context) {
  return SingleChildScrollView(
    physics: const NeverScrollableScrollPhysics(),
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(children: [
        Row(
          children: [
            Text(
              'Thứ 2',
              style:
                  context.textTheme.labelSmall.copyWith(color: ColorName.black),
            ),
            const Spacer(),
            Text('08:00 - 20:00',
                style: context.textTheme.labelSmall
                    .copyWith(color: ColorName.black))
          ],
        ),
        const Gap(4),
        Row(
          children: [
            Text(
              'Thứ 3',
              style:
                  context.textTheme.labelSmall.copyWith(color: ColorName.black),
            ),
            const Spacer(),
            Text('08:00 - 20:00',
                style: context.textTheme.labelSmall
                    .copyWith(color: ColorName.black))
          ],
        ),
        const Gap(4),
        Row(
          children: [
            Text(
              'Thứ 4',
              style:
                  context.textTheme.labelSmall.copyWith(color: ColorName.black),
            ),
            const Spacer(),
            Text('08:00 - 20:00',
                style: context.textTheme.labelSmall
                    .copyWith(color: ColorName.black))
          ],
        ),
        const Gap(4),
        Row(
          children: [
            Text(
              'Thứ 5',
              style:
                  context.textTheme.labelSmall.copyWith(color: ColorName.black),
            ),
            const Spacer(),
            Text('08:00 - 20:00',
                style: context.textTheme.labelSmall
                    .copyWith(color: ColorName.black))
          ],
        ),
        const Gap(4),
        Row(
          children: [
            Text(
              'Thứ 6',
              style:
                  context.textTheme.labelSmall.copyWith(color: ColorName.black),
            ),
            const Spacer(),
            Text('08:00 - 20:00',
                style: context.textTheme.labelSmall
                    .copyWith(color: ColorName.black))
          ],
        ),
        const Gap(4),
        Row(
          children: [
            Text(
              'Thứ 7',
              style:
                  context.textTheme.labelSmall.copyWith(color: ColorName.black),
            ),
            const Spacer(),
            Text('08:00 - 20:00',
                style: context.textTheme.labelSmall
                    .copyWith(color: ColorName.black))
          ],
        ),
        const Gap(4),
        Row(
          children: [
            Text(
              'Chủ nhật',
              style:
                  context.textTheme.labelSmall.copyWith(color: ColorName.black),
            ),
            const Spacer(),
            Text('Đóng cửa',
                style: context.textTheme.labelSmall
                    .copyWith(color: ColorName.black))
          ],
        ),
      ]),
    ),
  );
}
