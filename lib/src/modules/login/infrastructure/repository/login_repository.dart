import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:result_dart/result_dart.dart';
import '../../../../common/utils/logger.dart';
import '../../../../core/infrastructure/datasources/remote/api/api_client.dart';
import '../../../../core/infrastructure/datasources/remote/api/base/api_error.dart';
import '../../../../core/infrastructure/datasources/remote/api/services/auth/auth_client.dart';
import '../../../../core/infrastructure/datasources/remote/api/services/auth/models/login_request.dart';
import '../../../../core/infrastructure/datasources/remote/api/services/auth/models/login_response.dart';
import '../../../../core/infrastructure/models/profile.dart';
import '../../domain/interfaces/login_repository_interfaces.dart';

@LazySingleton(as: ILoginRepository)
class LoginRepository implements ILoginRepository {
  final AuthClient _client;

  LoginRepository(this._client);

  @override
  Future<Result<LoginResponse, ApiError>> handleLogin(
    LoginRequest request, {
    CancelToken? token,
  }) async {
    var result = _client.login(
      LoginRequest(username: request.username, password: request.password),
      token,
    );

    return result.tryGet((response) {
      logger.d('Mapped response: ${response.data}');
      return response.data;
    });
  }

  @override
  Future<Result<ProfileModel, ApiError>> handleGetProfile(
      {CancelToken? token}) {
    var result = _client.getProfile(
      token,
    );

    return result.tryGet((response) {
      logger.d('Mapped response: ${response.data}');
      return response.data;
    });
  }
}
