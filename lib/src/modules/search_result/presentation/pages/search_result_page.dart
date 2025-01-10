import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../common/utils/getit_utils.dart';
import '../../application/search_result_cubit.dart';
import '../../domain/interfaces/search_repository_interface.dart';
import '../widgets/search_result_body.dart';

@RoutePage()
class SearchResultPage extends StatelessWidget {
  final String? searchText;
  final bool isFocus;
  const SearchResultPage({super.key, this.searchText, this.isFocus = false});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SearchResultCubit>(
      create: (context) => SearchResultCubit(getIt<ISearchRepository>()),
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          body: SearchResultBody(searchText: searchText, isFocus: isFocus),
        ),
      ),
    );
  }
}
