class PostDetail{
  final bool isToggleReadMore;
  final bool isLoading;

  const PostDetail({
    this.isToggleReadMore = false,
    this.isLoading = false,
  });

  PostDetail copyWith(
    {
      bool? isLoading,
      bool? isToggleReadMore
    }
  ){
    return PostDetail(
      isLoading: isLoading ?? this.isLoading,
      isToggleReadMore: isToggleReadMore ?? this.isToggleReadMore);
    
  }
}