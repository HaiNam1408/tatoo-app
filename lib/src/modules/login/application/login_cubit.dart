import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:toastification/toastification.dart';
import '../../../common/utils/app_environment.dart';
import '../../../common/utils/getit_utils.dart';
import '../../../common/utils/logger.dart';
import '../../../common/utils/show_toast.dart';
import '../../../common/utils/validator.dart';
import '../../../core/domain/enums/enums.dart';
import '../../../core/infrastructure/datasources/local/storage.dart';
import '../../../core/infrastructure/datasources/remote/api/services/auth/models/login_request.dart';
import '../../../core/infrastructure/datasources/remote/socket/socket_manager.dart';
import '../../../core/infrastructure/models/profile.dart';
import '../../app/app_router.dart';
import '../domain/interfaces/login_repository_interfaces.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final TextEditingController accountTxtController = TextEditingController();
  final TextEditingController pwdTxtController = TextEditingController();

  final ILoginRepository _repository;
  LoginCubit(this._repository) : super(const LoginState());

  void onChangeAccount(String account) {
    emit(state.copyWith(
        accountName: account,
        errorMessage: state.accountNameError! ? state.errorMessage : ''));
  }

  void onChangePwd(String pwd) {
    emit(state.copyWith(password: pwd));
  }

  bool validateLogin() {
    String? errorMessage;
    bool accountNameError = false;
    bool passwordError = false;

    if (state.accountName == null || state.accountName!.isEmpty) {
      errorMessage = 'Tên tài khoản và mật khẩu không thể bỏ trống';
      accountNameError = true;
    } else if (!Validator.isValidUserName(state.accountName!)) {
      errorMessage = 'Tài khoản cần ít nhất 6 kí tự, chỉ chứa chữ và số';
      accountNameError = true;
    }

    if (state.password == null || state.password!.isEmpty) {
      errorMessage = 'Tên tài khoản và mật khẩu không thể bỏ trống';
      passwordError = true;
    } else if (!Validator.isValidPassword(state.password!)) {
      errorMessage = 'Mật khẩu cần ít nhất 8 kí tự';
      passwordError = true;
    }

    if (errorMessage != null) {
      emit(state.copyWith(
        errorMessage: errorMessage,
        accountNameError: accountNameError,
        passwordError: passwordError,
      ));
      return false;
    }

    emit(state.copyWith(
      errorMessage: '',
      accountNameError: false,
      passwordError: false,
    ));
    return true;
  }

  void login(BuildContext context) async {
    if (validateLogin()) {
      context.loaderOverlay.show();
      var result = await _repository.handleLogin(
          LoginRequest(username: state.accountName!, password: state.password!),
          token: CancelToken());

      result.fold((loginResponse) async {
        context.loaderOverlay.hide();
        CustomToast.show(context: context, message: 'Đăng nhập thành công');
        await Storage.setAccessToken(loginResponse.accessToken);
        await fetchProfile();
        ProfileModel? user = Storage.user;
        if (user != null) {
          logger.i('Socket initializing');
          SocketManager.instance.initialize(AppEnvironment.socketUrl, user.id);
        }
        var role = loginResponse.role == 'USER' ? Role.USER : Role.STORE;
        getIt<AppRouter>().replaceAll([TabBarRoute(role: role)]);
      }, (failure) {
        context.loaderOverlay.hide();
        CustomToast.show(
            context: context,
            message: failure.message,
            type: ToastificationType.error);
      });
    }
  }

  Future<void> fetchProfile() async {
    var result = await _repository.handleGetProfile();
    result.fold((success) async {
      await Storage.setUser(success);
    }, (failure) => null);
  }

}
