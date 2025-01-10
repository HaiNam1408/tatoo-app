import 'dart:io';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'register_request.freezed.dart';
part 'register_request.g.dart';

@freezed
class RegisterRequest with _$RegisterRequest {
  const factory RegisterRequest({
    @Default('') String username,
    @Default('') String password,
    @Default('') String role,
    String? street,
    String? city,
    String? storeName,
    List<String>? hashtag,
    String? postContent,
    @JsonKey(includeFromJson: false, includeToJson: false)
    File? backgroundImage,
    @JsonKey(includeFromJson: false, includeToJson: false) File? avatar,
    @JsonKey(includeFromJson: false, includeToJson: false) File? postImage,
  }) = _RegisterRequest;

  factory RegisterRequest.fromJson(Map<String, dynamic> json) =>
      _$RegisterRequestFromJson(json);
}
