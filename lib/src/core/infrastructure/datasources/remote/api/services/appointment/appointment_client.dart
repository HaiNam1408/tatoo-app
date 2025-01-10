import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
import '../../../../../../../modules/appointment/infrastructure/models/weekly_appointment_model.dart';
import '../../base/api_response.dart';
import 'models/appointment_model.dart';
part 'appointment_client.g.dart';

@RestApi()
@injectable
abstract class AppointmentClient {
  @factoryMethod
  factory AppointmentClient(Dio dio) = _AppointmentClient;

  @GET('/user/v1/booking/get-booking-follow-day')
  Future<PagingApiResponse<AppointmentModel>> getBookingFollowDay(
    @Query('date') String date,
    @Query('page') int page,
    @Query('limit') int? limit,
  );

  @GET('/user/v1/booking/get-booking-follow-week')
  Future<ListApiResponse<WeeklyAppointmentModel>> getBookingFollowWeek(
      @Query('date') List<String> date);

  @PUT('/user/v1/booking/update-booking/{id}')
  @MultiPart()
  Future<SingleApiResponse<AppointmentModel>> updateStatus(
    @Path('id') int id,
    @Body() FormData formData,
    @CancelRequest() CancelToken? cancelToken,
  );
}
