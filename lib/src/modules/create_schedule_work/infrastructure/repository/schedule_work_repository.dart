import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:result_dart/result_dart.dart';

import '../../../../core/infrastructure/datasources/remote/api/api_client.dart';
import '../../../../core/infrastructure/datasources/remote/api/base/api_error.dart';
import '../../../../core/infrastructure/datasources/remote/api/base/api_response.dart';
import '../../domain/interface/schedule_work_repository_interface.dart';
import '../model/schedule_work_model.dart';
import '../service/schedule_work_api.dart';

@Injectable(as: IScheduleWorkRepository)
class ScheduleWorkRepository implements IScheduleWorkRepository {
  final ScheduleWorkApi _api;

  ScheduleWorkRepository(this._api);

  @override
  Future<Result<StatusApiResponse, ApiError>> createSheduleWork(
    String time_start,
    DateTime initial_date,
    String time_end,
    String title,
    String content,
    bool is_important,
    List<MultipartFile> image, {
    String name_customer = 'Name',
    int price = 0,
    int deposit = 0,
    String phone = '012345678',
  }) async {
    return await _api
        .createScheduleWork(
            time_start,
            initial_date.toString(),
            time_end,
            title,
            content,
            is_important,
            price,
            deposit,
            name_customer,
            phone,
            image)
        .tryGet((response) => response);
  }

  @override
  Future<Result<ScheduleWorkModel, ApiError>> getSheduleWork(int id) async {
    return await _api.getScheduleWork(id).tryGet((response) => response.data);
  }

  @override
  Future<Result<StatusApiResponse, ApiError>> updateSheduleWork(
      int id,
      String? time_start,
      String? time_end,
      String? title,
      String? content,
      DateTime? initial_date,
      bool? is_important,
      int? price,
      int? deposit,
      String? name_customer,
      String? phone,
      bool? is_done,
      List<MultipartFile>? image,
      bool? deleteImage) async {
    return await _api
        .updateScheduleWork(
            id,
            time_start,
            time_end,
            title,
            content,
            initial_date.toString(),
            is_important,
            price,
            deposit,
            name_customer,
            phone,
            is_done,
            image,
            deleteImage)
        .tryGet((response) => response);
  }
  
  @override
  Future<Result<StatusApiResponse, ApiError>> deleteSheduleWork(int id) async {
    return await _api.deleteScheduleWork(id).tryGet((response) => response);
  }
}
