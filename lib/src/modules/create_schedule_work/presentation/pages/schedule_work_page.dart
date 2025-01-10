import 'package:flutter/material.dart';
import '../widgets/schdule_work_body.dart';


class ScheduleWorkPage extends StatelessWidget {
  const ScheduleWorkPage({super.key});

   @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) => GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          body: ScheduleWorkBody(onImageSelected: (File ) {  },),
        ),
      ),
    );
  }
}

