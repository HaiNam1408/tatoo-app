import 'package:injectable/injectable.dart';
import 'package:result_dart/result_dart.dart';
import '../../../../core/infrastructure/datasources/remote/api/api_client.dart';
import '../../../../core/infrastructure/datasources/remote/api/base/api_error.dart';
import '../../../../core/infrastructure/datasources/remote/api/base/api_response.dart';
import '../../../../core/infrastructure/models/post.dart';
import '../../../../core/infrastructure/models/profile.dart';
import '../../domain/interfaces/profile.interfaces.dart';
import '../service/profile_service.dart';

@LazySingleton(as: IProfileRepository)
class ProfileRepository implements IProfileRepository {
  final ProfileApi _api;

  ProfileRepository(this._api);

  @override
  Future<Result<SingleApiResponse<ProfileModel>, ApiError>> getProfile(
      int authId) async {
    return await _api
        .profile(
      authId,
    )
        .tryGet((response) {
      return response;
    });
  }

  @override
  Future<Result<ListApiResponse<ProfileModel>, ApiError>>
      getProfileFollowAddress(String city, String? filter) {
    return _api
        .getProfileFollowAddress(
      city,
      filter,
    )
        .tryGet((response) {
      return response;
    });
  }

  @override
  Future<Result<PagingApiResponse<PostModel>, ApiError>> getListPost(
      int authId, int page, int? limit) {
    return _api
        .getPostList(
      authId,
      page,
      limit,
    )
        .tryGet((response) {
      return response;
    });
  }
}
