import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import '../../../core/infrastructure/datasources/local/storage.dart';
import '../../../core/infrastructure/models/profile.dart';
import '../domain/interfaces/auth_repository_interface.dart';
import '../../../core/domain/errors/auth_error.dart';
part 'auth_cubit.freezed.dart';
part 'auth_state.dart';

@singleton
class AuthCubit extends Cubit<AuthState> {
  final IAuthRepository _repository;

  AuthCubit(
    this._repository,
  ) : super(() {
          final user = _repository.getUser();
          if (user != null) {
            return _Authenticated(user);
          } else {
            return const _Unauthenticated();
          }
        }());

  // Future<void> login(LoginRequest request) async {
  //   if (!Validator.isValidPassword(request.password)) {
  //     emit(const _Error(AuthError.invalidPassword()));
  //   } else {
  //     emit(const _Loading());
  //     final result = await _repository.login(request);
  //     emit(result.fold(
  //       (success) {
  //         _repository.setUser(success);
  //         return _Authenticated(success);
  //       },
  //       (failure) => _Error(
  //         AuthError.other(failure.message),
  //       ),
  //     ));
  //   }
  // }

  void logout() async {
    await state.whenOrNull(authenticated: (_) async {
      emit(const _Loading());
      await _repository.logout();
      emit(const _Unauthenticated());
    });
  }

  Future<void> checkAuthentication() async {
    final token = await Storage.accessToken;

    if (token != null) {
      final profile = await fetchUserProfile();
      if (profile != null) {
        emit(AuthState.authenticated(profile));
      } else {
        emit(const AuthState.unauthenticated());
      }
    } else {
      emit(const AuthState.unauthenticated());
    }
  }

  Future<ProfileModel?> fetchUserProfile() async {
    var result = await _repository.getProfile(token: CancelToken());

    result.fold((res) async {
      return res;
    }, (failure) {
      return null;
    });
    return null;
  }
}
