import 'package:flutter/material.dart';

class AppDeviceState {
  final Brightness? appBarMode;

  const AppDeviceState({this.appBarMode});

  AppDeviceState copyWith({
    Brightness? appBarMode,
  }) {
    return AppDeviceState(
      appBarMode: appBarMode ?? this.appBarMode,
    );
  }
}
