import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
import '../../../../core/infrastructure/datasources/remote/api/base/api_response.dart';
import '../../../../core/infrastructure/models/profile.dart';
part 'search_service.g.dart';

@RestApi()
@injectable
abstract class SearchApi {
  @factoryMethod
  factory SearchApi(Dio dio) = _SearchApi;

  @GET('/user/v1/profile/search-profile')
  Future<PagingApiResponse<ProfileModel>> fetchSearchProfile(
    @Query('keyword') String? keyword,
    @Query('page') int page,
    @Query('limit') int? limit,
  );
}
