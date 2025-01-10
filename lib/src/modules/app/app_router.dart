import 'package:auto_route/auto_route.dart';
import 'package:flutter/widgets.dart';
import 'package:injectable/injectable.dart';

import '../../core/domain/enums/enums.dart';
import '../../core/infrastructure/models/post.dart';
import '../../core/infrastructure/models/profile.dart';
import '../account/presentation/pages/account_page.dart';
import '../create_schedule_work/presentation/pages/schedule_work_editing_page.dart';
import '../login/presentation/pages/login_page.dart';
import '../../modules/auth/presentation/pages/auth_page.dart';
import '../../modules/home/presentation/pages/home_page.dart';
import '../../modules/splash/presentation/pages/splash_page.dart';
import '../appointment/presentation/page/appointment_page.dart';
import '../conversation/presentation/pages/conversation_page.dart';
import '../message/presentation/pages/message_page.dart';
import '../post_detail/presentation/pages/post_detail_page.dart';
import '../profile/presentation/pages/profile_page.dart';
import '../search/presentation/pages/search_page.dart';
import '../search_result/presentation/pages/search_result_page.dart';
import '../tabbar/presentation/pages/tabbar_page.dart';
import '../settings/presentation/pages/settings_page.dart';
import '../supportive/presentation/pages/supportive_page.dart';
import '../shop_infor/presentation/pages/shop_infor_page.dart';
import '../store_signup/presentation/pages/store_signup_page.dart';

part 'app_router.gr.dart';

@singleton
@AutoRouterConfig(replaceInRouteName: 'Page,Route')
class AppRouter extends _$AppRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: SplashRoute.page, path: '/'),
        AutoRoute(page: TabBarRoute.page),
        AutoRoute(page: HomeRoute.page),
        AutoRoute(page: AuthRoute.page),
        AutoRoute(page: SettingsRoute.page),
        AutoRoute(page: ProfileRoute.page),
        AutoRoute(page: LoginRoute.page),
        AutoRoute(page: StoreSignupRoute.page),
        AutoRoute(page: SupportiveRoute.page),
        AutoRoute(
            page: MessageRoute.page,
            type: const RouteType.custom(
                reverseDurationInMilliseconds: 500,
                durationInMilliseconds: 500,
                transitionsBuilder: TransitionsBuilders.fadeIn)),
        AutoRoute(
            page: ConversationRoute.page,
            type: const RouteType.custom(
                reverseDurationInMilliseconds: 500,
                durationInMilliseconds: 500,
                transitionsBuilder: TransitionsBuilders.fadeIn)),
        AutoRoute(page: ShopInforRoute.page),
        AutoRoute(
            page: SearchResultRoute.page,
            type: const RouteType.custom(
                reverseDurationInMilliseconds: 500,
                durationInMilliseconds: 700,
                transitionsBuilder: TransitionsBuilders.fadeIn)),
        AutoRoute(page: ScheduleWorkEditingRoute.page),
      ];
}
