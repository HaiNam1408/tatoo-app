import 'package:flutter/material.dart';
import 'build_image.dart';

class DetailImageOverlay extends StatefulWidget {
  final String filePath;

  const DetailImageOverlay({super.key, required this.filePath});

  @override
  State<DetailImageOverlay> createState() => _DetailImageOverlayState();
}

class _DetailImageOverlayState extends State<DetailImageOverlay> {
  double _scale = 1.0;
  Offset _offset = Offset.zero;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.8),
      body: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            _offset += details.delta;
            _scale = 1.0 -
                (_offset.distance / MediaQuery.of(context).size.height)
                    .clamp(0.0, 0.5);
          });
        },
        onPanEnd: (details) {
          if (_offset.distance > 10) {
            Navigator.pop(context);
          } else {
            setState(() {
              _offset = Offset.zero;
              _scale = 1.0;
            });
          }
        },
        onTap: () {
          Navigator.pop(context);
        },
        child: Center(
          child: Transform.translate(
            offset: _offset,
            child: Transform.scale(
              scale: _scale,
              child: BuildImage(path: widget.filePath, fit: BoxFit.contain),
            ),
          ),
        ),
      ),
    );
  }
}
