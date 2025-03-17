// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:wms_mst/utils/colors.dart';
import 'package:wms_mst/utils/textstyle.dart';

class AppbarClass extends StatelessWidget {
  AppbarClass({this.title, super.key});
  String? title;
  @override
  Widget build(BuildContext context) {
    StyleText textStyles = StyleText();
    return AppBar(
      // toolbarHeight: 60,
      elevation: 0,

      // leadingWidth: 24,
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: Icon(Icons.arrow_back_ios_new, size: 20, color: AppColor.black),
      ),
      backgroundColor: AppColor.transparent,
      // centerTitle: true,
      title: Text(
        title!,
        style: textStyles.abyssinicaSilText(
          18,
          FontWeight.w500,
          AppColor.black,
        ),
      ),
    );
  }
}
