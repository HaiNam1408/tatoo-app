import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
import '../../../../core/infrastructure/datasources/remote/api/base/api_response.dart';
import '../model/schedule_work_model.dart';

part 'schedule_work_api.g.dart';

@RestApi()
@injectable
abstract class ScheduleWorkApi {
  @factoryMethod
  factory ScheduleWorkApi(Dio dio) = _ScheduleWorkApi;

  @POST('/user/v1/booking/create')
  @MultiPart()
  Future<StatusApiResponse> createScheduleWork(
    @Part(name: 'time_start') String time_start,
    @Part(name: 'initial_date') String initial_date,
    @Part(name: 'time_end') String time_end,
    @Part(name: 'title') String title,
    @Part(name: 'content') String content,
    @Part(name: 'is_important') bool is_important,
    @Part(name: 'price') int price,
    @Part(name: 'deposit') int deposit,
    @Part(name: 'name_customer') String name_customer,
    @Part(name: 'phone') String phone,
    @Part(name: 'image') List<MultipartFile> image,
  );

  @GET('/user/v1/booking/get-booking/{id}')
  Future<SingleApiResponse<ScheduleWorkModel>> getScheduleWork(
    @Path('id') int id,
  );

  @PUT('/user/v1/booking/update-booking/{id}')
  @MultiPart()
  Future<StatusApiResponse> updateScheduleWork(
    @Path('id') int id,
    @Part(name: 'time_start') String? time_start,
    @Part(name: 'time_end') String? time_end,
    @Part(name: 'title') String? title,
    @Part(name: 'content') String? content,
    @Part(name: 'initial_date') String? initial_date,
    @Part(name: 'is_important') bool? is_important,
    @Part(name: 'price') int? price,
    @Part(name: 'deposit') int? deposit,
    @Part(name: 'name_customer') String? name_customer,
    @Part(name: 'phone') String? phone,
    @Part(name: 'is_important') bool? is_done,
    @Part(name: 'image') List<MultipartFile>? image,
    @Part(name: 'is_important') bool? deleteImage,
  );

  @DELETE('/user/v1/booking/delete-booking/{id}')
  Future<StatusApiResponse> deleteScheduleWork(
    @Path('id') int id,
  );
}
