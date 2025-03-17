// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:wms_mst/components/responsive.dart';
import 'package:wms_mst/utils/colors.dart';
import 'package:wms_mst/utils/images.dart';
import 'package:wms_mst/utils/mediaquery.dart';

class OnboardingScreen extends StatelessWidget {
  OnboardingScreen({required this.child, super.key});
  Widget? child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      body: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              width:
                  !Responsive.isMobile(context)
                      ? Sizes.width * 0.4
                      : Sizes.width * .5,
              height: Sizes.height,
              color: AppColor.primary,
            ),
          ),
          Container(
            width: Sizes.width * 0.8,
            height: Sizes.height * 0.8,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: AppColor.white,
              boxShadow: [
                BoxShadow(
                  color: AppColor.black.withValues(alpha: 0.4),
                  spreadRadius: .1,
                  blurRadius: 30,
                ),
              ],
            ),
            child:
                !Responsive.isMobile(context)
                    ? Row(
                      children: [
                        Container(
                          width: Sizes.width * .3,
                          height: Sizes.height * 0.8,
                          decoration: BoxDecoration(
                            color: AppColor.primary,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              bottomLeft: Radius.circular(10),
                            ),
                          ),
                          child: Image.asset(Images.logopng),
                        ),
                        Container(
                          width: Sizes.width * .5,
                          padding: EdgeInsets.symmetric(
                            horizontal:
                                !Responsive.isTablet(context)
                                    ? Sizes.width * 0.15
                                    : Sizes.width * 0.11,
                          ),
                          alignment: Alignment.center,
                          child: child,
                        ),
                      ],
                    )
                    : Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: Sizes.width * 0.04,
                      ),
                      child: child,
                    ),
          ),
        ],
      ),
    );
  }
}
