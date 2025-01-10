import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../../common/utils/image_converter.dart';
import '../../../common/utils/logger.dart';
import '../../../common/widgets/custom_date_picker.dart';
import '../../../common/widgets/date_pick_time.dart';
import '../domain/interface/schedule_work_repository_interface.dart';
import 'schedule_work_state.dart';

class ScheduleWorkCubit extends Cubit<ScheduleState> {
  final IScheduleWorkRepository _repository;

  ScheduleWorkCubit(this._repository) : super(const ScheduleState());

  AnimationController? _animationController;
  final TextEditingController _titleController = TextEditingController();
  TextEditingController get titleController => _titleController;
  bool get isInitialized => _animationController != null;

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
    updateTitle(_titleController.text);
  }

  void updateTitle(String title) {
    emit(state.copyWith(
      title: title,
      isFormValid: _validateForm(title: title),
    ));
  }

  void updateNote(String note) {
    emit(state.copyWith(note: note));
  }

  bool _validateForm({String? title, File? imagePath}) {
    final currentTitle = title ?? state.title;
    final currentImagePath = imagePath ?? state.imagePath;
    return currentTitle.isNotEmpty || currentImagePath != null;
  }

  void updateImage(File? imagePath) {
    emit(state.copyWith(
      imagePath: imagePath,
      isFormValid: _validateForm(imagePath: imagePath),
    ));
  }

  Future<void> pickImage() async {
    final XFile? pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      File imageFile = File(pickedImage.path);
      updateImage(imageFile);
    }
  }

  void removeImage() {
    updateImage(null);
    emit(state.copyWith(
      isFormValid: _validateForm(imagePath: null),
    ));
  }

  String formatTimeFromInts(int hour, int minute) {
    return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
  }

  int getInitialHour(bool isStart) {
    final timeString = isStart ? state.timeStart : state.timeEnd;
    return int.tryParse(timeString?.split(':').first ?? '') ??
        DateTime.now().hour;
  }

  int getInitialMinute(bool isStart) {
    final timeString = isStart ? state.timeStart : state.timeEnd;
    return int.tryParse(timeString?.split(':').last ?? '') ??
        DateTime.now().minute;
  }

  Future<void> selectDate(BuildContext context) async {
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
      // print('Error showing date picker: $e');
    }
  }

  void _onDatePicked(DateTime date) {
    _reverseAnimation().then((_) => onDateChange(date));
  }

  Future<void> selectTime(BuildContext context, bool isStartTime) async {
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
      // print('Error showing time picker: $e');
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

  Future<void> createScheduleWork(BuildContext context, String content) async {
    emit(state.copyWith(isLoading: true, isSucessful: false, error: null));

    if (state.timeStart!.compareTo(state.timeEnd!) >= 0) {
      emit(state.copyWith(
          isLoading: false, error: 'Giờ bắt đầu cần nhỏ hơn giờ kết thúc'));
    } else {
      if (state.imagePath != null) {
        //convert images to MultipartFile
        final image = await imageToMultiPart(state.imagePath!);

        final result = await _repository.createSheduleWork(
          state.timeStart ?? '',
          state.selectDate ?? DateTime.now(),
          state.timeEnd ?? '',
          state.title,
          content,
          state.isImportant,
          image,
        );
        return result.fold((success) {
          emit(
              state.copyWith(isLoading: false, isSucessful: true, error: null));
        }, (failure) {
          emit(state.copyWith(
              isLoading: false, error: failure.message, isSucessful: false));
        });
      }
    }
  }

  void clearState() {
    _titleController.text = '';
    emit(state.copyWith(
      selectDate: null,
      isImportant: false,
      timeStart: '00:00',
      timeEnd: '00:00',
      title: null,
      note: null,
      isFormValid: false,
      isSucessful: false,
      error: null,
      imagePath: null,
    ));
  }
}
