import 'package:flutter_bloc/flutter_bloc.dart';
import '../domain/interface/shop_infor_repository_interface.dart';
import 'shop_infor_state.dart';

class ShopInforCubit extends Cubit<ShopInforState> {
  final int? shopId;
  final IShopInforRepository _repository;
  ShopInforCubit(this._repository, this.shopId)
      : super(const ShopInforState(isLoading: true));

  Future<void> rating(double star) async {
    if (shopId != null) {
      emit(const ShopInforState(
          isLoading: true, error: null, isRatingSuccess: null));

      final result = await _repository.rating(star, shopId!);
      return result.fold((success) {
        emit(state.copyWith(isLoading: false, isRatingSuccess: true));
      },
          (failure) =>
              emit(state.copyWith(isLoading: false, error: failure.message)));
    }
  }
}
