import '../../../core/infrastructure/models/profile.dart';

class SearchResultState {
  final bool isLoading;
  final String? error;
  final String? searchText;
  final List<ProfileModel> resultShopList;
  final int currentPage;
  final int totalPages;
  final bool isFetchingMore;

  const SearchResultState({
    this.isLoading = false,
    this.error,
    this.searchText,
    this.resultShopList = const [],
    this.currentPage = 1,
    this.totalPages = 1,
    this.isFetchingMore = false,
  });

  SearchResultState copyWith({
    bool? isLoading,
    String? error,
    String? searchText,
    List<ProfileModel>? resultShopList,
    int? currentPage,
    int? totalPages,
    bool? isFetchingMore,
  }) {
    return SearchResultState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      searchText: searchText ?? this.searchText,
      resultShopList: resultShopList ?? this.resultShopList,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      isFetchingMore: isFetchingMore ?? this.isFetchingMore,
    );
  }
}
