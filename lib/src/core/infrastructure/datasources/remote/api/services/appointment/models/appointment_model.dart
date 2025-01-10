import 'package:freezed_annotation/freezed_annotation.dart';
import 'staff_model.dart';

part 'appointment_model.freezed.dart';
part 'appointment_model.g.dart';

@freezed
class AppointmentModel with _$AppointmentModel {
  const AppointmentModel._();

  const factory AppointmentModel({
    required int id,
    @Default('') String time_start,
    @Default('') String time_end,
    @Default('') String title,
    @Default('') String content,
    @Default(false) bool is_important,
    double? price,
    double? deposit,
    @Default('') String? name_customer,
    @Default('') String? phone,
    @Default(false) bool is_done,
    int? authId,
    int? image_id,
    @Default(false) bool is_delete,
    DateTime? create_at,
    DateTime? update_at,
    StaffModel? staff,
  }) = _AppointmentModel;

  factory AppointmentModel.fromJson(Map<String, dynamic> json) =>
      _$AppointmentModelFromJson(json);
}
