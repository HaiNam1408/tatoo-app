import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import 'account_state.dart';

class AccountCubit extends Cubit<AccountState> {
  AccountCubit() : super(const AccountState(isLoading: true));
  void updateImage(File? imagePath) {
    emit(state.copyWith(
      imagePathBackground: imagePath,
    ));
  }
  Future<void> pickImage() async {
    final XFile? pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      File imageFile = File(pickedImage.path);
      updateImage(imageFile);
    }
  }

  void updateImageAvatar(File? imagePath) {
    emit(state.copyWith(
      imagePathAvatar: imagePath,
    ));
  }
  Future<void> pickImageAvatar() async {
    final XFile? pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      File imageFile = File(pickedImage.path);
      updateImageAvatar(imageFile);
    }
  }
}
