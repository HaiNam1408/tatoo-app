import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../common/utils/getit_utils.dart';
import '../../application/appointment_cubit.dart';
import '../../domain/interfaces/appointment_repository_interface.dart';
import '../widgets/appointment_body.dart';

@RoutePage()
class AppointmentPage extends StatelessWidget {
  const AppointmentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AppointmentCubit>(
      create: (context) => AppointmentCubit(getIt<IAppointmentRepository>()),
      child: const Scaffold(
        body: AppointmentBody(),
      ),
    );
  }
}
