import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

class CustomToast {
  CustomToast._();

  static void show(
      {required BuildContext context,
      required String message,
      String? description,
      ToastificationType? type,
      ToastificationStyle? style,
      Duration? duration}) {
    toastification.show(
      context: context,
      type: type ?? ToastificationType.success,
      style: style ?? ToastificationStyle.fillColored,
      autoCloseDuration: duration ?? const Duration(seconds: 3),
      title: Text(message),
      showProgressBar: false,
      description: description == null
          ? null
          : RichText(text: TextSpan(text: description)),
      alignment: Alignment.topCenter,
      direction: TextDirection.ltr,
      showIcon: true,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      borderRadius: BorderRadius.circular(12),
      closeButtonShowType: CloseButtonShowType.onHover,
      closeOnClick: false,
      pauseOnHover: true,
      dragToClose: true,
      applyBlurEffect: true,
      callbacks: const ToastificationCallbacks(),
    );
  }
}
