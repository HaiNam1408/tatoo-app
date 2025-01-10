import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../../../../generated/colors.gen.dart';
import '../../../../common/extensions/build_context_x.dart';

class MessageItem extends StatefulWidget {
  final String title;
  final String subtitle;
  final String avatarUrl;
  final String time;
  const MessageItem(
      {super.key,
      required this.title,
      required this.subtitle,
      required this.avatarUrl,
      required this.time});

  @override
  State<MessageItem> createState() => _MessageItemState();
}

class _MessageItemState extends State<MessageItem> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: ColorName.primary,
            backgroundImage: NetworkImage(widget.avatarUrl),
          ),
          const Gap(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        widget.title,
                        style: context.textTheme.bold
                            .copyWith(color: ColorName.dark),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      widget.time,
                      style: context.textTheme.regular
                          .copyWith(color: ColorName.greyText, fontSize: 12),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
                const Gap(8),
                Text(
                  widget.subtitle,
                  style: context.textTheme.regular
                      .copyWith(color: ColorName.greyText),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
