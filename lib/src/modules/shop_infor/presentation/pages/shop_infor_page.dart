import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/utils/getit_utils.dart';
import '../../../../core/infrastructure/models/profile.dart';
import '../../application/shop_infor_cubit.dart';
import '../../application/shop_infor_state.dart';
import '../../domain/interface/shop_infor_repository_interface.dart';
import '../widgets/shop_infor_body.dart';

@RoutePage()
class ShopInforPage extends StatelessWidget {
  final ProfileModel? profile;
  const ShopInforPage({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider<ShopInforCubit>(
          create: (context) => ShopInforCubit(getIt<IShopInforRepository>(), profile?.id),
          child: BlocBuilder<ShopInforCubit, ShopInforState>(
              builder: (context, state) => ShopInforBody(profile: profile,))),
    );
  }
}
