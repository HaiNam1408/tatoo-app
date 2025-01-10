import 'package:dio/dio.dart';
import 'package:result_dart/result_dart.dart';
import '../../../../core/infrastructure/datasources/remote/api/base/api_error.dart';
import '../../../../core/infrastructure/datasources/remote/api/base/api_response.dart';
import '../../../../core/infrastructure/datasources/remote/api/services/appointment/models/appointment_model.dart';
import '../../infrastructure/models/weekly_appointment_model.dart';

abstract class IAppointmentRepository {
  Future<Result<PagingApiResponse<AppointmentModel>, ApiError>>
      getAppointmentsByDate(String date, int page, int? limit);
  Future<Result<ListApiResponse<WeeklyAppointmentModel>, ApiError>>
      getAppointmentsByWeek(List<String> date);
  Future<Result<SingleApiResponse<AppointmentModel>, ApiError>>
      updateStatusAppointment(int id, FormData formData);
}
