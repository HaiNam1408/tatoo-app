import 'package:freezed_annotation/freezed_annotation.dart';

part 'register_response.freezed.dart';
part 'register_response.g.dart';

@freezed
class RegisterResponse with _$RegisterResponse {
  @JsonSerializable(explicitToJson: true)
  const factory RegisterResponse({
    @JsonKey(name: 'accessToken') required String accessToken,
    @JsonKey(name: 'role') required String role,
  }) = _RegisterResponse;

  factory RegisterResponse.fromJson(Map<String, dynamic> json) =>
      _$RegisterResponseFromJson(json);
}
