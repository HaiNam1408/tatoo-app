import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../generated/colors.gen.dart';
import '../../../../common/extensions/build_context_x.dart';
import '../../application/appointment_cubit.dart';
import '../../application/appointment_state.dart';

class WeeklyDateTimeLine extends StatefulWidget {
  const WeeklyDateTimeLine({super.key});

  @override
  State<WeeklyDateTimeLine> createState() => _WeeklyDateTimeLineState();
}

class _WeeklyDateTimeLineState extends State<WeeklyDateTimeLine> {
  final DateTime _startDate = DateTime(2000, 1, 1);
  final DateTime _endDate = DateTime(2100, 12, 31);

  DateTime getStartOfWeek(DateTime date) {
    return date.subtract(Duration(days: date.weekday - 1));
  }

  int getWeeksBetween(DateTime start, DateTime end) {
    final validStart = start.isBefore(_startDate) ? _startDate : start;
    final validEnd = end.isAfter(_endDate) ? _endDate : end;
    return (validEnd.difference(validStart).inDays / 7).round();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppointmentCubit, AppointmentState>(
      builder: (context, state) {
        final DateTime firstDate = _startDate;

        return PageView.builder(
          controller: context.read<AppointmentCubit>().pageController,
          itemCount: getWeeksBetween(_startDate, _endDate),
          itemBuilder: (context, index) {
            final DateTime weekStart = firstDate.add(Duration(days: 7 * index));

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(7, (dayIndex) {
                  final date = weekStart.add(Duration(days: dayIndex + 2));
                  final isSelected = date.year == state.selectedDate?.year &&
                      date.month == state.selectedDate?.month &&
                      date.day == state.selectedDate?.day;
                  final dayStr =
                      date.weekday == 7 ? 'CN' : 'T${date.weekday + 1}';
                  final dayNum = date.day.toString().padLeft(2, '0');

                  return GestureDetector(
                    key: ValueKey(date),
                    onTap: () {
                      context.read<AppointmentCubit>().onDateChange(date);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border(
                          bottom: BorderSide(
                            color: isSelected
                                ? ColorName.white
                                : Colors.transparent,
                            width: 4.5,
                          ),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(dayStr,
                              style: context.textTheme.bodySmall.copyWith(
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              )),
                          Text(dayNum,
                              style: context.textTheme.regular.copyWith(
                                fontSize: 12,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              )),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            );
          },
          onPageChanged: (index) {
            // Optionally, update something when the page changes
          },
        );
      },
    );
  }
}
