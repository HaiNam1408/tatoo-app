import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../common/utils/image_converter.dart';
import '../../../../common/utils/logger.dart';
import '../../../../common/widgets/custom_date_picker.dart';
import '../../../../common/widgets/date_pick_time.dart';
import '../../domain/interface/schedule_work_repository_interface.dart';
import 'schedule_work_editing_success.dart';

part 'schedule_work_editing_state.dart';
part 'schedule_work_editing_cubit.freezed.dart';

class ScheduleWorkEditingCubit extends Cubit<ScheduleWorkEditingState> {
  final IScheduleWorkRepository _repository;
  final int id;
  ScheduleWorkEditingCubit(this._repository, this.id)
      : super(const ScheduleWorkEditingState.loaded(
            true, null, false, '', '', '', '', '', false, null, null, null)) {
    getScheduleWork(id);
  }

  AnimationController? _animationController;
  final TextEditingController _titleController = TextEditingController();
  TextEditingController get titleController => _titleController;
  bool get isInitialized => _animationController != null;

  Future<void> getScheduleWork(int id) async {
    final result = await _repository.getSheduleWork(id);
    return result.fold((success) {
      _titleController.text = success.title;
      emit(
        _Loaded(
            false,
            success.initial_date,
            success.is_important,
            success.time_start,
            success.time_end,
            success.title,
            success.content,
            success.attachment.filePath,
            false,
            null,
            null,
            null),
      );
    },
        (failure) =>
            emit(state.copyWith(isLoading: false, error: failure.message)));
  }

  void initialize(TickerProvider vsync) {
    if (!isInitialized) {
      _animationController = AnimationController(
        duration: const Duration(milliseconds: 500),
        vsync: vsync,
      )..forward();
      _titleController.addListener(onTitleChanged);
    }
  }

  void dispose() {
    _titleController.dispose();
    _animationController?.dispose();
  }

  void onDateChange(DateTime date) {
    emit(state.copyWith(selectDate: date));
  }

  void onTimeStartChange(String time) {
    emit(state.copyWith(timeStart: time));
  }

  void onTimeEndChange(String time) {
    emit(state.copyWith(timeEnd: time));
  }

  void toggleImportant() {
    emit(state.copyWith(isImportant: !state.isImportant));
  }

  void onTitleChanged() {
    onChangeTitle(_titleController.text);
  }

  void onChangeTitle(String title) {
    emit(state.copyWith(
      title: title,
      isFormValid: _validateForm(title: title),
    ));
  }

  bool _validateForm({String? title}) {
    final currentTitle = title ?? state.title;
    return currentTitle.isNotEmpty;
  }

  void onChangeImage(File? imagePath) {
    emit(state.copyWith(newImage: imagePath, imagePath: ''));
  }

  Future<void> pickImage() async {
    final XFile? pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      File imageFile = File(pickedImage.path);
      onChangeImage(imageFile);
    }
  }

  void removeImage() {
    onChangeImage(null);
  }

  String formatTimeFromInts(int hour, int minute) {
    return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
  }

  int getInitialHour(bool isStart) {
    final timeString = isStart ? state.timeStart : state.timeEnd;
    return int.tryParse(timeString.split(':').first) ?? DateTime.now().hour;
  }

  int getInitialMinute(bool isStart) {
    final timeString = isStart ? state.timeStart : state.timeEnd;
    return int.tryParse(timeString.split(':').last) ?? DateTime.now().minute;
  }

  Future<void> onSelectDate(BuildContext context) async {
    try {
      if (!isInitialized) return;
      _resetAndForwardAnimation();
      final DateTime? picked = await showDialog<DateTime>(
        context: context,
        barrierDismissible: true,
        builder: (context) => _buildAnimatedDialog(
          CustomDatePicker(
            initialDate: state.selectDate ?? DateTime.now(),
            onDateSelected: (date) => _onDatePicked(date),
          ),
        ),
      );
      if (picked != null) onDateChange(picked);
    } catch (e) {
      logger.d('Error showing date picker: $e');
    }
  }

  void _onDatePicked(DateTime date) {
    _reverseAnimation().then((_) => onDateChange(date));
  }

  Future<void> onSelectTime(BuildContext context, bool isStartTime) async {
    try {
      if (!isInitialized) return;
      _resetAndForwardAnimation();
      await showDialog<void>(
        context: context,
        builder: (context) => _buildAnimatedDialog(
          CustomTimePicker(
            initialHour: getInitialHour(isStartTime),
            initialMinute: getInitialMinute(isStartTime),
            onTimeSelected: (hour, minute) {
              final time = formatTimeFromInts(hour, minute);
              isStartTime ? onTimeStartChange(time) : onTimeEndChange(time);
            },
          ),
        ),
      );
    } catch (e) {
      logger.d('Error showing time picker: $e');
    }
  }

  void _resetAndForwardAnimation() {
    _animationController?.reset();
    _animationController?.forward();
  }

  Future<void> _reverseAnimation() async {
    await _animationController?.reverse();
  }

  Widget _buildAnimatedDialog(Widget child) {
    return Dialog(child: child);
  }

  Future<void> update(BuildContext context, String content) async {
    emit(state.copyWith(isLoading: true, error: null, isSucessful: null));
    final result = await _repository.updateSheduleWork(
        id,
        state.timeStart,
        state.timeEnd,
        _titleController.text,
        content,
        state.selectDate,
        state.isImportant,
        null,
        null,
        null,
        null,
        null,
        state.newImage != null ? await imageToMultiPart(state.newImage!) : null,
        state.imagePath.isEmpty);
    return result.fold(
        (success) => emit(state.copyWith(
            isLoading: false,
            isSucessful: const ScheduleWorkEditingSuccess.edited())),
        (failure) =>
            emit(state.copyWith(isLoading: false, error: failure.message)));
  }

  Future<void> delete() async {
    emit(state.copyWith(isLoading: true, error: null, isSucessful: null));
    final result = await _repository.deleteSheduleWork(id);

    return result.fold(
        (success) => emit(state.copyWith(
            isLoading: false,
            isSucessful: const ScheduleWorkEditingSuccess.deleted())),
        (failure) =>
            emit(state.copyWith(isLoading: false, error: failure.message)));
  }
}
