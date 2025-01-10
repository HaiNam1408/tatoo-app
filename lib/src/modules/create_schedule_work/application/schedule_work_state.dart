import 'dart:io';

class ScheduleState {
  final bool isLoading;
  final DateTime? selectDate;
  final bool isImportant;
  final String? timeStart;
  final String? timeEnd;
  final String title;
  final String note;
  final File? imagePath;
  final bool isFormValid;
  final bool isSucessful;
  final String? error;
  static const sentinelFile = Object();

  const ScheduleState({
    this.isLoading = false,
    this.selectDate,
    this.isImportant = false,
    this.timeStart,
    this.timeEnd,
    this.title = '',
    this.note = '',
    this.imagePath,
    this.isFormValid = false,
    this.isSucessful = false,
    this.error
  });

  ScheduleState copyWith({
    bool? isLoading,
    DateTime? selectDate,
    bool? isImportant,
    String? timeStart,
    String? timeEnd,
    String? title,
    String? note,
    bool? isFormValid,
    bool? isSucessful,
    String? error,
    Object? imagePath = sentinelFile, 
  }) {
    return ScheduleState(
      isLoading: isLoading ?? this.isLoading,
      selectDate: selectDate ?? this.selectDate,
      isImportant: isImportant ?? this.isImportant,
      timeStart: timeStart ?? this.timeStart,
      timeEnd: timeEnd ?? this.timeEnd,
      title: title ?? this.title,
      note: note ?? this.note,
      imagePath: imagePath == sentinelFile ? this.imagePath : imagePath as File?,
      isFormValid: isFormValid ?? this.isFormValid,
      isSucessful: isSucessful ?? this.isSucessful,
      error: error
    );
  }
}