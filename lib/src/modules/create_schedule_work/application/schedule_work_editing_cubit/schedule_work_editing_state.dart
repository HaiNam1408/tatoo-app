part of 'schedule_work_editing_cubit.dart';

@freezed
class ScheduleWorkEditingState with _$ScheduleWorkEditingState {
  const factory ScheduleWorkEditingState.loaded(
    final bool isLoading,
    final DateTime? selectDate,
    final bool isImportant,
    final String timeStart,
    final String timeEnd,
    final String title,
    final String note,
    final String imagePath,
    final bool isFormValid,
    final ScheduleWorkEditingSuccess? isSucessful,
    final String? error,
    final File? newImage,
  ) = _Loaded;
}
