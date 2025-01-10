import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../../../generated/assets.gen.dart';
import '../../../../../generated/colors.gen.dart';
import '../../../../common/extensions/build_context_x.dart';
import '../../../../common/utils/logger.dart';
import '../../../../common/utils/show_toast.dart';
import '../../../../common/widgets/app_dialogs.dart';
import '../../../../common/widgets/back_botton.dart';
import '../../../../common/widgets/option_select_widget.dart';
import 'package:latlong2/latlong.dart';

import '../../../../core/infrastructure/models/profile.dart';
import '../../application/shop_infor_cubit.dart';
import '../../application/shop_infor_state.dart';
import 'star_rating.dart';

class ShopInforBody extends StatelessWidget {
  final ProfileModel? profile;
  const ShopInforBody({
    super.key,
    this.profile,
  });

  @override
  Widget build(BuildContext context) {
    List<String> tags =
        profile?.profileTag?.map((tag) => tag.tags.name).toList() ?? [];

    return BlocListener<ShopInforCubit, ShopInforState>(
      listener: (context, state) {
        if (state.error != null) {
          AppDialogs.show(type: AlertType.error, content: state.error!);
        } else if (state.isRatingSuccess != null) {
          CustomToast.show(context: context, message: 'Đánh giá thành công');
        }
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        color: ColorName.primary,
        child: SafeArea(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const AppBackButton(),
                Gap(8.w),
                Text(
                  'Thông tin',
                  style: context.textTheme.bodyMedium.copyWith(
                      color: ColorName.dark,
                      fontWeight: FontWeight.w500,
                      fontSize: 16),
                ),
                const Spacer(),
                InkWell(
                  onTap: () {},
                  child: Assets.icons.export.svg(),
                ),
                Gap(12.w),
                InkWell(
                  onTap: () {},
                  child: Assets.icons.flag.svg(),
                )
              ],
            )),
            Gap(24.h),
            Text(profile?.storeName ?? 'Shop Name',
                style: context.textTheme.headlineLarge.copyWith(
                    fontSize: 24.h,
                    color: ColorName.black,
                    fontWeight: FontWeight.w700)),
            Gap(16.h),
            Row(
              children: [
                Text('Mọi người đánh giá',
                    style: context.textTheme.bodySmall.copyWith(
                      color: ColorName.black,
                    )),
                const Spacer(),
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    RatingBar.builder(
                      itemBuilder: (context, _) =>
                          Assets.icons.starFilled.svg(),
                      onRatingUpdate: (rating) {},
                      initialRating: profile?.averageRating ?? 0,
                      ignoreGestures: true,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemSize: 16,
                      itemPadding: const EdgeInsets.symmetric(horizontal: 1.0),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 4),
                      child: Text(
                          '(${profile?.averageRating?.toString() ?? '0'})',
                          style: context.textTheme.bodySmall
                              .copyWith(color: ColorName.black)),
                    ),
                  ],
                )
              ],
            ),
            Gap(16.h),
            Wrap(
                direction: Axis.horizontal,
                spacing: 12,
                alignment: WrapAlignment.start,
                runSpacing: 12,
                children: List<Widget>.generate(tags.length, (element) {
                  return FittedBox(
                    child: OptionSelectWidget(
                        text: tags[element],
                        isSelected: true,
                        onTap: () {
                          //TODO: tap on Tag
                        }),
                  );
                })),
            Gap(24.h),
            ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Container(
                  height: 160.h,
                  color: Colors.amber,
                  child: FlutterMap(
                      options: const MapOptions(
                        // TODO: hard code maps
                        initialCenter: LatLng(21.028984, 105.844687),
                        minZoom: 15,
                        maxZoom: 15,
                        initialZoom: 15,
                      ),
                      children: [
                        TileLayer(
                          urlTemplate:
                              'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        ),
                        MarkerLayer(
                          markers: [
                            Marker(
                              point: const LatLng(21.028984, 105.844687),
                              width: 36.sp,
                              height: 36.sp,
                              child: Assets.icons.location.svg(),
                            ),
                          ],
                        ),
                      ]),
                )),
            Gap(16.h),
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(right: 8.w),
                  child: Assets.icons.location.svg(),
                ),
                Expanded(
                  child: Text(
                    profile?.address?.toCustomString() ??
                        '12 Đền Lừ 3, Hoàng Văn Thụ, Hoàng Mai, Hà Nội',
                    style: context.textTheme.bodySmall.copyWith(
                      color: ColorName.black,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                )
              ],
            ),
            Gap(32.h),
            //rating
            Center(
              child: Column(
                children: [
                  Text(
                    'Xếp hạng và đánh giá của bạn',
                    style: context.textTheme.bodySmall.copyWith(
                      color: ColorName.black,
                    ),
                  ),
                  Gap(12.h),
                  StarRating(
                    onRating: (rating) {
                      logger.d('On rating $rating');
                      onRating(context, rating);
                    },
                  )
                ],
              ),
            )
          ],
        )),
      ),
    );
  }

  void onRating(BuildContext context, double rating) {
    AppDialogs.show(
      type: AlertType.warning,
      content: 'Bạn chắc chắn muốn đánh giá shop này',
      titleAction1: 'Ok',
      action1: () => context.read<ShopInforCubit>().rating(rating),
      titleAction2: 'Hủy',
    );
  }
}
