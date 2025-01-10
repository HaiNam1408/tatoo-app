import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:result_dart/result_dart.dart';
import '../../../../core/infrastructure/datasources/local/storage.dart';
import '../../../../core/infrastructure/datasources/remote/api/api_client.dart';
import '../../../../core/infrastructure/datasources/remote/api/base/api_error.dart';
import '../../../../core/infrastructure/datasources/remote/api/services/auth/auth_client.dart';
import '../../../../core/infrastructure/datasources/remote/api/services/auth/models/login_request.dart';
import '../../../../core/infrastructure/datasources/remote/api/services/auth/models/login_response.dart';
import '../../../../core/infrastructure/models/profile.dart';
import '../../domain/interfaces/auth_repository_interface.dart';
import '../models/user_model.dart';

@LazySingleton(as: IAuthRepository)
class AuthRepository implements IAuthRepository {
  final AuthClient _client;

  AuthRepository(this._client);

  @override
  ProfileModel? getUser() => Storage.user;

  @override
  Future setUser(ProfileModel? val) async {
    if (val is UserModel?) {
      return Storage.setUser(val);
    }
  }

  @override
  Future<String?> getAccessToken() => Storage.accessToken;

  @override
  Future setAccessToken(String? val) => Storage.setAccessToken(val);

  @override
  Future<Result<LoginResponse, ApiError>> login(
    LoginRequest request, {
    CancelToken? token,
  }) async {
    var result = _client.login(request, token);
    return result.tryGet((response) => response.data);
  }

  @override
  Future logout({CancelToken? token}) async {
    await setUser(null);
    await setAccessToken(null);
  }

  @override
  Future<Result<ProfileModel, ApiError>> getProfile({CancelToken? token}) {
    var result = _client.getProfile(token);
    return result.tryGet((response) => response.data);
  }
}
