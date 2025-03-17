import 'package:flutter/material.dart';
import 'package:wms_mst/utils/mediaquery.dart';

class Responsive extends StatelessWidget {
  final Widget mobile;
  final Widget tablet;
  final Widget desktop;

  const Responsive(
      {Key? key,
      required this.mobile,
      required this.desktop,
      required this.tablet})
      : super(key: key);
  static bool isMobile(BuildContext context) => Sizes.width < 600;
  static bool isTablet(BuildContext context) =>
      Sizes.width < 1100 && Sizes.width >= 600;
  static bool isDesktop(BuildContext context) => Sizes.width >= 1100;
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    if (size.width >= 1100) {
      return desktop;
    } else if (size.width >= 600 && size.width < 1100) {
      return tablet;
    } else {
      return mobile;
    }
  }
}
