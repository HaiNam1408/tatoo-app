import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gallery_picker/gallery_picker.dart';
import '../../../../../generated/assets.gen.dart';
import '../../../../../generated/colors.gen.dart';

class MessageImagePicker extends StatefulWidget {
  final GalleryMedia allMedia;
  final Function onSendAttachment;
  const MessageImagePicker(
      {super.key, required this.allMedia, required this.onSendAttachment});

  @override
  State<MessageImagePicker> createState() => _MessageImagePickerState();
}

class _MessageImagePickerState extends State<MessageImagePicker> {
  int? selectImageIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorName.dark,
      appBar: AppBar(
        leadingWidth: 0,
        leading: const SizedBox.shrink(),
        title: const Text(
          'Lựa chọn hình ảnh',
          style: TextStyle(color: ColorName.primary, fontSize: 16),
        ),
        scrolledUnderElevation: 0,
        backgroundColor: ColorName.dark,
        actions: [
          if (selectImageIndex != null)
            IconButton(
                icon: Assets.icons.sendMessage.svg(
                    colorFilter: const ColorFilter.mode(
                        ColorName.white, BlendMode.srcIn)),
                onPressed: () async {
                  File? file = await widget
                      .allMedia.albums[0].medias[selectImageIndex!]
                      .getFile();
                  widget.onSendAttachment(file);
                  Navigator.pop(context);
                }),
        ],
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(8.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 5,
          crossAxisSpacing: 5,
        ),
        itemCount: widget.allMedia.albums[0].medias.length,
        itemBuilder: (context, index) {
          final mediaFile = widget.allMedia.albums[0].medias[index];
          final isSelected = index == selectImageIndex;

          return GestureDetector(
            onTap: () {
              setState(() =>
                  selectImageIndex = selectImageIndex == index ? null : index);
            },
            child: Stack(
              children: [
                ThumbnailMedia(
                  media: mediaFile,
                  backgroundColor: ColorName.dark,
                  width: MediaQuery.sizeOf(context).width / 3,
                  height: MediaQuery.sizeOf(context).width / 3,
                ),
                if (isSelected)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check,
                        size: 18,
                        color: ColorName.primary,
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
