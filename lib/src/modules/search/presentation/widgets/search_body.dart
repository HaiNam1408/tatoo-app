import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import '../../../../common/utils/getit_utils.dart';
import '../../../app/app_router.dart';
import '../../../../../generated/assets.gen.dart';
import '../../../../../generated/colors.gen.dart';
import '../../../../common/extensions/build_context_x.dart';
import '../../../../common/widgets/tag_custom.dart';
import '../../../tabbar/application/tabbar_cubit.dart';
import '../../application/search_cubit.dart';
import '../../application/search_state.dart';

class SearchBody extends StatelessWidget {
  const SearchBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchCubit, SearchState>(
      builder: (context, state) => Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(132),
          child: AppBar(
            backgroundColor: ColorName.dark,
            elevation: 0,
            flexibleSpace: Center(
              child: SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 16, top: 40, bottom: 8),
                      child: Text(
                        // TODO: localize
                        'Tìm kiếm',
                        style: context.textTheme.bold
                            .copyWith(fontSize: 24, color: ColorName.primary),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Hero(
                        tag: 'search_input',
                        child: SizedBox(
                          height: 48,
                          child: Material(
                            borderRadius: BorderRadius.circular(24),
                            child: TextField(
                              onTap: () {
                                getIt<TabbarCubit>().animateTabbar(
                                    animetionTime: 300, bottomPadding: -80);
                                context.router
                                    .push(SearchResultRoute(isFocus: true))
                                    .then((value) {
                                  getIt<TabbarCubit>().animateTabbar(
                                      animetionTime: 600, bottomPadding: 24);
                                });
                              },
                              readOnly: true,
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
                                          ColorName.greyText, BlendMode.srcIn)),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 8),
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
                          top: 24.h,
                          left: 16.h,
                          right: 16.h,
                        ),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(24),
                            topRight: Radius.circular(24),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '#Tagdexuat',
                              style: context.textTheme.bold
                                  .copyWith(color: ColorName.black),
                            ),
                            const Gap(12),
                            if (state.tagList!.isNotEmpty)
                              Wrap(
                                  spacing: 8,
                                  runSpacing: 10,
                                  children: state.tagList!
                                      .map((tag) => TagCustom(
                                          text: tag,
                                          onTap: () async {
                                            getIt<TabbarCubit>().animateTabbar(
                                                animetionTime: 300,
                                                bottomPadding: -80);
                                            context.router
                                                .push(SearchResultRoute(
                                                    searchText: tag))
                                                .then((value) {
                                              getIt<TabbarCubit>()
                                                  .animateTabbar(
                                                      animetionTime: 600,
                                                      bottomPadding: 24);
                                            });
                                          }))
                                      .toList())
                          ],
                        )),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
