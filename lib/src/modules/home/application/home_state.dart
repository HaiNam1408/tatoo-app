import '../../../core/domain/enums/enums.dart';
import '../../../core/infrastructure/models/post.dart';
import '../../../core/infrastructure/models/profile.dart';



class HomeState {
  final bool isLoading;
  final bool isHeaderLoading;
  final bool isGridHeaderLoading;
  final bool isFooterLoading;
  final String? error;
  final bool isExpandedTime;
  final bool isGridMode;
  final HomeSortOption? sortOptions;
  final bool isToggleReadMore;
  final ProfileModel? profile;
  final List<ProfileModel>? profileList;
  final int profileIndex;
  final List<PostModel>? postList;
  final int currentPage;
  final int totalPages;
  final bool isLoadingPost;

  const HomeState({
    this.isLoading = false,
    this.isHeaderLoading = true,
    this.isGridHeaderLoading = true,
    this.isFooterLoading = true,
    this.error,
    this.isExpandedTime = false,
    this.isGridMode = false,
    this.sortOptions,
    this.isToggleReadMore = false,
      this.profile,
      this.profileList = const [],
      this.profileIndex = 0,
      this.postList = const [],
      this.currentPage = 1,
      this.totalPages = 1,
      this.isLoadingPost = false
  });

  HomeState copyWith(
      {bool? isLoading,
      bool? isHeaderLoading,
      bool? isGridHeaderLoading,
      bool? isFooterLoading,
      String? error,
      bool? isExpandedTime,
      bool? isGridMode,
      HomeSortOption? sortOptions,
      bool? isToggleReadMore,
      ProfileModel? profile,
      List<ProfileModel>? profileList,
      int? profileIndex,
      List<PostModel>? postList,
      int? currentPage,
      int? totalPages,
      bool? isLoadingPost
      }) {
    return HomeState(
        isLoading: isLoading ?? this.isLoading,
        isHeaderLoading: isHeaderLoading ?? this.isHeaderLoading,
        isGridHeaderLoading: isGridHeaderLoading ?? this.isGridHeaderLoading,
        isFooterLoading: isFooterLoading ?? this.isFooterLoading,
        isExpandedTime: isExpandedTime ?? this.isExpandedTime,
        isGridMode: isGridMode ?? this.isGridMode,
        error: error ?? this.error,
        sortOptions: sortOptions ?? this.sortOptions,
        isToggleReadMore: isToggleReadMore ?? this.isToggleReadMore,
        profile: profile ?? this.profile,
        profileList: profileList ?? this.profileList,
        profileIndex: profileIndex ?? this.profileIndex,
        postList: postList ?? this.postList,
        currentPage: currentPage ?? this.currentPage,
        totalPages: totalPages ?? this.totalPages,
        isLoadingPost: isLoadingPost ?? this.isLoadingPost
        );
  }
}
