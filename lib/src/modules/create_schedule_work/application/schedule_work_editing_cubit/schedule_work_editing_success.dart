import 'package:freezed_annotation/freezed_annotation.dart';

part 'schedule_work_editing_success.freezed.dart';

@freezed
class ScheduleWorkEditingSuccess with _$ScheduleWorkEditingSuccess {
  const factory ScheduleWorkEditingSuccess.edited() = _EditedSuccess;
  const factory ScheduleWorkEditingSuccess.deleted() = _DeletedSucess;
}
