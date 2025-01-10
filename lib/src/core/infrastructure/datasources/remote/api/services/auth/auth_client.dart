import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
import '../../../../../models/profile.dart';
import '../../base/api_response.dart';
import 'models/login_request.dart';
import 'models/login_response.dart';
import 'models/register_response.dart';
part 'auth_client.g.dart';

@RestApi()
@injectable
abstract class AuthClient {
  @factoryMethod
  factory AuthClient(Dio dio) = _AuthClient;

  @POST('/user/v1/auth/register')
  @MultiPart()
  Future<SingleApiResponse<RegisterResponse>> register(
    @Body() FormData formData,
    @CancelRequest() CancelToken? cancelToken,
  );


  @POST('/user/v1/auth/login')
  Future<SingleApiResponse<LoginResponse>> login(
    @Body() LoginRequest request,
    @CancelRequest() CancelToken? cancelToken,
  );

  @GET('/user/v1/profile/get-profile')
  Future<SingleApiResponse<ProfileModel>> getProfile(
      @CancelRequest() CancelToken? cancelToken);
}
