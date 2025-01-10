import 'package:dio/dio.dart';
import 'package:result_dart/result_dart.dart';

import '../../../../core/infrastructure/datasources/remote/api/base/api_error.dart';
import '../../../../core/infrastructure/datasources/remote/api/services/auth/models/login_request.dart';
import '../../../../core/infrastructure/datasources/remote/api/services/auth/models/login_response.dart';
import '../../../../core/infrastructure/models/profile.dart';

abstract class IAuthRepository {
  ProfileModel? getUser();
  Future setUser(ProfileModel? val);
  Future<String?> getAccessToken();
  Future setAccessToken(String? val);
  Future<Result<LoginResponse, ApiError>> login(
    LoginRequest request, {
    CancelToken? token,
  });
  Future logout({CancelToken? token});
  Future<Result<ProfileModel, ApiError>> getProfile({CancelToken? token});
}
