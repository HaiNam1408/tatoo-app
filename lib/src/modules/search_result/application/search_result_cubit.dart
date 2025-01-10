import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/infrastructure/models/attachment.dart';
import '../../../core/infrastructure/models/profile.dart';
import '../../../core/infrastructure/models/tag.dart';
import '../domain/interfaces/search_repository_interface.dart';
import 'search_result_state.dart';

class SearchResultCubit extends Cubit<SearchResultState> {
  final ISearchRepository _searchRepository;
  SearchResultCubit(this._searchRepository)
      : super(const SearchResultState(isLoading: false)) {
    listener();
  }

  TextEditingController searchTextController = TextEditingController();
  ScrollController scrollController = ScrollController();
  Timer? debounce;
  final List<ProfileModel> mockShopData = List.generate(6, (index) {
    return ProfileModel(
      id: index,
      storeName: 'Tattoo Store $index',
      avatar: Attachment(
        fileName: 'avatar_$index.png',
        filePath: 'https://picsum.photos/100/100',
      ),
      background: Attachment(
        fileName: 'background_$index.png',
        filePath: 'https://picsum.photos/100/100',
      ),
      address: AddressModel(
        id: index,
        city: 'Hà Nội',
        street: '115, Định Công, Cầu Giấy',
      ),
      profileTag: List.generate(5, (index) {
        return ProfileTagModel(
          id: index,
          tags: TagModel(
            id: index,
            name: 'Style $index',
          ),
        );
      }),
    );
  });

  void changeSearchText(String text) {
    debounce?.cancel();
    searchTextController.text = text;
    debounce = Timer(const Duration(milliseconds: 300), () {
      emit(state.copyWith(
          searchText: text, isLoading: true, resultShopList: mockShopData));
      handleSearchProfile(text, 1, 24);
    });
  }

  Future<void> handleSearchProfile(String? keyword, int page, int limit) async {
    await Future.delayed(const Duration(seconds: 1));
    var result =
        await _searchRepository.searchProfile(keyword ?? '', page, limit);
    result.fold((success) {
      emit(state.copyWith(
        isLoading: false,
        totalPages: success.meta.totalPages,
        resultShopList: page == 1
            ? success.data
            : [...state.resultShopList, ...success.data],
      ));
    }, (failure) {
      emit(state.copyWith(isLoading: false, resultShopList: []));
    });
  }

  void fetchNextPage() {
    if (state.isFetchingMore || state.currentPage >= state.totalPages) return;

    emit(state.copyWith(
        isFetchingMore: true, currentPage: state.currentPage + 1));

    handleSearchProfile(state.searchText, state.currentPage, 24).then((_) {
      emit(state.copyWith(isFetchingMore: false));
    });
  }

  void listener() {
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        fetchNextPage();
      }
    });
  }

  @override
  Future<void> close() {
    debounce?.cancel();
    scrollController.dispose();
    return super.close();
  }
}
