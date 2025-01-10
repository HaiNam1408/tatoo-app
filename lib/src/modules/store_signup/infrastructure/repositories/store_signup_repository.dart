import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:result_dart/result_dart.dart';
import '../../../../common/utils/logger.dart';
import '../../../../core/infrastructure/datasources/remote/api/api_client.dart';
import '../../../../core/infrastructure/datasources/remote/api/base/api_error.dart';
import '../../../../core/infrastructure/datasources/remote/api/services/auth/auth_client.dart';
import '../../../../core/infrastructure/datasources/remote/api/services/auth/models/register_request.dart';
import '../../../../core/infrastructure/datasources/remote/api/services/auth/models/register_response.dart';
import '../../../../core/infrastructure/models/profile.dart';
import '../../domain/interfaces/store_signup_repository_interface.dart';

@LazySingleton(as: IStoreSignupRepository)
class StoreSignupRepository implements IStoreSignupRepository {
  final AuthClient _client;

  StoreSignupRepository(this._client);

  @override
  Future<Result<RegisterResponse, ApiError>> registerRepository(
    RegisterRequest request, {
    CancelToken? token,
  }) async {
    MultipartFile? avatar = request.avatar == null
        ? null
        : await MultipartFile.fromFile(request.avatar!.path);
    MultipartFile? backgroundImage = request.avatar == null
        ? null
        : await MultipartFile.fromFile(request.backgroundImage!.path);
    MultipartFile? postImage = request.avatar == null
        ? null
        : await MultipartFile.fromFile(request.postImage!.path);

    final formData = FormData.fromMap({
      'username': request.username,
      'password': request.password,
      'role': request.role,
      'storeName': request.storeName,
      'city': request.city,
      'street': request.street,
      'hashtag': request.hashtag,
      'post_content': request.postContent,
      'avatar': avatar,
      'background_image': backgroundImage,
      'post_image': postImage,
    });

    logger.d('Register request: ${formData.fields}');

    var result = _client.register(
      formData,
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
