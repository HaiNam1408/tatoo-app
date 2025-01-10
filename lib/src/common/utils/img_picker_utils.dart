import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../extensions/app_permission.dart';
import '../widgets/app_dialogs.dart';

class ImgPickerUtils {
  static Future<File?> show() async {
    final isAccess = await AppPermission.checkPhotoPermission();
    if (isAccess) {
      final ImagePicker picker = ImagePicker();
      final XFile? response =
          await picker.pickImage(source: ImageSource.gallery);
      if (response == null) return null;
      return File(response.path);
    } else {
      AppDialogs.show(
        content: 'Vui lòng cấp quyền quy cập ảnh',
        action1: () {},
        titleAction2: 'Cài đặt',
        action2: () async {
          await openAppSettings();
        },
      );
    }
    return null;
  }
}
