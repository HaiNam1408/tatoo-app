import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

import 'app_device_state.dart';

@singleton
class AppDeviceCubit extends Cubit<AppDeviceState> {
  AppDeviceCubit() : super(const AppDeviceState());

  void changeStatusBar(Brightness mode) {
    emit(state.copyWith(appBarMode: mode));
  }
}