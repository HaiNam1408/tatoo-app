import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../common/utils/getit_utils.dart';
import '../../tabbar/application/tabbar_cubit.dart';
import 'post_detail_state.dart';

class PostDetailCubit extends Cubit<PostDetail> {
  PostDetailCubit() : super(const PostDetail(isLoading: true)) {
    listener();
  }
  PageController pageController = PageController();

  void readMore() {
    emit(state.copyWith(isToggleReadMore: !state.isToggleReadMore));
  }

  void listener() {
    pageController.addListener(() {
      double? pageValue = pageController.page?.toDouble();

      if (pageValue != null && pageController.page!.toDouble() <= 1.0) {
        double convertedValue = (pageValue * -108) + 24;
        getIt<TabbarCubit>().animate(convertedValue);
      }
    });
  }
}


