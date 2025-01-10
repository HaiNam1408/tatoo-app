import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:result_dart/result_dart.dart';

import '../../../../models/meta.dart';
import 'api_error.dart';

part 'api_response.freezed.dart';
part 'api_response.g.dart';

abstract class GenericObject<T> {
  T Function(Map<String, dynamic>) fromJsonT;

  GenericObject(this.fromJsonT);

  T genericObject(dynamic data) {
    return fromJsonT(data);
  }
}

class ResponseWrapper<T> extends GenericObject<T> {
  late T response;

  ResponseWrapper(super.fromJsonT);

  factory ResponseWrapper.init(
      {required T Function(Map<String, dynamic>) fromJsonT,
      required dynamic data}) {
    final wrapper = ResponseWrapper<T>(fromJsonT);
    wrapper.response = wrapper.genericObject(data);
    return wrapper;
  }
}

@Freezed(genericArgumentFactories: true)
class SingleApiResponse<T> with _$SingleApiResponse<T> {
  const factory SingleApiResponse(T data) = _SingleApiResponse;

  factory SingleApiResponse.fromJson(
          Map<String, dynamic> json, T Function(Object?) fromJsonT) =>
      _$SingleApiResponseFromJson(json, fromJsonT);
}

@Freezed(genericArgumentFactories: true)
class ListApiResponse<T> with _$ListApiResponse<T> {
  const factory ListApiResponse(List<T> data) = _ListApiResponse;

  factory ListApiResponse.fromJson(
          Map<String, dynamic> json, T Function(Object?) fromJsonT) =>
      _$ListApiResponseFromJson(json, fromJsonT);
}

@Freezed(genericArgumentFactories: true)
class PagingApiResponse<T> with _$PagingApiResponse<T> {
  const factory PagingApiResponse({
    required List<T> data,
    required Meta meta,
  }) = _PagingApiResponse;

  factory PagingApiResponse.fromJson(
      Map<String, dynamic> json, T Function(Object?) fromJsonT) {
    return PagingApiResponse<T>(
      data: (json['data']['data'] as List<dynamic>)
          .map((item) => fromJsonT(item))
          .toList(),
      meta: Meta.fromJson(json['data']['meta'] as Map<String, dynamic>),
    );
  }
}

@Freezed(genericArgumentFactories: true)
class StatusApiResponse with _$StatusApiResponse {
  const factory StatusApiResponse({
    required String message,
    required int statusCode,
  }) = _StatusApiResponse;

  factory StatusApiResponse.fromJson(Map<String, dynamic> json) =>
      _$StatusApiResponseFromJson(json);
}

extension FoldedSingleApiResponse<T extends Object>
    on Result<SingleApiResponse<T>, ApiError> {
  Result<T, ApiError> get folded => fold(
        (success) => Success(success.data),
        (failure) => Failure(failure),
      );
}

extension FoldedPagingApiResponse<T extends Object>
    on Result<PagingApiResponse<T>, ApiError> {
  Result<List<T>, ApiError> get folded => fold(
        (success) => Success(success.data),
        (failure) => Failure(failure),
      );
}

extension FoldedListApiResponse<T extends Object>
    on Result<ListApiResponse<T>, ApiError> {
  Result<List<T>, ApiError> get folded => fold(
        (success) => Success(success.data),
        (failure) => Failure(failure),
      );
}
