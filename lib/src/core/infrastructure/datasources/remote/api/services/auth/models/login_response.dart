import 'package:freezed_annotation/freezed_annotation.dart';
part 'login_response.freezed.dart';
part 'login_response.g.dart';

@freezed
class LoginResponse with _$LoginResponse {
  const factory LoginResponse({
    @JsonKey(name: 'accessToken') required String accessToken,
    @JsonKey(name: 'role') required String role,
  }) = _LoginResponse;

  const LoginResponse._();
  factory LoginResponse.fromJson(json) => _$LoginResponseFromJson(json);
}
