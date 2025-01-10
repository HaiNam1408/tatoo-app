import 'dart:io';
import 'package:auto_route/auto_route.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:toastification/toastification.dart';
import '../../../common/utils/app_environment.dart';
import '../../../common/utils/crop_image_util.dart';
import '../../../common/utils/getit_utils.dart';
import '../../../common/utils/img_picker_utils.dart';
import '../../../common/utils/logger.dart';
import '../../../common/utils/show_toast.dart';
import '../../../common/utils/validator.dart';
import '../../../common/widgets/app_dialogs.dart';
import '../../../core/domain/enums/enums.dart';
import '../../../core/infrastructure/datasources/local/storage.dart';
import '../../../core/infrastructure/datasources/remote/api/services/auth/models/register_request.dart';
import '../../../core/infrastructure/datasources/remote/socket/socket_manager.dart';
import '../../../core/infrastructure/models/profile.dart';
import '../../app/app_router.dart';
import '../domain/interfaces/store_signup_repository_interface.dart';
import 'store_signup_state.dart';

class StoreSignupCubit extends Cubit<StoreSignupState> {
  final IStoreSignupRepository _repository;
  StoreSignupCubit(this._repository) : super(const StoreSignupState());

  final PageController stepController = PageController();
  final TextEditingController accountTxtController = TextEditingController();
  final TextEditingController pwdTxtController = TextEditingController();
  final TextEditingController nameTxtController = TextEditingController();
  final TextEditingController provinceTxtController = TextEditingController();
  final TextEditingController addressTxtController = TextEditingController();
  final TextEditingController tagTxtController = TextEditingController();
  final TextEditingController descTxtController = TextEditingController();

  final List<String> hashTags = [
    'Abstract',
    'Ambigram',
    'Anatomical',
    'Blackwork',
    'Black And Grey',
    'Blackout',
    'Biomechanical',
    'Blast over',
    'Celtic',
    'Mechanics',
    'Dotwork',
    'CHICANO',
    'Wave',
    'Gradient',
    'Inverted',
    'Lettering',
    'Japan',
    'Mambo',
    'MANDALA',
    'Minimalist',
    'Mayan',
    'Outline',
    'Pinstripe',
    'Pixel',
    'Neo-Traditional',
    'UV INK',
    'Real description',
  ];

  Future<void> pickImageAndCrop({
    required CropStyle cropStyle,
    required CropAspectRatioPreset aspectRatio,
    bool lockAspectRatio = true,
    required Function(File?) onSuccess,
  }) async {
    var img = await ImgPickerUtils.show();
    if (img != null) {
      img = await CropImageUtil.cropImage(
        pickedFile: img,
        cropStyle: cropStyle,
        aspectRatio: aspectRatio,
        lockAspectRatio: lockAspectRatio,
      );
      onSuccess(img);
    }
  }

  Future<void> pickAvatar() async {
    await pickImageAndCrop(
      cropStyle: CropStyle.circle,
      aspectRatio: CropAspectRatioPreset.square,
      onSuccess: (img) =>
          emit(state.copyWith(avatar: img, avatarError: img == null)),
    );
  }

  Future<void> pickCoverPhoto() async {
    await pickImageAndCrop(
      cropStyle: CropStyle.rectangle,
      aspectRatio: CropAspectRatioPreset.ratio16x9,
      onSuccess: (img) =>
          emit(state.copyWith(coverImage: img, coverImageError: img == null)),
    );
  }

  Future<void> pickPostPhoto() async {
    await pickImageAndCrop(
      cropStyle: CropStyle.rectangle,
      aspectRatio: CropAspectRatioPreset.ratio4x3,
      onSuccess: (img) =>
          emit(state.copyWith(postImg: img, postImgError: img == null)),
    );
  }

  void checkedTerms(isChecked) {
    emit(state.copyWith(agreeTerms: isChecked));
  }

  void setUserName(String name) {
    emit(state.copyWith(userName: name, usernameError: name.isEmpty));
  }

  void setPwd(String pwd) {
    emit(state.copyWith(pwd: pwd, pwdError: pwd.isEmpty));
  }

  void onChangeSearchTag(String value) {
    emit(state.copyWith(searchTagValue: value));
  }

  void onSelectTag(String hashtag) {
    emit(
        state.copyWith(selectedHashTags: [...state.selectedHashTags, hashtag]));
  }

  void onUnSelectTag(String hashtag) {
    List<String> newList = List.from(state.selectedHashTags)..remove(hashtag);
    emit(state.copyWith(selectedHashTags: newList));
  }

  void validateStep2() {
    emit(state.copyWith(
      avatarError: state.avatar == null,
      coverImageError: state.coverImage == null,
      shopNameError: state.shopName == null || state.shopName!.isEmpty,
      cityError: state.city == null || state.city!.isEmpty,
      addressError: state.address == null || state.address!.isEmpty,
    ));
  }

  void validateStep4() {
    emit(state.copyWith(
        postImgError: state.postImg == null,
        postDesError: state.postDes == null || state.postDes!.isEmpty));
  }

  void setShopName(String name) {
    emit(state.copyWith(shopName: name, shopNameError: name.isEmpty));
  }

  void onSelectProvince(String string) {
    emit(state.copyWith(city: string, cityError: string.isEmpty));
    provinceTxtController.text = string;
  }

  void setAddress(String address) {
    emit(state.copyWith(address: address, addressError: address.isEmpty));
  }

  void setPostDescription(String value) {
    emit(state.copyWith(postDes: value, postDesError: value.isEmpty));
  }

  Future<void> backToStep(BuildContext context) async {
    switch (state.step) {
      case 1:
        emit(state.copyWith(step: 0));
        context.router.maybePop();
      case 2:
        emit(state.copyWith(step: 1));
        await stepController.animateToPage(0,
            duration: Durations.medium2, curve: Curves.linear);
      case 3:
        emit(state.copyWith(step: 2));
        await stepController.animateToPage(1,
            duration: Durations.medium2, curve: Curves.linear);
      case 4:
        emit(state.copyWith(step: 3));
        await stepController.animateToPage(2,
            duration: Durations.medium2, curve: Curves.linear);
      default:
        return;
    }
  }

  Future<void> nextToStep(BuildContext context) async {
    FocusManager.instance.primaryFocus?.unfocus();
    switch (state.step) {
      case 1:
        emit(state.copyWith(
            usernameError: !Validator.isValidUserName(state.userName),
            pwdError: !Validator.isValidPassword(state.pwd)));
        if (!state.agreeTerms) {
          AppDialogs.show(
              content:
                  'Bạn chưa đồng ý với điều khoản dịch vụ và chính sách của chúng tôi');
        }
        if (state.agreeTerms &&
            (Validator.isValidUserName(state.userName)) &&
            (Validator.isValidPassword(state.pwd))) {
          emit(state.copyWith(step: 2));
          await stepController.animateToPage(1,
              duration: Durations.medium2, curve: Curves.linear);
        }
      case 2:
        validateStep2();
        if (!state.avatarError! &&
            !state.coverImageError! &&
            !state.shopNameError! &&
            !state.cityError! &&
            !state.addressError!) {
          emit(state.copyWith(step: 3));
          await stepController.animateToPage(2,
              duration: Durations.medium2, curve: Curves.linear);
        }
      case 3:
        emit(state.copyWith(step: 4));
        await stepController.animateToPage(3,
            duration: Durations.medium2, curve: Curves.linear);
      case 4:
        validateStep4();
        if (!state.postImgError! && !state.postDesError!) {
          storeRegister(context);
        }
      default:
        return;
    }
  }

  Future<void> fetchProfile() async {
    var result = await _repository.handleGetProfile();
    result.fold((success) async {
      await Storage.setUser(success);
    }, (failure) => null);
  }

  Future<void> storeRegister(BuildContext context) async {
    context.loaderOverlay.show();
    await Future.delayed(const Duration(seconds: 2));
    var result = await _repository.registerRepository(
        RegisterRequest(
            username: state.userName,
            avatar: state.avatar,
            backgroundImage: state.coverImage,
            storeName: state.shopName,
            city: state.city,
            street: state.address,
            postContent: state.postDes,
            role: 'STORE',
            password: state.pwd,
            postImage: state.postImg,
            hashtag: state.selectedHashTags),
        token: CancelToken());

    result.fold((registerResponse) async {
      context.loaderOverlay.hide();
      CustomToast.show(context: context, message: 'Đăng ký thành công');
      await Storage.setAccessToken(registerResponse.accessToken);
      await fetchProfile();
      ProfileModel? user = Storage.user;
      if (user != null) {
        logger.i('Socket initializing');
        SocketManager.instance.initialize(AppEnvironment.socketUrl, user.id);
      }
      var role = registerResponse.role == 'USER' ? Role.USER : Role.STORE;
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
