import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../common/utils/getit_utils.dart';
import '../../application/schedule_work_editing_cubit/schedule_work_editing_cubit.dart';
import '../../domain/interface/schedule_work_repository_interface.dart';
import '../widgets/schedule_work_editing_body.dart';

@RoutePage()
class ScheduleWorkEditingPage extends StatelessWidget {
  final int id;
  const ScheduleWorkEditingPage({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) => GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          appBar: AppBar(
              scrolledUnderElevation: 0, title: const Text('Chỉnh sửa')),
          body: BlocProvider(
            create: (context) => ScheduleWorkEditingCubit(getIt<IScheduleWorkRepository>(), id),
            child: const ScheduleWorkEditingBody(),
          ),
        ),
      ),
    );
  }
}
