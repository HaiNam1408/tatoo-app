import 'package:flutter/material.dart';
import '../../../core/infrastructure/models/profile.dart';
import '../domain/interfaces/profile.interfaces.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../common/utils/getit_utils.dart';
import '../../../common/widgets/base_body.dart';
import '../../../core/application/cubits/device/app_device_cubit.dart';
import '../../../core/domain/enums/enums.dart';
import '../../tabbar/application/tabbar_cubit.dart';
import 'home_state.dart';

@injectable
class HomeCubit extends Cubit<HomeState> {
  final IProfileRepository _profileRepository;
  final ScrollController scrollController = ScrollController();

  HomeCubit(this._profileRepository) : super(const HomeState(isLoading: true)) {
    listener();
    fetchListProfile();
  }

  Future<void> fetchProfileData(int authId) async {
    final result = await _profileRepository.getProfile(authId);
    ProfileModel? response =
        result.fold((success) => success.data, (failure) => null);
    emit(state.copyWith(profile: response));
  }

  Future<void> fetchPostData(int authId, int page, int? limit) async {
    emit(state.copyWith(isLoadingPost: true));
    await Future.delayed(const Duration(seconds: 2));
    final result =
        await _profileRepository.getListPost(authId, page, limit ?? 12);
    if (page > 1) {
      result.fold((success) {
        emit(state.copyWith(
          postList: [...?state.postList, ...success.data],
          totalPages: success.meta.totalPages,
          currentPage: page,
          isLoadingPost: false,
        ));
      }, (failure) {
        emit(state.copyWith(isLoadingPost: false));
      });
    } else {
      result.fold((success) {
        emit(state.copyWith(
            postList: success.data,
            totalPages: success.meta.totalPages,
            currentPage: page,
            isLoadingPost: false));
      }, (failure) {
        emit(state.copyWith(isLoadingPost: false));
      });
    }
  }

  Future<void> fetchListProfile() async {
    var result =
        await _profileRepository.getProfileFollowAddress('Hà Nội', null);
    result.fold((success) {
      emit(state.copyWith(profileList: success.data, isHeaderLoading: false));
      return null;
    }, (failure) => null);
  }

  void changeProfileIndex(int index) {
    emit(state.copyWith(profileIndex: index));
  }

  final List<String> dateOfWeeks = [
    'Thứ 2',
    'Thứ 3',
    'Thứ 4',
    'Thứ 5',
    'Thứ 6',
    'Thứ 7',
    'Chủ Nhật'
  ];
  // TODO: dummy
  final List<String> timesOpen = [
    '08:00 - 20:00',
    '08:00 - 20:00',
    '08:00 - 20:00',
    '08:00 - 20:00',
    '08:00 - 20:00',
    '08:00 - 20:00',
    '08:00 - 12:00'
  ];

  late List<String> combinedScheduleList = List.generate(
    dateOfWeeks.length,
    (index) => index < timesOpen.length
        ? '${dateOfWeeks[index]}: ${timesOpen[index]}'
        : '${dateOfWeeks[index]}: __:__',
  );

  PageController pageController = PageController();
  PageController iconModeControler = PageController();
  PageController modeController = PageController();
  ScrollController headerScrollController = ScrollController();
  BaseBodyController bodyController = BaseBodyController();

  void fakeCallAPIFooter() async {
    await Future.delayed(const Duration(seconds: 3));
    emit(state.copyWith(isFooterLoading: false));
  }

  void onChangePage(index, {int? authId}) async {
    // if (state.currentPage == index) return;
    emit(state.copyWith(isFooterLoading: true));
    pageController.animateToPage(index,
        duration: const Duration(milliseconds: 300), curve: Curves.ease);
    if (index == 1 && authId != null) {
      await fetchProfileData(authId);
      await fetchPostData(authId, 1, 12);
      emit(state.copyWith(isFooterLoading: false));
    } else if (index == 0) {
      emit(state.copyWith(isFooterLoading: true, currentPage: 1));
    }
  }

  void tapTimeExpanded() {
    emit(state.copyWith(isExpandedTime: !state.isExpandedTime));
  }

  void changeMode() {
    if (state.isGridMode) {
      getIt<AppDeviceCubit>().changeStatusBar(Brightness.dark);
    } else {
      getIt<AppDeviceCubit>().changeStatusBar(Brightness.light);
    }
    // TODO: flag
    if (state.isGridHeaderLoading) {
      emit(state.copyWith(isGridHeaderLoading: false));
    }
    state.isGridMode ? bodyController.reverse() : bodyController.forward();
    iconModeControler.animateToPage(state.isGridMode ? 0 : 1,
        duration: const Duration(milliseconds: 300), curve: Curves.linear);

    modeController.animateToPage(state.isGridMode ? 0 : 1,
        duration: const Duration(milliseconds: 300), curve: Curves.linear);

    emit(state.copyWith(isGridMode: !state.isGridMode));
  }

  void onSelectedOption(HomeSortOption option) {
    if (option == state.sortOptions) {
      emit(state.copyWith(sortOptions: HomeSortOption.none));
    } else {
      emit(state.copyWith(sortOptions: option));
    }
  }

  /// listener

  void listener() {
    pageController.addListener(() {
      double? pageValue = pageController.page?.toDouble();

      if (pageValue != null && pageController.page!.toDouble() <= 1.0) {
        double convertedValue = (pageValue * -108) + 24;
        getIt<TabbarCubit>().animate(convertedValue);
      }
    });
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        if (state.currentPage < state.totalPages) {
          fetchPostData(state.profile?.id ?? 0, state.currentPage + 1, 12);
        }
      }
    });
  }
}
