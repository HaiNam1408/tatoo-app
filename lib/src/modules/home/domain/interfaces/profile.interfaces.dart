import 'package:result_dart/result_dart.dart';
import '../../../../core/infrastructure/datasources/remote/api/base/api_error.dart';
import '../../../../core/infrastructure/datasources/remote/api/base/api_response.dart';
import '../../../../core/infrastructure/models/post.dart';
import '../../../../core/infrastructure/models/profile.dart';

abstract class IProfileRepository {
  Future<Result<SingleApiResponse<ProfileModel>, ApiError>> getProfile(
      int authId);
  Future<Result<ListApiResponse<ProfileModel>, ApiError>>
      getProfileFollowAddress(String city, String? filter);
  Future<Result<PagingApiResponse<PostModel>, ApiError>> getListPost(
      int authId, int page, int? limit);
}