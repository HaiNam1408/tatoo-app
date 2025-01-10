import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:result_dart/result_dart.dart';
import '../../../../core/infrastructure/datasources/remote/api/api_client.dart';
import '../../../../core/infrastructure/datasources/remote/api/base/api_error.dart';
import '../../../../core/infrastructure/datasources/remote/api/base/api_response.dart';
import '../../../../core/infrastructure/datasources/remote/api/services/appointment/appointment_client.dart';
import '../../domain/interfaces/appointment_repository_interface.dart';
import '../../../../core/infrastructure/datasources/remote/api/services/appointment/models/appointment_model.dart';
import '../models/weekly_appointment_model.dart';

@LazySingleton(as: IAppointmentRepository)
class AppointmentRepository implements IAppointmentRepository {
  final AppointmentClient _api;

  AppointmentRepository(this._api);

  @override
  Future<Result<PagingApiResponse<AppointmentModel>, ApiError>>
      getAppointmentsByDate(String date, int page, int? limit) async {
    return await _api.getBookingFollowDay(date, page, limit).tryGet((response) {
      return response;
    });
  }

  @override
  Future<Result<ListApiResponse<WeeklyAppointmentModel>, ApiError>>
      getAppointmentsByWeek(List<String> date) async {
    return await _api.getBookingFollowWeek(date).tryGet((response) {
      return response;
    });
  }

  @override
  Future<Result<SingleApiResponse<AppointmentModel>, ApiError>>
      updateStatusAppointment(int id, FormData formData) async {
    return await _api
        .updateStatus(id, formData, CancelToken())
        .tryGet((response) {
      return response;
    });
  }
}
