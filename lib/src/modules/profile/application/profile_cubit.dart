import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../common/utils/getit_utils.dart';
import '../../../common/widgets/app_dialogs.dart';
import '../../../core/infrastructure/datasources/local/storage.dart';
import '../../../core/infrastructure/datasources/remote/socket/socket_manager.dart';
import '../../../core/infrastructure/models/profile.dart';
import '../../app/app_router.dart';
import 'profile_state.dart';
import 'package:flutter/material.dart';

@singleton
class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(const ProfileState(isLoading: true)) {
    loadDataUser();
  }

  PageController modeController = PageController();

  void changMode() {
    modeController.animateToPage(1,
        duration: const Duration(milliseconds: 300), curve: Curves.linear);
  }

  Future<void> loadDataUser() async {
    await for (final ProfileModel? userProfile in Storage.userStream) {
      if (userProfile != null) {
        emit(state.copyWith(
          isLoading: false,
          userName: userProfile.fullname ?? userProfile.storeName,
          avatarUrl: userProfile.avatar?.filePath,
        ));
      } else {
        emit(state.copyWith(
          isLoading: false,
          error: 'No user data available',
        ));
      }
    }
  }

  void logout() async {
    AppDialogs.show(
        content: 'Bạn có thật sự muốn đăng xuất khỏi tài khoản này',
        titleAction1: 'Đăng xuất',
        titleAction2: 'Hủy',
        action1: () async {
          SocketManager.instance.disconnect();
          await Storage.setAccessToken(null);
          await Storage.setUser(null);
          getIt<AppRouter>().replaceAll([const AuthRoute()]);
        });
  }

  // Điều khiển chuyển trang
  void navigateToPage(int page) {
    modeController.animateToPage(
      page,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void changeLeftPosition(double x) {
    emit(state.copyWith(leftPosition: x));
  }
}
