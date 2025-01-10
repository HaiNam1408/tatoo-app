import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'custom_placeholder_widget.dart';

class CacheImageWidget extends StatefulWidget {
  const CacheImageWidget(
      {super.key,
      required this.url,
      this.fit = BoxFit.cover,
      this.radius,
      this.height,
      this.width});
  final String url;
  final BoxFit fit;
  final double? radius;
  final double? width;
  final double? height;

  @override
  State<CacheImageWidget> createState() => _CacheImageWidgetState();
}

class _CacheImageWidgetState extends State<CacheImageWidget> {
  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(widget.radius ?? 0),
      child: CachedNetworkImage(
        width: widget.width,
        height: widget.height,
        imageUrl: widget.url,
        imageBuilder: (context, imageProvider) => CustomLoading(
          isLoading: false,
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: imageProvider,
                fit: widget.fit,
              ),
            ),
          ),
        ),
        placeholder: (context, url) => CustomLoading(
          isLoading: isLoading,
            child: Container(
              color: Colors.white,
              width: 1000,
              height: 1000,
            )),
        errorWidget: (context, url, error) => const Icon(Icons.error),
      ),
    );
  }
}
