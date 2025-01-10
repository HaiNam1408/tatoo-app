import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import '../../../../common/utils/getit_utils.dart';
import '../../application/profile_cubit.dart';
import '../../application/profile_state.dart';
class ProfileBody extends StatefulWidget {
  const ProfileBody({super.key});

  @override
  ProfileBodyState createState() => ProfileBodyState();
}

class ProfileBodyState extends State<ProfileBody> {


  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) => Scaffold(
        body: PageView(
          physics: const NeverScrollableScrollPhysics(),
          controller: getIt<ProfileCubit>().modeController,
          children: [
            _buildSecondPage(),
            _buildFirstPage(context, state),
          ],
        ),
      ),
      
    );
  }

  Widget _buildFirstPage(BuildContext context, ProfileState state) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20.0, 32.0, 20.0, 10.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 60,
                  height: 60,
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(state.avatarUrl ?? ''),
                  ),
                ),
                Text(
                  state.userName ?? '',
                  style: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            const Gap(24),
            Container(
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(32.0),
              ),
              child: const Padding(
                padding: EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    Icon(Icons.star_rate_rounded, color: Colors.white),
                    Gap(12),
                    Text(
                      '5 Đánh giá',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
            const Gap(32),
            GestureDetector(
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Cài đặt tài khoản',
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                  ),
                  Icon(
                    Icons.navigate_next_rounded,
                    size: 30,
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Trợ giúp',
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                  ),
                  Icon(
                    Icons.navigate_next_rounded,
                    size: 30,
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                context.read<ProfileCubit>().logout();
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 4),
                color: Colors.transparent,
                child: const Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(
                      'Đăng xuất',
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSecondPage() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
      ),
    );
  }
}
