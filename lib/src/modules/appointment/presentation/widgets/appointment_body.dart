import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import '../../../../../generated/assets.gen.dart';
import '../../../../../generated/colors.gen.dart';
import '../../../../common/extensions/build_context_x.dart';
import '../../../app/app_router.dart';
import '../../application/appointment_cubit.dart';
import '../../application/appointment_state.dart';
import 'appointment_daily_view.dart';
import 'appointment_weekly_view.dart';
import 'weekly_date_time_line.dart';

class AppointmentBody extends StatelessWidget {
  const AppointmentBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppointmentCubit, AppointmentState>(
      builder: (context, state) => DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(160),
            child: AppBar(
              backgroundColor: ColorName.dark,
              elevation: 0,
              flexibleSpace: Padding(
                padding: const EdgeInsets.only(top: 40, left: 16, right: 16),
                child: Column(
                  children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              context
                                  .read<AppointmentCubit>()
                                  .scrollToSelectedDate();
                            },
                            child: Row(children: [
                              Text(
                                '${state.selectedDate?.day.toString().padLeft(2, '0')}',
                                style: context.textTheme.bold.copyWith(
                                    fontSize: 48, color: ColorName.primary),
                              ),
                              const Gap(4),
                              Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('${state.selectedDate?.year}',
                                        style: context.textTheme.medium
                                            .copyWith(
                                                color: ColorName.primary)),
                                    // TODO: localize
                                    Text('Tháng ${state.selectedDate?.month}',
                                        style: context.textTheme.medium
                                            .copyWith(
                                                fontSize: 20,
                                                color: ColorName.primary)),
                                  ])
                            ]),
                          ),
                          IconButton(
                            onPressed: () {
                              context
                                  .read<AppointmentCubit>()
                                  .showDatePicker(context);
                            },
                            icon: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: ColorName.primary,
                                borderRadius: BorderRadius.circular(24),
                              ),
                              child: Assets.icons.calendarSearch.svg(),
                            ),
                          )
                        ]),
                    TabBar(
                      indicator: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      labelColor: Colors.black,
                      unselectedLabelColor: Colors.white,
                      dividerColor: Colors.transparent,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      labelPadding: const EdgeInsets.symmetric(horizontal: 0),
                      onTap: (value) {
                        context.read<AppointmentCubit>().onTabChange(value);
                      },
                      tabs: [
                        Container(
                          width: double.maxFinite,
                          height: 37,
                          margin: const EdgeInsets.only(right: 8),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white),
                            borderRadius: BorderRadius.circular(24),
                            color: state.selectedTab == 0
                                ? ColorName.primary
                                : Colors.transparent,
                          ),
                          child: const Center(
                            child: Text(
                              // TODO: localize
                              'Ngày',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        Container(
                          width: double.maxFinite,
                          height: 37,
                          margin: const EdgeInsets.only(left: 8),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white),
                            borderRadius: BorderRadius.circular(24),
                            color: state.selectedTab == 1
                                ? ColorName.primary
                                : Colors.transparent,
                          ),
                          child: const Center(
                            child: Text(
                              // TODO: localize
                              'Tuần',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          body: Stack(
            children: [
              Positioned.fill(
                child: Container(
                  color: ColorName.dark,
                ),
              ),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: AnimatedSlide(
                  duration: const Duration(milliseconds: 300),
                  offset: Offset(state.selectedTab == 0 ? 0 : -1, 0),
                  child: AnimatedScale(
                      duration: const Duration(milliseconds: 300),
                      scale: state.selectedTab == 0 ? 1 : 0,
                      child: Container(
                          color: ColorName.dark,
                          height: 48,
                          child: const WeeklyDateTimeLine())),
                ),
              ),
              AnimatedPositioned(
                duration: const Duration(milliseconds: 300),
                top: state.selectedTab == 0 ? 45 : 0,
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  decoration: const BoxDecoration(
                    color: ColorName.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                  ),
                  child: TabBarView(
                    clipBehavior: Clip.antiAlias,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      AppointmentDailyView(
                        state: state,
                        onTapTaskCard: (id) {
                          context.router.push(ScheduleWorkEditingRoute(id: id));
                        },
                      ),
                      AppointmentWeeklyView(state: state)
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
