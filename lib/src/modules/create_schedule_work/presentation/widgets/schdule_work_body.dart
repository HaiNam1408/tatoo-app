import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'dart:io';
import '../../../../../generated/assets.gen.dart';
import '../../../../../generated/colors.gen.dart';
import '../../../../common/utils/logger.dart';
import '../../../../common/utils/show_toast.dart';
import '../../../../common/widgets/app_dialogs.dart';
import '../../../tabbar/application/tabbar_cubit.dart';
import '../../application/schedule_work_cubit.dart';
import '../../application/schedule_work_state.dart';

class ScheduleWorkBody extends StatefulWidget {
  final Function(File?) onImageSelected;
  const ScheduleWorkBody({super.key, required this.onImageSelected});

  @override
  State<ScheduleWorkBody> createState() => _ScheduleWorkBodyState();
}

class _ScheduleWorkBodyState extends State<ScheduleWorkBody>
    with TickerProviderStateMixin {
  final _noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<ScheduleWorkCubit>().initialize(this);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocConsumer<ScheduleWorkCubit, ScheduleState>(
        listener: (context, state) {
          logger.d(state);
          //create schedule work successfully
          if (state.isSucessful) {
            CustomToast.show(context: context, message: 'Tạo lịch thành công');
            //change to home tab
            context.read<TabbarCubit>().onTapItem(0);
            //clear state
            context.read<ScheduleWorkCubit>().clearState();
            _noteController.text = '';
          } else if (state.error != null) {
            AppDialogs.show(type: AlertType.error, content: state.error!);
          }
        },
        builder: (context, state) {
          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              _buildHeaderRow(context, state),
              const Gap(30),
              _buildTitleInput(context),
              const Gap(20),
              _buildImagePicker(context, state),
              const Gap(20),
              _buildTimePickers(context, state),
              const Gap(20),
              _buildNoteInput(),
            ],
          );
        },
      ),
    );
  }

  Row _buildHeaderRow(BuildContext context, ScheduleState state) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildDatePicker(context, state),
        Row(
          children: [
            _buildStarIcon(context, state),
            const SizedBox(width: 16),
            _buildCloseOrAdd(context, state),
          ],
        ),
      ],
    );
  }

  Row _buildDatePicker(BuildContext context, ScheduleState state) {
    return Row(
      children: [
        Assets.icons.calendarPicker.svg(height: 24),
        const SizedBox(width: 10),
        GestureDetector(
          onTap: () => context.read<ScheduleWorkCubit>().selectDate(context),
          child: Text(
            'T${state.selectDate?.weekday ?? DateTime.now().weekday}, ${state.selectDate?.day ?? DateTime.now().day} Th${state.selectDate?.month ?? DateTime.now().month}',
            style: const TextStyle(
                fontSize: 14, fontWeight: FontWeight.w400, color: Colors.black),
          ),
        ),
      ],
    );
  }

  GestureDetector _buildStarIcon(BuildContext context, ScheduleState state) {
    return GestureDetector(
      onTap: () => context.read<ScheduleWorkCubit>().toggleImportant(),
        child: state.isImportant
            ? Assets.icons.starFilled.svg(height: 24)
            : Assets.icons.starOutline.svg(height: 24)
    );
  }

  GestureDetector _buildCloseOrAdd(BuildContext context, ScheduleState state) {
    return GestureDetector(
        onTap: state.isFormValid
            ? () {
                //tap to add button
                context
                    .read<ScheduleWorkCubit>()
                    .createScheduleWork(context, _noteController.text);
              }
            : () {
                //tap to close button
              },
        child: state.isFormValid
            ? Container(
                decoration: const BoxDecoration(
                    color: Color.fromRGBO(191, 195, 198, 1),
                    borderRadius: BorderRadius.all(Radius.circular(25))),
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: Row(
                    children: [
                      Icon(
                        Icons.add,
                        size: 25,
                      ),
                      Gap(10),
                      Text(
                        'Thêm',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                ),
              )
            : Assets.icons.close.svg());
  }

  BlocBuilder<ScheduleWorkCubit, ScheduleState> _buildTitleInput(
      BuildContext context) {
    return BlocBuilder<ScheduleWorkCubit, ScheduleState>(
      buildWhen: (previous, current) => previous.title != current.title,
      builder: (context, state) {
        return TextField(
          controller: context.read<ScheduleWorkCubit>().titleController,
          onChanged: (value) {
            context.read<ScheduleWorkCubit>().updateTitle(value);
          },
          style: const TextStyle(
              fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
          decoration: const InputDecoration(
            hintText: 'Tiêu đề',
            hintStyle: TextStyle(
                color: Colors.grey, fontSize: 24, fontWeight: FontWeight.w700),
            border: InputBorder.none,
          ),
        );
      },
    );
  }

  Widget _buildImagePicker(BuildContext context, ScheduleState state) {
    return BlocBuilder<ScheduleWorkCubit, ScheduleState>(
        builder: (context, state) {
      return Row(
        mainAxisAlignment: state.imagePath == null
            ? MainAxisAlignment.start
            : MainAxisAlignment.center,
        children: [
          state.imagePath == null
              ? GestureDetector(
                  onTap: context.read<ScheduleWorkCubit>().pickImage,
                  child: DottedBorder(
                    color: ColorName.greyText,
                    strokeWidth: 1,
                    dashPattern: const [6, 3],
                    borderType: BorderType.RRect,
                    radius: const Radius.circular(10),
                    child: Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(child: Assets.icons.galleryAdd.svg()
                      ),
                    ),
                  ),
                )
              : SizedBox(
                  width: MediaQuery.sizeOf(context).width - 32,
                  child: Stack(
                    children: [
                      Center(
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                              maxWidth: MediaQuery.sizeOf(context).width - 200,
                              maxHeight: 200),
                          child:
                              Image.file(state.imagePath!, fit: BoxFit.contain),
                        ),
                      ),
                      Positioned(
                        top: 5,
                        right: 0,
                        child: Container(
                          width: 72,
                          height: 32,
                          padding: const EdgeInsets.only(left: 10),
                          decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(20)),
                          child: Row(
                            children: [
                              GestureDetector(
                                behavior: HitTestBehavior.translucent,
                                onTap: () {
                                  context.read<ScheduleWorkCubit>().pickImage();
                                },
                                child: Assets.icons.galleryEdit.svg(),
                              ),
                              const Gap(8),
                              GestureDetector(
                                onTap: () {
                                  context
                                      .read<ScheduleWorkCubit>()
                                      .removeImage();
                                },
                                child: Assets.icons.close.svg(
                                    colorFilter: const ColorFilter.mode(
                                        ColorName.primary, BlendMode.srcIn)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
        ],
      );
    });
  }

  Column _buildTimePickers(BuildContext context, ScheduleState state) {
    return Column(
      children: [
        _buildTimePickerRow('Bắt đầu', state.timeStart,
            () => context.read<ScheduleWorkCubit>().selectTime(context, true)),
        const Gap(10),
        _buildTimePickerRow('Kết thúc', state.timeEnd,
            () => context.read<ScheduleWorkCubit>().selectTime(context, false)),
      ],
    );
  }

  Row _buildTimePickerRow(String label, String? time, VoidCallback onTap) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: ColorName.dark)),
        GestureDetector(
          onTap: onTap,
          child: Text(time ?? '00:00',
              style: const TextStyle(color: ColorName.dark)),
        ),
      ],
    );
  }

  TextField _buildNoteInput() {
    return TextField(
      controller: _noteController,
      style: const TextStyle(fontSize: 16, color: Colors.black),
      cursorColor: Colors.black,
      decoration: const InputDecoration(
        hintText: 'Ghi chú',
        hintStyle: TextStyle(color: ColorName.greyText),
        border: InputBorder.none,
      ),
      maxLines: null,
    );
  }
}
