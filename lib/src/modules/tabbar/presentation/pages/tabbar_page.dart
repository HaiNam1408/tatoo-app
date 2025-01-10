import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import '../../../../../generated/assets.gen.dart';
import '../../../../../generated/colors.gen.dart';
import '../../../../common/extensions/build_context_x.dart';
import '../../../../common/utils/getit_utils.dart';
import '../../../../core/application/cubits/device/app_device_cubit.dart';
import '../../../../core/application/cubits/device/app_device_state.dart';
import '../../../../core/domain/enums/enums.dart';
import '../../../appointment/presentation/page/appointment_page.dart';
import '../../../create_schedule_work/application/schedule_work_cubit.dart';
import '../../../create_schedule_work/domain/interface/schedule_work_repository_interface.dart';
import '../../../create_schedule_work/presentation/pages/schedule_work_page.dart';
import '../../../home/presentation/pages/home_page.dart';
import '../../../message/presentation/pages/message_page.dart';
import '../../../profile/application/profile_cubit.dart';
import '../../../profile/presentation/pages/profile_page.dart';
import '../../../search/presentation/pages/search_page.dart';
import '../../application/tabbar_cubit.dart';
import '../../application/tabbar_state.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

@RoutePage()
class TabBarPage extends StatelessWidget {
  final Role role;
  const TabBarPage({super.key, this.role = Role.USER});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppDeviceCubit, AppDeviceState>(
      builder: (context, state) => AnnotatedRegion<SystemUiOverlayStyle>(
        value: state.appBarMode == Brightness.light
            ? SystemUiOverlayStyle.dark
            : SystemUiOverlayStyle.light,
        child: BlocProvider(
           create: (context) => ScheduleWorkCubit(getIt<IScheduleWorkRepository>()),
          child: TabBarBody(role: role),
        ),
      ),
    );
  }
}

class TabBarBody extends StatefulWidget {
  final Role role;
  const TabBarBody({super.key, required this.role});

  @override
  State<TabBarBody> createState() => _TabBarBodyState();
}

class _TabBarBodyState extends State<TabBarBody> {
  static const List<Widget> _userTabars = <Widget>[
    HomePage(),
    SearchPage(),
    MessagePage(),
    ProfilePage(),
  ];

  static const List<Widget> _storeTabars = <Widget>[
    AppointmentPage(),
    ScheduleWorkPage(),
    MessagePage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: ColorName.background,
      body: BlocConsumer<TabbarCubit, TabbarState>(
          listener: (context, state) {},
          builder: (context, state) {
            final cubit = context.read<TabbarCubit>();
            return Stack(
              children: [
                IndexedStack(
                  index: state.selectedIndex,
                  children:
                      widget.role == Role.USER ? _userTabars : _storeTabars,
                ),
                Positioned(
                  bottom: state.bottomPadding,
                  right: 16,
                  left: 16,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30.h),
                          color: ColorName.dark),
                      height: 60.h,
                      child: LayoutBuilder(builder: (context, constraints) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(30.h),
                          clipBehavior: Clip.hardEdge,
                          child: Stack(
                            children: [
                              AnimatedPositioned(
                                  curve: Curves.linear,
                                  bottom: 0,
                                  top: 0,
                                  left: (state.selectedIndex == 0
                                      ? 4
                                      : state.selectedIndex *
                                          ((constraints.maxWidth - 72) / 4)),
                                  duration: const Duration(milliseconds: 200),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 4.0),
                                    child: Container(
                                      width: constraints.maxWidth / 4 + 50,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(30.h)),
                                    ),
                                  )),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 4.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: AnimateList(effects: [
                                    const SlideEffect(
                                      curve: Curves.linear,
                                    )
                                  ], children: [
                                    _bottomNaviButton(
                                        onSelected: () {
                                          cubit.onTapItem(0);
                                          getIt<ProfileCubit>()
                                              .navigateToPage(0);
                                        },
                                        activeIcon:
                                           widget.role == Role.USER
                                            ? Assets.icons.homeFilled.svg()
                                            : Assets.icons.scheduleFilled.svg(),
                                        icon: widget.role == Role.USER
                                            ? Assets.icons.homeOutline.svg()
                                            : Assets.icons.scheduleOutline
                                                .svg(),
                                        title: widget.role == Role.USER
                                            ? 'Trang chủ'
                                            : 'Lịch hẹn',
                                        isSelected: state.selectedIndex == 0),
                                    _bottomNaviButton(
                                        onSelected: () {
                                          cubit.onTapItem(1);
                                          getIt<ProfileCubit>()
                                              .navigateToPage(0);
                                        },
                                        activeIcon:
                                           widget.role == Role.USER
                                            ? Assets.icons.searchFilled.svg()
                                            : Assets.icons.addScheduleFilled
                                                .svg(),
                                        icon: widget.role == Role.USER
                                            ? Assets.icons.searchOutline.svg()
                                            : Assets.icons.addScheduleOutline
                                                .svg(),
                                        title: widget.role == Role.USER
                                            ? 'Tìm kiếm'
                                            : 'Tạo lịch',
                                        isSelected: state.selectedIndex == 1),
                                    _bottomNaviButton(
                                        onSelected: () {
                                          cubit.onTapItem(2);
                                          getIt<ProfileCubit>()
                                              .navigateToPage(0);
                                        },
                                        activeIcon:
                                            Assets.icons.messageFilled.svg(),
                                        icon: Assets.icons.messageOutline.svg(),
                                        title: 'Tin nhắn',
                                        isSelected: state.selectedIndex == 2),
                                    Center(
                                      child: _bottomNaviButton(
                                          onSelected: () {
                                            cubit.onTapItem(3);
                                            getIt<ProfileCubit>()
                                                .navigateToPage(1);
                                          },
                                          activeIcon:
                                              Assets.icons.profileFilled.svg(),
                                          icon:
                                              Assets.icons.profileOutline.svg(),
                                          title: 'Tài Khoản',
                                          isSelected: state.selectedIndex == 3),
                                    ),
                                  ]),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ),
                  ),
                ),
              ],
            );
          }),
    );
  }

  Widget _bottomNaviButton(
      {required SvgPicture icon,
      required SvgPicture activeIcon,
      required String title,
      required bool isSelected,
      required Function() onSelected}) {
    return InkWell(
      onTap: () {
        onSelected.call();
      },
      // child: AnimatedSwitcher(
      //   duration: const Duration(milliseconds: 300),
      child: !isSelected
          ? SizedBox(width: 60.w, child: Center(child: icon))
          : SizedBox(
              width: 120.w,
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                activeIcon,
                const Gap(8),
                Text(
                  title,
                  style: context.textTheme.bodyMedium
                      .copyWith(color: ColorName.dark),
                )
              ]),
            ),
      // ),
    );
  }
}
