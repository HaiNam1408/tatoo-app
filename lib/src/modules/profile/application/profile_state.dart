class ProfileState {
  final bool isLoading;
  final String? error;
  final String? userName;
  final String? avatarUrl;
  final double? leftPosition;
  final bool isAuthenticated;

  const ProfileState(
      {this.isLoading = false,
      this.error,
      this.userName,
      this.avatarUrl,
      this.leftPosition = 200,
      this.isAuthenticated = false});

  ProfileState copyWith({
    bool? isLoading,
    String? error,
      String? userName,
      String? avatarUrl,
      double? leftPosition,
      bool? isAuthenticated
  }) {
    return ProfileState(
        isLoading: isLoading ?? this.isLoading,
        error: error ?? this.error,
        userName: userName,
        avatarUrl: avatarUrl,
        leftPosition: leftPosition ?? this.leftPosition,
        isAuthenticated: isAuthenticated ?? this.isAuthenticated);
  }
}
