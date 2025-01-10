import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';

import '../../../generated/colors.gen.dart';

class CropImageUtil {
  static Future<File?> cropImage({
    required File pickedFile,
    CropStyle cropStyle = CropStyle.rectangle,
    CropAspectRatioPreset aspectRatio = CropAspectRatioPreset.square,
    bool lockAspectRatio = true,
  }) async {
    try {
      final cropFile = await ImageCropper().cropImage(
        sourcePath: pickedFile.path,
        compressFormat: ImageCompressFormat.jpg,
        compressQuality: 100,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Cắt hình',
            cropStyle: cropStyle,
            toolbarColor: ColorName.dark,
            toolbarWidgetColor: ColorName.primary,
            hideBottomControls: true,
            initAspectRatio: aspectRatio,
            lockAspectRatio: lockAspectRatio,
            aspectRatioPresets: [aspectRatio],
          ),
          IOSUiSettings(
            title: 'Cắt hình',
            cropStyle: cropStyle,
            aspectRatioPresets: [aspectRatio],
          ),
        ],
      );
      return cropFile != null ? File(cropFile.path) : null;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }
}
