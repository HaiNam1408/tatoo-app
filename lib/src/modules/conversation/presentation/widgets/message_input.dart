import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../generated/assets.gen.dart';
import '../../../../../generated/colors.gen.dart';
import '../../../../common/extensions/build_context_x.dart';
import '../../application/conversation_cubit.dart';

class MessageInput extends StatelessWidget {
  const MessageInput({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      color: ColorName.white,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: TextField(
              controller: context.read<ConversationCubit>().messageController,
              keyboardType: TextInputType.multiline,
              maxLines: 5,
              minLines: 1,
              style:
                  context.textTheme.bodyMedium.copyWith(color: ColorName.dark),
              decoration: InputDecoration(
                // TODO: localize
                hintText: 'Nhập tin nhắn',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(10),
                  child: GestureDetector(
                      onTap: () {
                        context
                            .read<ConversationCubit>()
                            .selectAttachment(context);
                      },
                      child: Assets.icons.gallery.svg()),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            padding: const EdgeInsets.all(14),
            icon: Assets.icons.sendMessage.svg(),
            style: const ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(ColorName.dark),
            ),
            onPressed: () {
              context.read<ConversationCubit>().sendMessage(context);
            },
          ),
        ],
      ),
    );
  }
}
