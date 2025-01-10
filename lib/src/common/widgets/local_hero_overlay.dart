import 'package:flutter/widgets.dart';

class LocalHeroOverlay extends StatefulWidget {
  const LocalHeroOverlay({
    super.key,
    this.child,
  });

  final Widget? child;

  @override
  LocalHeroOverlayState createState() => LocalHeroOverlayState();
}

class LocalHeroOverlayState extends State<LocalHeroOverlay> {
  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: Overlay(
        initialEntries: <OverlayEntry>[
          OverlayEntry(builder: (context) => widget.child!),
        ],
      ),
    );
  }
}
