import 'package:result_dart/result_dart.dart';
import '../../../../core/infrastructure/datasources/remote/api/base/api_error.dart';
import '../../../../core/infrastructure/datasources/remote/api/base/api_response.dart';
import '../../../../core/infrastructure/models/profile.dart';

abstract class ISearchRepository {
  Future<Result<PagingApiResponse<ProfileModel>, ApiError>> searchProfile(
      String keyword, int page, int? limit);
}
