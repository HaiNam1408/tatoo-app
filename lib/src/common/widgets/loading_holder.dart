import 'package:flutter/material.dart';

import 'custom_placeholder_widget.dart';

class LoadingHolder extends StatelessWidget {
  const LoadingHolder({super.key, required this.width, required this.height});

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return CustomLoading(isLoading: true, child: Container(color: Colors.white, width: width, height: height,));
  }
}