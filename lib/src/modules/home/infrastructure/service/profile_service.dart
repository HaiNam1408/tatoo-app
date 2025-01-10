import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
import '../../../../core/infrastructure/datasources/remote/api/base/api_response.dart';
import '../../../../core/infrastructure/models/post.dart';
import '../../../../core/infrastructure/models/profile.dart';
part 'profile_service.g.dart';
@RestApi()
@injectable
abstract class ProfileApi {
  @factoryMethod
  factory ProfileApi(Dio dio) = _ProfileApi;

  @GET('/user/v1/profile/get-profile/{authId}')
  Future<SingleApiResponse<ProfileModel>> profile(
    @Path('authId') int authId
  );
 
  @GET('/user/v1/profile/get-profile-follow-address')
  Future<ListApiResponse<ProfileModel>> getProfileFollowAddress(
    @Query('city') String city,
    @Query('filter') String? filter,
  );
 
  @GET('/post')
  Future<PagingApiResponse<PostModel>> getPostList(
    @Query('authId') int authId,
    @Query('page') int page,
    @Query('limit') int? limit,
  );

}