import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../application/home_cubit.dart';
import '../../application/home_state.dart';
import 'footer_page.dart';
import 'head_page.dart';

class HomeBody extends StatelessWidget {
  const HomeBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) => PageView(
        onPageChanged: (index) => {
          context.read<HomeCubit>().onChangePage(index,
              authId: state.profileList?[state.profileIndex].id),
        },
        physics: const ClampingScrollPhysics(),
        controller: context.read<HomeCubit>().pageController,
        scrollDirection: Axis.vertical,
        children: [
          HeadPage(state), if (!state.isGridMode) FooterPage(state)],
      ),
    );
  }

}
