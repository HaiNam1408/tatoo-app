import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../../../generated/assets.gen.dart';
import '../../../../../generated/colors.gen.dart';
import '../../../../common/extensions/build_context_x.dart';
import '../../../../common/extensions/shimmer_effect.dart';
import '../../application/appointment_cubit.dart';
import '../../application/appointment_state.dart';
import '../../../../core/infrastructure/datasources/remote/api/services/appointment/models/appointment_model.dart';

class AppointmentWeeklyView extends StatelessWidget {
  final AppointmentState state;
  const AppointmentWeeklyView({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      effect: CustomShimmerEffect.shimmerEffect,
      enabled: state.isLoadingWeeklyView,
      child: RefreshIndicator(
        color: ColorName.dark,
        backgroundColor: ColorName.primary,
        onRefresh: () async {
          context.read<AppointmentCubit>().fetchWeekAppointments();
        },
        child: state.weeklyAppointments.isEmpty
            ? SizedBox(
                width: MediaQuery.sizeOf(context).width,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Gap(140.h),
                    Assets.icons.calenderBoard.svg(),
                    Text(
                      'Lên lịch nào!',
                      style: context.textTheme.titleSmall
                          .copyWith(color: ColorName.greyText),
                    )
                  ],
                ),
              )
            : ListView.separated(
                padding: const EdgeInsets.only(
                    top: 16, left: 16, right: 16, bottom: 100),
                itemCount: state.isLoadingWeeklyView
                    ? state.mockWeeklyAppointments.length
                    : state.weeklyAppointments.length,
                separatorBuilder: (_, __) =>
                    const Divider(thickness: 1, height: 48),
                physics: const BouncingScrollPhysics()
                    .applyTo(const AlwaysScrollableScrollPhysics()),
                itemBuilder: (context, index) {
                  final isLoading = state.isLoadingWeeklyView;
                  List<String> label = isLoading
                      ? state.mockWeeklyAppointments[index].date.split(', ')
                      : state.weeklyAppointments[index].date.split(', ');
                  String weeklable = label[0];
                  String dayLabel = label[1].split('/')[0];
                  String monthLabel = label[1].split('/')[1];
                  List<AppointmentModel> appointments = isLoading
                      ? state.mockWeeklyAppointments[index].data
                      : state.weeklyAppointments[index].data;

                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            weeklable,
                            style: context.textTheme.bold
                                .copyWith(color: ColorName.dark, fontSize: 20),
                          ),
                          Column(
                            children: [
                              Text(
                                dayLabel,
                                style: context.textTheme.regular.copyWith(
                                  color: ColorName.dark,
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.symmetric(vertical: 2),
                                width: 18,
                                height: 1,
                                color: ColorName.dark,
                              ),
                              Text(
                                monthLabel,
                                style: context.textTheme.regular.copyWith(
                                  color: ColorName.dark,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const Gap(16),
                      Expanded(
                        child: Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: appointments
                              .map((appointment) =>
                                  AppointmentCard(appointment: appointment))
                              .toList(),
                        ),
                      )
                    ],
                  );
                },
              ),
      ),
    );
  }
}

class AppointmentCard extends StatelessWidget {
  const AppointmentCard({
    super.key,
    required this.appointment,
  });

  final AppointmentModel appointment;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 95.w,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: appointment.is_important ? ColorName.dark : ColorName.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ColorName.dark),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${appointment.time_start}\n-\n${appointment.time_end}',
                    style: context.textTheme.labelMedium.copyWith(
                        color: appointment.is_important
                            ? ColorName.white
                            : ColorName.dark,
                        height: 1.2),
                  ),
                ],
              ),
              if (appointment.is_important) Assets.icons.starRounded.svg()
            ],
          ),
          const Gap(8),
          Text(
            appointment.content,
            style: context.textTheme.bold.copyWith(
                fontSize: 12,
                color: appointment.is_important
                    ? ColorName.white
                    : ColorName.dark),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
