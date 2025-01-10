import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../common/widgets/build_image.dart';
import '../../../../common/widgets/detail_image_overlay.dart';
import '../../application/conversation_cubit.dart';

class AttachmentCard extends StatelessWidget {
  final int id;
  final String url;
  final bool isSender;
  const AttachmentCard(
      {super.key, required this.url, required this.id, required this.isSender});

  void _showImageOverlay(BuildContext context, String imageUrl) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Image Overlay',
      pageBuilder: (_, __, ___) => DetailImageOverlay(filePath: imageUrl),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: CupertinoContextMenu(
        actions: [
          CupertinoContextMenuAction(
            child: const Text('Lưu hình ảnh'),
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop();
              // Xử lý lưu hình ảnh tại đây
            },
          ),
          if (isSender)
            CupertinoContextMenuAction(
              child: const Text('Thu hồi tin nhắn'),
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop();
                context.read<ConversationCubit>().deleteMessage(id);
                FocusScope.of(context).unfocus();
              },
            ),
        ],
        child: GestureDetector(
          onTap: () {
            showGeneralDialog(
              context: context,
              barrierDismissible: true,
              barrierLabel: 'Image Overlay',
              pageBuilder: (_, __, ___) => DetailImageOverlay(filePath: url),
            );
          },
          child: Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.6,
              maxHeight: 250,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: BuildImage(path: url),
            ),
          ),
        ),
      ),
    );
  }
}
