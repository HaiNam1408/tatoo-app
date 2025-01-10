import 'package:result_dart/result_dart.dart';

import '../../../../core/infrastructure/datasources/remote/api/base/api_error.dart';
import '../../../../core/infrastructure/datasources/remote/api/base/api_response.dart';

abstract class IShopInforRepository {
  Future<Result<StatusApiResponse, ApiError>> rating(
    double star,
    int shopId
  );
}