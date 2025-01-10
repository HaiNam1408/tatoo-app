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

class AppointmentDailyView extends StatelessWidget {
  final AppointmentState state;
  final Function(int id) onTapTaskCard;
  const AppointmentDailyView(
      {super.key, required this.state, required this.onTapTaskCard});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: state.dailyAppointments.isEmpty
          ? Column(
              children: [
                Gap(140.h),
                Assets.icons.calenderBoard.svg(),
                Text(
                  'Lên lịch nào!',
                  style: context.textTheme.titleSmall
                      .copyWith(color: ColorName.greyText),
                )
              ],
            )
          : Skeletonizer(
              effect: CustomShimmerEffect.shimmerEffect,
              enabled: state.isLoadingDailyView,
              child: GridView.builder(
                clipBehavior: Clip.none,
                padding: const EdgeInsets.only(bottom: 100),
                physics: const BouncingScrollPhysics()
                    .applyTo(const AlwaysScrollableScrollPhysics()),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1,
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                ),
                itemCount: state.isLoadingDailyView
                    ? state.mockDailyAppointments.length
                    : state.dailyAppointments.length,
                itemBuilder: (context, index) {
                  final appointment = state.isLoadingDailyView
                      ? state.mockDailyAppointments[index]
                      : state.dailyAppointments[index];
                  return TaskCard(
                    id: appointment.id,
                    title: appointment.title,
                    description: appointment.content,
                    isImportant: appointment.is_important,
                    startTime: appointment.time_start,
                    endTime: appointment.time_end,
                    isDone: appointment.is_done,
                    onTapTaskCard: (id) => onTapTaskCard(id),
                  );
                },
              ),
            ),
    );
  }
}

class TaskCard extends StatefulWidget {
  final int id;
  final String title;
  final String description;
  final String startTime;
  final String endTime;
  final bool isImportant;
  final bool isDone;
  final Function(int id) onTapTaskCard;

  const TaskCard(
      {super.key,
      required this.id,
      required this.title,
      required this.description,
      required this.isImportant,
      required this.startTime,
      required this.endTime,
      this.isDone = false,
      required this.onTapTaskCard});

  @override
  TaskCardState createState() => TaskCardState();
}

class TaskCardState extends State<TaskCard> {
  late double _cardWidth;
  late double _oldCardWidth;

  @override
  void initState() {
    super.initState();
    _cardWidth = 0;
    _oldCardWidth = 0;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => widget.onTapTaskCard(widget.id),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final double minCardWidth = constraints.maxWidth * 0.8;
          final double initialWidth =
              widget.isDone ? constraints.maxWidth * 0.8 : constraints.maxWidth;

          // Set initial width if not yet initialized
          if (_cardWidth == 0) {
            _cardWidth = initialWidth;
          }

          return SizedBox(
            width: initialWidth,
            child: Stack(
              children: [
                Positioned.fill(
                  child: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    decoration: BoxDecoration(
                      color: widget.isImportant
                          ? Colors.white
                          : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(16.0),
                      border: Border.all(width: 1.0, color: Colors.black),
                    ),
                    child: const Icon(
                      Icons.check,
                      color: Colors.black,
                      size: 24.0,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  top: 0,
                  child: GestureDetector(
                    onHorizontalDragUpdate: (details) {
                      setState(() {
                        _cardWidth = (_cardWidth + details.delta.dx)
                            .clamp(minCardWidth, constraints.maxWidth);
                      });
                    },
                    onHorizontalDragEnd: (details) {
                      setState(() {
                        _oldCardWidth = widget.isDone
                            ? constraints.maxWidth * 0.8
                            : constraints.maxWidth;

                        if (_cardWidth < (constraints.maxWidth * 5 / 6)) {
                          _cardWidth = minCardWidth;
                        } else {
                          _cardWidth = constraints.maxWidth;
                        }
                      });
                      if (_oldCardWidth != _cardWidth) {
                        context
                            .read<AppointmentCubit>()
                            .updateAppointmentStatus(
                                widget.id, _cardWidth == minCardWidth);
                      }
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 100),
                      width: _cardWidth,
                      decoration: BoxDecoration(
                        color: widget.isImportant
                            ? ColorName.dark
                            : ColorName.white,
                        borderRadius: BorderRadius.circular(16.0),
                        border: Border.all(width: 1.0, color: ColorName.dark),
                      ),
                      height: initialWidth,
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Text(
                                    widget.title,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 3,
                                    softWrap: true,
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                      color: widget.isImportant
                                          ? ColorName.white
                                          : ColorName.dark,
                                    ),
                                  ),
                                ),
                                if (widget.isImportant)
                                  Assets.icons.starRounded.svg()
                              ],
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          Text(
                            widget.description,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: TextStyle(
                              fontSize: 14.0,
                              color: widget.isImportant
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          Text(
                            '${widget.startTime} - ${widget.endTime}',
                            style: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                              color: widget.isImportant
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
