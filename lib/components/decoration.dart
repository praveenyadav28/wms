import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart';
import 'package:wms_mst/utils/colors.dart';
import 'package:wms_mst/utils/mediaquery.dart';

class DecorationContainer extends StatelessWidget {
  DecorationContainer({required this.url, required this.child, super.key});
  String url;
  Widget child;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: Sizes.height,
      width: Sizes.width,
      decoration: BoxDecoration(
        image: DecorationImage(image: NetworkImage(url), fit: BoxFit.cover),
      ),
      child: child,
    );
  }
}

insideShadow({Color? color, double? radius}) {
  return BoxDecoration(
    color: color,
    border: Border.all(color: color ?? AppColor.white),
    boxShadow: [
      //  BoxShadow(
      //       offset: const Offset(2, 2),
      //       blurRadius: 4,
      //       spreadRadius: 5,
      //       color: AppColor.black,
      //       inset: true,
      //     ),
      BoxShadow(
        offset: const Offset(2, 2),
        blurRadius: 4,
        color: AppColor.black.withValues(alpha: 0.2),
        inset: true,
      ),
    ],
    borderRadius: BorderRadius.circular(radius ?? 0),
  );
}
