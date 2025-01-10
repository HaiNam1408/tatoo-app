import 'package:diacritic/diacritic.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../generated/colors.gen.dart';
import '../constants/constants.dart';
import '../extensions/build_context_x.dart';
import 'app_textfield.dart';

class AddressSearchWidget extends StatefulWidget {
  const AddressSearchWidget({super.key, this.onSelected});

  final Function(String)? onSelected;

  @override
  State<AddressSearchWidget> createState() => _AddressSearchWidgetState();
}

class _AddressSearchWidgetState extends State<AddressSearchWidget> {
  final controller = TextEditingController();
  List<String> provinces = Constants.provinces;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.sizeOf(context).height - 100,
      width: MediaQuery.sizeOf(context).width,
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 36.w, vertical: 24.h),
          child: Column(
            children: [
              AppTextfield(
                controller: controller,
                autoFocus: true,
                hintText: 'Nhập tỉnh/thành phố',
                onChanged: (value) {
                  setState(() {
                    provinces = Constants.provinces
                        .where((e) => removeDiacritics(e)
                            .toUpperCase()
                            .contains(controller.text.toUpperCase()))
                        .toList();
                  });
                },
              ),
              Gap(24.h),
              Expanded(
                child: ListView.builder(
                  itemCount: provinces.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        widget.onSelected?.call(provinces[index]);
                      },
                      child: SizedBox(
                        height: 50,
                        child: Text(
                          provinces[index],
                          style: context.textTheme.bodyMedium
                              .copyWith(color: ColorName.dark),
                        ),
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
