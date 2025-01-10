import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../core/infrastructure/datasources/remote/api/services/appointment/models/appointment_model.dart';

part 'weekly_appointment_model.freezed.dart';
part 'weekly_appointment_model.g.dart';

@freezed
class WeeklyAppointmentModel with _$WeeklyAppointmentModel {
  const WeeklyAppointmentModel._();

  const factory WeeklyAppointmentModel({
    required String date,
    required List<AppointmentModel> data,
  }) = _WeeklyAppointmentModel;

  factory WeeklyAppointmentModel.fromJson(Map<String, dynamic> json) =>
      _$WeeklyAppointmentModelFromJson(json);
}
