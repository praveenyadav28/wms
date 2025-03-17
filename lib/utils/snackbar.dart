import 'package:flutter/material.dart';
import 'package:wms_mst/utils/colors.dart';
import 'package:wms_mst/utils/textstyle.dart';

//Snackbar Error
void showCustomSnackbar(BuildContext context, String message,
    {Duration duration = const Duration(seconds: 2),
    String? actionLabel,
    VoidCallback? onActionPressed}) {
      
    StyleText textStyles = StyleText(); 
  final snackBar = SnackBar(
    content:  Text(message,style: textStyles.sarifProText(14, FontWeight.w500, AppColor.white)),
    duration: duration,
    backgroundColor: AppColor.red,
    action: actionLabel != null
        ? SnackBarAction(
            label: actionLabel,
            onPressed: onActionPressed ?? () {},
          )
        : null,
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

//Snackbar Success
void showCustomSnackbarSuccess(BuildContext context, String message,
    {Duration duration = const Duration(seconds: 2),
    String? actionLabel,
    VoidCallback? onActionPressed}) {
      
    StyleText textStyles = StyleText(); 
  final snackBar = SnackBar(
    content: Text(message,style: textStyles.sarifProText(14, FontWeight.w500, AppColor.white)),
    duration: duration,
    backgroundColor: AppColor.green,
    action: actionLabel != null
        ? SnackBarAction(
            label: actionLabel,
            onPressed: onActionPressed ?? () {},
          )
        : null,
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
