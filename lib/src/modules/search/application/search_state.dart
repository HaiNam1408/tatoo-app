class SearchState {
  final bool isLoading;
  final String? error;
  final List<String>? tagList;

  static const List<String> tags = [
    'Minimalist',
    'Lettering',
    'White Ink',
    '3D',
    'Watercolor',
    'Japanese Style',
  ];

  const SearchState({this.isLoading = false, this.error, this.tagList = tags});

  SearchState copyWith({
    bool? isLoading,
    String? error,
  }) {
    return SearchState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}
