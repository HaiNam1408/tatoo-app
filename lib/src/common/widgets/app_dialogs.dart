import 'package:asuka/asuka.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import '../../../generated/colors.gen.dart';
import '../extensions/build_context_x.dart';
import 'app_button.dart';

enum AlertType {
  notice,
  warning,
  error,
  confirm,
}

class AppDialogs {
  static Future<void> show({
    // required String title,
    required String content,
    String? titleAction1,
    String? titleAction2,
    Function()? action1,
    Function()? action2,
    AlertType type = AlertType.notice,
  }) {
    return Asuka.showDialog(builder: (context) {
      return AlertDialog(
        backgroundColor: ColorName.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        content: SizedBox(
          width: 358.w,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Gap(16),
              Center(
                  child: Text(
                'Thông báo',
                style: context.textTheme.headlineLarge
                    .copyWith(color: ColorName.dark),
              )),
              const Gap(16),
              Center(
                  child: Text(content,
                      style: context.textTheme.bodyMedium
                          .copyWith(color: ColorName.dark))),
              const Gap(24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  if (titleAction2 != null)
                    Expanded(
                      flex: 1,
                      child: AppButton(
                        darkButton: false,
                        title: titleAction2,
                        onTap: () {
                          Navigator.of(context).pop();
                          action2?.call();
                        },
                      ),
                    ),
                  const Gap(12),
                  Expanded(
                    flex: 1,
                    child: AppButton(
                      darkButton: true,
                      title: titleAction1 ?? context.s.ok,
                      onTap: () {
                        Navigator.of(context).pop();
                        action1?.call();
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }
}
