import 'package:dio/dio.dart';
import 'package:result_dart/result_dart.dart';

import '../../../../core/infrastructure/datasources/remote/api/base/api_error.dart';
import '../../../../core/infrastructure/datasources/remote/api/services/auth/models/register_request.dart';
import '../../../../core/infrastructure/datasources/remote/api/services/auth/models/register_response.dart';
import '../../../../core/infrastructure/models/profile.dart';

abstract class IStoreSignupRepository {
  Future<Result<RegisterResponse, ApiError>> registerRepository(
    RegisterRequest request, {
    CancelToken? token,
  });

  Future<Result<ProfileModel, ApiError>> handleGetProfile({
    CancelToken? token,
  });
}
