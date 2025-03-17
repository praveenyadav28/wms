import 'package:flutter/material.dart';
import 'package:wms_mst/components/prefences.dart';
import 'package:wms_mst/ui/home/dashboard/dashboard.dart';
import 'package:wms_mst/ui/onboarding/login.dart';
import 'package:wms_mst/utils/colors.dart';
import 'package:wms_mst/utils/images.dart';
import 'package:wms_mst/utils/mediaquery.dart';
import 'package:wms_mst/utils/navigation.dart';
import 'package:wms_mst/utils/theme.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 1), () {
      Preference.getBool(PrefKeys.userstatus) == false
          ? pushNdRemove(LayoutLogin())
          : pushNdRemove(DashboardScreen());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBox(
        child: CircleAvatar(
          backgroundColor: AppColor.white,
          maxRadius: Sizes.height * 0.17,
          backgroundImage: AssetImage(Images.logopng),
        ),
      ),
    );
  }
}
