import 'package:flutter/material.dart';
import 'package:wms_mst/components/responsive.dart';
import 'package:wms_mst/utils/colors.dart';
import 'package:wms_mst/utils/mediaquery.dart';
import 'package:wms_mst/utils/textstyle.dart';

Widget addMasterOutside({
  required List<Widget> children,
  required BuildContext context,
}) {
  return GridView.count(
    physics: const NeverScrollableScrollPhysics(),
    childAspectRatio:
        (Responsive.isMobile(context))
            ? Sizes.width >= 450
                ? 8
                : Sizes.width <= 450
                ? 6
                : 7
            : (Responsive.isTablet(context))
            ? Sizes.width >= 800
                ? 5
                : Sizes.width <= 700
                ? 5
                : 6
            : 5,
    shrinkWrap: true,
    crossAxisSpacing: Sizes.width * 0.03,
    mainAxisSpacing: Sizes.height * .03,
    crossAxisCount:
        (Responsive.isMobile(context))
            ? 1
            : (Responsive.isTablet(context))
            ? Sizes.width >= 800
                ? 3
                : 2
            : 3,
    children: children,
  );
}

// Utility function for creating table headers
Widget tableHeader(String text) {
  StyleText textStyles = StyleText();
  return SizedBox(
    height: Sizes.height * 0.05,
    child: Center(
      child: Text(
        text,
        style: textStyles.abyssinicaSilText(
          14,
          FontWeight.w700,
          AppColor.primary,
        ),
      ),
    ),
  );
}

// Utility function for creating table headers
Widget tableRow(String text) {
  StyleText textStyles = StyleText();
  return Text(
    text,
    style: textStyles
        .abyssinicaSilText(14, FontWeight.w500, AppColor.black)
        .copyWith(height: 2),
    textAlign: TextAlign.center,
  );
}
