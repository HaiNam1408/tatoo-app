
import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/utils/getit_utils.dart';
import '../../application/message_cubit.dart';
import '../../domain/interfaces/message_repository_interface.dart';
import '../widgets/message_body.dart';

@RoutePage()
class MessagePage extends StatelessWidget {
  const MessagePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<MessageCubit>(
      create: (context) => MessageCubit(getIt<IMessageRepository>()),
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: const Scaffold(
          body: MessageBody(),
        ),
      ),
    );
  }
}

