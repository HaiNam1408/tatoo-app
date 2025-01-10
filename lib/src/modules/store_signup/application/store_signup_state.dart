import 'dart:io';

class StoreSignupState {
  final int step;
  final String userName;
  final String pwd;
  final bool isLoading;
  final String? error;
  final bool? usernameError;
  final bool? pwdError;
  final bool agreeTerms;
  final File? avatar;
  final File? coverImage;
  final String? shopName;
  final String? city;
  final String? address;
  final List<String> selectedHashTags;
  final String? postDes;
  final File? postImg;
  final String searchTagValue;
  final bool? avatarError;
  final bool? coverImageError;
  final bool? shopNameError;
  final bool? cityError;
  final bool? addressError;
  final bool? postImgError;
  final bool? postDesError;
  final bool? isDisableNextStep;

  const StoreSignupState(
      {this.step = 1,
      this.userName = '',
      this.pwd = '',
      this.isLoading = false,
      this.error,
      this.usernameError = false,
      this.pwdError = false,
      this.agreeTerms = false,
      this.avatar,
      this.coverImage,
      this.shopName,
      this.city,
      this.address,
      this.postImg,
      this.postDes,
      this.searchTagValue = '',
      this.selectedHashTags = const [],
      this.avatarError = false,
      this.coverImageError = false,
      this.shopNameError = false,
      this.cityError = false,
      this.addressError = false,
      this.postImgError = false,
      this.postDesError = false,
      this.isDisableNextStep = true});

  StoreSignupState copyWith(
      {bool? isLoading,
      int? step,
      String? error,
      String? userName,
      String? pwd,
      bool? usernameError,
      bool? pwdError,
      bool? agreeTerms,
      File? avatar,
      File? coverImage,
      String? shopName,
      String? address,
      String? city,
      List<String>? selectedHashTags,
      String? searchTagValue,
      bool? avatarError,
      bool? coverImageError,
      bool? shopNameError,
      bool? cityError,
      bool? addressError,
      File? postImg,
      String? postDes,
      bool? postImgError,
      bool? postDesError,
      bool? isDisableNextStep}) {
    return StoreSignupState(
      step: step ?? this.step,
      isLoading: isLoading ?? this.isLoading,
      userName: userName ?? this.userName,
      pwd: pwd ?? this.pwd,
      error: error ?? this.error,
      agreeTerms: agreeTerms ?? this.agreeTerms,
      usernameError: usernameError ?? this.usernameError,
      pwdError: pwdError ?? this.pwdError,
      avatar: avatar ?? this.avatar,
      coverImage: coverImage ?? this.coverImage,
      shopName: shopName ?? this.shopName,
      address: address ?? this.address,
      city: city ?? this.city,
      selectedHashTags: selectedHashTags ?? this.selectedHashTags,
      searchTagValue: searchTagValue ?? this.searchTagValue,
      postImg: postImg ?? this.postImg,
      postDes: postDes ?? this.postDes,
      avatarError: avatarError ?? this.avatarError,
      coverImageError: coverImageError ?? this.coverImageError,
      shopNameError: shopNameError ?? this.shopNameError,
      cityError: cityError ?? this.cityError,
      addressError: addressError ?? this.addressError,
      postImgError: postImgError ?? this.postImgError,
      postDesError: postDesError ?? this.postDesError,
      isDisableNextStep: isDisableNextStep ?? this.isDisableNextStep,
    );
  }
}
