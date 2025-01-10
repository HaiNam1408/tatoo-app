
	
class ShopInforState {
	final bool isLoading;
  final bool? isRatingSuccess;
	final String? error;
	  
	const ShopInforState({
		this.isLoading = false,
    this.isRatingSuccess,
		this.error,
	});
	  
	ShopInforState copyWith({
		bool? isLoading,
    bool? isRatingSuccess,
		String? error,
	}) {
		return ShopInforState(
			isLoading: isLoading ?? this.isLoading,
      isRatingSuccess: isRatingSuccess ?? this.isRatingSuccess,
			error: error ?? this.error,
		);
	}
}
