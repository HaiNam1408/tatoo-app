import 'dart:io';

class AccountState {
  final bool isLoading;
  final String? error;
  final bool isFooterLoading;
  final bool isExpandedTime;
  final File? imagePathBackground;
  final File? imagePathAvatar;
  final double starNumber;  
  final int totalRatings;  

  const AccountState({
    this.isLoading = false,
    this.error,
    this.isFooterLoading = false,
    this.isExpandedTime = false,
    this.imagePathBackground,
    this.imagePathAvatar,
    this.starNumber = 5.0,  
    this.totalRatings = 100, 
  });

  AccountState copyWith({
    bool? isLoading,
    String? error,
    bool? isFooterLoading,
    bool? isExpandedTime,
    File? imagePathAvatar,
    File? imagePathBackground,
    double? starNumber,
    int? totalRatings,
  }) {
    return AccountState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      isFooterLoading: isFooterLoading ?? this.isFooterLoading,
      isExpandedTime: isExpandedTime ?? this.isExpandedTime,
      imagePathBackground: imagePathBackground ?? this.imagePathBackground,
      imagePathAvatar: imagePathAvatar ?? this.imagePathAvatar,
      starNumber: starNumber ?? this.starNumber,
      totalRatings: totalRatings ?? this.totalRatings,
    );
  }
}