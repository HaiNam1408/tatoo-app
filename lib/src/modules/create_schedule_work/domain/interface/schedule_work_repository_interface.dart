import 'package:dio/dio.dart';
import 'package:result_dart/result_dart.dart';

import '../../../../core/infrastructure/datasources/remote/api/base/api_error.dart';
import '../../../../core/infrastructure/datasources/remote/api/base/api_response.dart';
import '../../infrastructure/model/schedule_work_model.dart';

abstract class IScheduleWorkRepository {
  Future<Result<StatusApiResponse, ApiError>> createSheduleWork(
    String time_start,
    DateTime initial_date,
    String time_end,
    String title,
    String content,
    bool is_important,
    List<MultipartFile> image, {
    String name_customer = '',
    int price = 0,
    int deposit = 0,
    String phone = '',
  });

  Future<Result<ScheduleWorkModel, ApiError>> getSheduleWork(
    int id,
  );

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
      bool? deleteImage);

  Future<Result<StatusApiResponse, ApiError>> deleteSheduleWork(
    int id,
  );
}
