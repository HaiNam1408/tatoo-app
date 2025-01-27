import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:result_dart/result_dart.dart';
import 'package:talker_dio_logger/talker_dio_logger.dart';
import 'package:talker_flutter/talker_flutter.dart';
import '../../../../../../generated/l10n.dart';
import '../../../../../common/utils/app_environment.dart';
import '../../../../domain/interfaces/lang_repository_interface.dart';
import 'base/api_error.dart';
import 'interceptors/auth_interceptor.dart';
import 'interceptors/error_interceptor.dart';
import 'interceptors/lang_interceptor.dart';

@module
abstract class ApiModule {
  @Named('baseUrl')
  String get baseUrl => AppEnvironment.apiUrl;

  @singleton
  Dio dio(
    @Named('baseUrl') String url,
    ILangRepository repo,
    Talker talker,
  ) =>
      Dio(
        BaseOptions(
          baseUrl: url,
          headers: {'accept': 'application/json'},
          // queryParameters: {
          //   'device_id': Storage.deviceId,
          // },
        ),
      )..interceptors.addAll([
          LangInterceptor(repo),
          AuthInterceptor(),
          TalkerDioLogger(
            talker: talker,
            settings: TalkerDioLoggerSettings(
              responsePen: AnsiPen()..blue(),
              // All http responses enabled for console logging
              printResponseData: true,
              // All http requests disabled for console logging
              printRequestData: true,
              // Response logs including http - headers
              printResponseHeaders: false,
              // Request logs without http - headers
              printRequestHeaders: true,
            ),
          ),
          ErrorInterceptor(),
        ]);
}

extension FutureX<T extends Object> on Future<T> {
  Future<T> getOrThrow() async {
    try {
      return await this;
    } on ApiError {
      rethrow;
    } on DioException catch (e) {
      throw e.toApiError();
    } catch (e) {
      throw ApiError.internal(e.toString());
    }
  }

  Future<Result<R, ApiError>> tryGet<R extends Object>(
      R Function(T) response) async {
    try {
      return response.call(await getOrThrow()).toSuccess();
    } on ApiError catch (e) {
      return e.toFailure();
    } catch (e) {
      return ApiError.internal(e.toString()).toFailure();
    }
  }

  Future<Result<R, ApiError>> tryGetFuture<R extends Object>(
      Future<R> Function(T) response) async {
    try {
      return (await response.call(await getOrThrow())).toSuccess();
    } on ApiError catch (e) {
      return e.toFailure();
    } catch (e) {
      return ApiError.internal(e.toString()).toFailure();
    }
  }
}

extension FutureResultX<T extends Object> on Future<Result<T, ApiError>> {
  Future<W> fold<W>(
    W Function(T success) onSuccess,
    W Function(ApiError failure) onFailure,
  ) async {
    try {
      final result = await getOrThrow();
      return onSuccess(result);
    } on ApiError catch (e) {
      return onFailure(e);
    }
  }
}

extension DioExceptionX on DioException {
  ApiError toApiError() {
    if (type == DioExceptionType.cancel) {
      return ApiError.cancelled();
    } else if (error is ApiError) {
      return error as ApiError;
    } else {
      final statusCode = response?.statusCode ?? -1;
      String? responseMessage;
      if (response?.data is Map<String, dynamic>) {
        responseMessage = response?.data?['message'];
      }
      responseMessage = responseMessage ?? S.current.error_unexpected;
      if (statusCode == 401) {
        return ApiError.unauthorized(responseMessage);
      } else if (statusCode >= 400 && statusCode < 500) {
        return ApiError.server(code: statusCode, message: responseMessage);
      } else {
        return ApiError.network(code: statusCode, message: responseMessage);
      }
    }
  }
}
