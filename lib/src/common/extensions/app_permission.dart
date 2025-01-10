import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';

class AppPermission {
  static Future<bool> checkPhotoPermission() async {
    // TODO: check permission BY PASS
    if (kDebugMode) {
      var status = await Permission.photos.status;
      var storageStatus = await Permission.storage.status;
      if ((status.isGranted || status.isLimited) ||
          (storageStatus.isGranted || storageStatus.isLimited)) {
        return true;
      }
      return false;
    }
    var status = await Permission.photos.status;
    if ((status.isGranted && status.isLimited)) {
      return true;
    }
    return false;
  }
}
