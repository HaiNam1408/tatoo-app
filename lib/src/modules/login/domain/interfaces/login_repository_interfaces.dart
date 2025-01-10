import 'package:dio/dio.dart';
import 'package:result_dart/result_dart.dart';
import '../../../../core/infrastructure/datasources/remote/api/base/api_error.dart';
import '../../../../core/infrastructure/datasources/remote/api/services/auth/models/login_request.dart';
import '../../../../core/infrastructure/datasources/remote/api/services/auth/models/login_response.dart';
import '../../../../core/infrastructure/models/profile.dart';

abstract class ILoginRepository {
  Future<Result<LoginResponse, ApiError>> handleLogin(
    LoginRequest request, {
    CancelToken? token,
  });
  
  Future<Result<ProfileModel, ApiError>> handleGetProfile({
    CancelToken? token,
  });
}
