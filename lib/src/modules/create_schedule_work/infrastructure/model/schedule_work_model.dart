import 'package:freezed_annotation/freezed_annotation.dart';

part 'schedule_work_model.freezed.dart';
part 'schedule_work_model.g.dart';

@freezed
class ScheduleWorkModel with _$ScheduleWorkModel  {
  const ScheduleWorkModel._();

  const factory ScheduleWorkModel({
    @Default(0) int id,
    @Default('') String time_start,
    DateTime? initial_date,
    @Default('') String time_end,
    @Default('') String title,
    @Default('') String content,
    @Default(false) bool is_important,    
    @Default(AttachmentModel()) AttachmentModel attachment,
  }) = _ScheduleWorkModel;

  factory ScheduleWorkModel.fromJson(Map<String, dynamic> json) =>
      _$ScheduleWorkModelFromJson(json);
}
class DateTimeUtil {
  static DateTime get nowDefault => DateTime.now();
}

@freezed
class AttachmentModel with _$AttachmentModel  {

  const factory AttachmentModel({
    @Default('') String filePath,
  }) = _AttachmentModel;

  factory AttachmentModel.fromJson(Map<String, dynamic> json) =>
      _$AttachmentModelFromJson(json);
}