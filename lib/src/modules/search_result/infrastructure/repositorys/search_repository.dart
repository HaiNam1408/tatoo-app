import 'package:injectable/injectable.dart';
import 'package:result_dart/result_dart.dart';
import '../../../../core/infrastructure/datasources/remote/api/api_client.dart';
import '../../../../core/infrastructure/datasources/remote/api/base/api_error.dart';
import '../../../../core/infrastructure/datasources/remote/api/base/api_response.dart';
import '../../../../core/infrastructure/models/profile.dart';
import '../../domain/interfaces/search_repository_interface.dart';
import '../service/search_service.dart';

@LazySingleton(as: ISearchRepository)
class SearchRepository implements ISearchRepository {
  final SearchApi _api;

  SearchRepository(this._api);

  @override
  Future<Result<PagingApiResponse<ProfileModel>, ApiError>> searchProfile(
      String keyword, int page, int? limit) {
    return _api
        .fetchSearchProfile(keyword, page, limit)
        .tryGet((response) => response);
  }
}
