import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'tabbar_state.dart';

@singleton
class TabbarCubit extends Cubit<TabbarState> {
  TabbarCubit() : super(const TabbarState());

  void animate(double y) {
    emit(state.copyWith(bottomPadding: y));
  }

  void onTapItem(int index) {
    emit(state.copyWith(selectedIndex: index));
  }

  void animateTabbar(
      {required int animetionTime, required int bottomPadding}) {}
}
