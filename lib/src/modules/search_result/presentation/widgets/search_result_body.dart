import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../../../generated/assets.gen.dart';
import '../../../../../generated/colors.gen.dart';
import '../../../../common/extensions/build_context_x.dart';
import '../../../../common/extensions/shimmer_effect.dart';
import '../../application/search_result_cubit.dart';
import '../../application/search_result_state.dart';
import 'search_shop_card.dart';

class SearchResultBody extends StatefulWidget {
  final String? searchText;
  final bool isFocus;
  const SearchResultBody({
    super.key,
    this.searchText,
    this.isFocus = false,
  });

  @override
  State<SearchResultBody> createState() => _SearchResultBodyState();
}

class _SearchResultBodyState extends State<SearchResultBody> {
  final FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    if (widget.searchText != null) {
      context.read<SearchResultCubit>().changeSearchText(widget.searchText!);
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.isFocus) {
        Future.delayed(const Duration(milliseconds: 600), () {
          focusNode.requestFocus();
        });
      }
    });
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchResultCubit, SearchResultState>(
      builder: (context, state) => Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(100),
          child: AppBar(
            backgroundColor: ColorName.dark,
            elevation: 0,
            flexibleSpace: Center(
              child: Padding(
                padding: const EdgeInsets.only(left: 16, top: 40, right: 16),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => context.router.maybePop(),
                      child: Assets.icons.arrowLeft.svg(
                          colorFilter: const ColorFilter.mode(
                              ColorName.white, BlendMode.srcIn)),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Hero(
                        tag: 'search_input',
                        child: SizedBox(
                          height: 48,
                          child: DefaultTextStyle(
                            style: context.textTheme.regular,
                            child: Material(
                              borderRadius: BorderRadius.circular(24),
                              child: TextField(
                                focusNode: focusNode,
                                controller: context
                                    .read<SearchResultCubit>()
                                    .searchTextController,
                                onChanged: (value) {
                                  context
                                      .read<SearchResultCubit>()
                                      .changeSearchText(value);
                                },
                                style: const TextStyle(
                                    color: ColorName.dark, fontSize: 18),
                                decoration: InputDecoration(
                                  // TODO: localize
                                  hintText: 'Nhập tìm kiếm',
                                  hintStyle: context.textTheme.regular
                                      .copyWith(color: ColorName.greyText),
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(24),
                                    borderSide: BorderSide.none,
                                  ),
                                  suffixIcon: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Assets.icons.searchOutline.svg(
                                        colorFilter: const ColorFilter.mode(
                                            ColorName.greyText,
                                            BlendMode.srcIn)),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 8),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        body: Stack(
          children: [
            Positioned.fill(
              child: Container(
                color: ColorName.dark,
                child: Hero(
                  tag: 'search_body',
                  child: DefaultTextStyle(
                    style: context.textTheme.regular,
                    child: Container(
                      padding: EdgeInsets.only(
                        left: 24.h,
                      ),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(24),
                          topRight: Radius.circular(24),
                        ),
                      ),
                      child: Skeletonizer(
                        enabled: state.isLoading,
                        effect: CustomShimmerEffect.shimmerEffect,
                        ignoreContainers: true,
                        child: ListView.builder(
                          controller: context
                              .read<SearchResultCubit>()
                              .scrollController,
                          padding: const EdgeInsets.symmetric(vertical: 24),
                          physics: const BouncingScrollPhysics(),
                          itemCount: state.resultShopList.length +
                              (state.isFetchingMore ? 3 : 0),
                          itemExtent: 100,
                          itemBuilder: (context, index) {
                            if (index >= state.resultShopList.length) {
                              return Skeletonizer(
                                enabled: true,
                                effect: CustomShimmerEffect.shimmerEffect,
                                ignoreContainers: true,
                                child: SearchShopCard(
                                    profile: context
                                        .read<SearchResultCubit>()
                                        .mockShopData[0]),
                              );
                            }
                            return SearchShopCard(
                                profile: state.resultShopList[index]);
                          },
                        ),
                      ),

                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
