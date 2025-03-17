import 'package:flutter/material.dart';
import 'package:wms_mst/utils/mediaquery.dart';

class GradientBox extends StatelessWidget {
  GradientBox({required this.child, super.key});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: Sizes.height,
      width: Sizes.width,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xff0F0728), Color(0xff31154A)],
        ),
      ),
      child: child,
    );
  }
}
