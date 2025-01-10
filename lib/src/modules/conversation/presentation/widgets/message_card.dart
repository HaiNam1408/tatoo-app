import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../../../generated/colors.gen.dart';
import '../../../../common/extensions/build_context_x.dart';
import '../../../../core/infrastructure/models/attachment.dart';
import '../../application/conversation_cubit.dart';
import 'attachment_card.dart';

class MessageCard extends StatelessWidget {
  final int id;
  final String? text;
  final String time;
  final Attachment? attachment;
  final bool isSender;
  const MessageCard(
      {super.key,
      required this.text,
      required this.time,
      required this.isSender,
      required this.attachment,
      required this.id});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          crossAxisAlignment:
              isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              textDirection: isSender ? TextDirection.rtl : TextDirection.ltr,
              children: [
                if (attachment != null && text == null)
                  AttachmentCard(
                      id: id,
                      url: attachment?.filePath ?? '',
                      isSender: isSender)
                else if (text == '')
                  Container(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.7,
                    ),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border.all(color: ColorName.dark),
                      color: ColorName.greyBg,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: DefaultTextStyle(
                      style: context.textTheme.bodySmall
                          .copyWith(color: ColorName.dark),
                      child: const Text('Tin nhắn đã được thu hồi'),
                    ),
                  )
                else
                  CupertinoContextMenu(
                    actions: [
                      CupertinoContextMenuAction(
                        child: const Text('Sao chép'),
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: text ?? ''));
                          Navigator.of(context, rootNavigator: true).pop();
                        },
                      ),
                      if (isSender)
                        CupertinoContextMenuAction(
                          child: const Text('Thu hồi tin nhắn'),
                          onPressed: () {
                            context.read<ConversationCubit>().deleteMessage(id);
                            Navigator.of(context, rootNavigator: true).pop();
                          },
                        ),
                    ],
                    child: Container(
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.7,
                      ),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.all(color: ColorName.dark),
                        color: isSender ? ColorName.dark : ColorName.white,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: DefaultTextStyle(
                        style: context.textTheme.bodySmall.copyWith(
                            color: isSender ? ColorName.white : ColorName.dark),
                        child: Text(
                          text ?? '',
                        ),
                      ),
                    ),
                  ),
                const SizedBox(width: 8),
                Skeleton.ignore(
                  child: Text(
                    time,
                    style: context.textTheme.labelMedium.copyWith(
                      color: ColorName.greyText,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
