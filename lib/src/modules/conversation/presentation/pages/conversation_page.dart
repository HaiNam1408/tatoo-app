import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/utils/getit_utils.dart';
import '../../application/conversation_cubit.dart';
import '../../domain/interfaces/conversation_repository_interface.dart';
import '../widgets/conversation_body.dart';

@RoutePage()
class ConversationPage extends StatelessWidget {
  final String userName;
  final String avatarUrl;
  final int receiverId;
  const ConversationPage(
      {super.key,
      required this.userName,
      required this.avatarUrl,
      required this.receiverId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ConversationCubit>(
      create: (context) => ConversationCubit(getIt<IConversationRepository>(), receiverId),
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
            body: ConversationBody(
          userName: userName,
          avatarUrl: avatarUrl,
          receiverId: receiverId,
        )),
      ),
      
    );
  }
}
