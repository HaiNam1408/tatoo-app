import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../../generated/assets.gen.dart';

class AppBackButton extends StatelessWidget {
  const AppBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.router.maybePop(),
      child: Assets.icons.arrowLeft.svg(),);
  }
}