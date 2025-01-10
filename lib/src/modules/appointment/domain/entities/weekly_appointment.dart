import '../../../../core/infrastructure/datasources/remote/api/services/appointment/models/appointment_model.dart';

abstract class WeeklyAppointments {
  String get date;
  List<AppointmentModel> get data;
}
