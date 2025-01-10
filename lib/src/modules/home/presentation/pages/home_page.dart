import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/utils/getit_utils.dart';
import '../../application/home_cubit.dart';
import '../../domain/interfaces/profile.interfaces.dart';
import '../widgets/home_body.dart';

@RoutePage()
class HomePage extends StatelessWidget {
  
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomeCubit>(
      create: (context) =>HomeCubit(getIt<IProfileRepository>()) ,
      child:const Scaffold(
          body: HomeBody(),
        ),);
  }
}
