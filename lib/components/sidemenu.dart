import 'package:flutter/material.dart';
import 'package:wms_mst/components/prefences.dart';
import 'package:wms_mst/ui/home/dashboard/dashboard.dart';
import 'package:wms_mst/ui/home/drawer.dart/easy_notes/easynotes.dart';
import 'package:wms_mst/ui/home/drawer.dart/policy.dart';
import 'package:wms_mst/ui/home/drawer.dart/report.dart';
import 'package:wms_mst/ui/home/prospect/allprospect.dart';
import 'package:wms_mst/ui/home/staff/staff_list.dart';
import 'package:wms_mst/ui/onboarding/login.dart';
import 'package:wms_mst/utils/colors.dart';
import 'package:wms_mst/utils/images.dart';
import 'package:wms_mst/utils/mediaquery.dart';
import 'package:wms_mst/utils/navigation.dart';
import 'package:wms_mst/utils/textstyle.dart';
import 'package:wms_mst/utils/theme.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({super.key});

  @override
  Widget build(BuildContext context) {
    StyleText textStyles = StyleText();

    return Drawer(
      backgroundColor: AppColor.white,
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              child: DrawerHeader(
                margin: EdgeInsets.symmetric(horizontal: 4),
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xff0F0728), Color(0xff31154A)],
                  ),
                ),
                child: Center(
                  child: CircleAvatar(
                    maxRadius: Sizes.height * 0.1,
                    backgroundImage: AssetImage(Images.logopng),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
              child: SizedBox(
                height: 47,
                child: GradientBox(
                  child: Text(
                    'Modern Software Technologies Pvt Ltd.',
                    style: TextStyle(
                      fontFamily: 'Times New Roman',
                      color: AppColor.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ),
            DrawerListtile(
              onTap: () {
                pushNdRemove(const DashboardScreen());
              },
              title: "Dashboard",
            ),
            DrawerListtile(
              onTap: () {
                pushNdRemove(const ReportScreen());
              },
              title: "Scheduled Report",
            ),
            DrawerListtile(
              onTap: () {
                pushNdRemove(EasyNotes());
              },
              title: "Easy Notes",
            ),
            // Preference.getString(PrefKeys.userType) == "Staff"
            //     ? Container()
            //     : DrawerListtile(
            //       onTap: () {
            //         // pushNdRemove(
            //         //   const MyAccount(),
            //         // );
            //       },
            //       title: "My Account",
            //     ),
            DrawerListtile(
              onTap: () {
                pushNdRemove(const AllProspacts());
              },
              title: "All Prospect",
            ),
            DrawerListtile(onTap: () {}, title: "Calling Logs"),
            Preference.getString(PrefKeys.userType) == "Staff"
                ? Container()
                : DrawerListtile(
                  onTap: () {
                    pushNdRemove(GetStaffWidget());
                  },
                  title: "Our Staff",
                ),
            DrawerListtile(onTap: () {}, title: "Software Details"),
            DrawerListtile(
              onTap: () {
                pushNdRemove(CompanyPolicy());
              },
              title: "Company Policy",
            ),

            DrawerListtile(
              onTap: () {
                logoutPrefData();
                pushNdRemove(const LayoutLogin());
              },
              title: "Logout",
              style: textStyles.albertsans(18, FontWeight.w700, AppColor.red),
            ),
          ],
        ),
      ),
    );
  }
}

class DrawerListtile extends StatelessWidget {
  DrawerListtile({
    required this.title,
    required this.onTap,
    this.style,
    super.key,
  });
  final String title;
  final TextStyle? style;
  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    StyleText textStyles = StyleText();
    return Row(
      children: [
        Expanded(
          flex: 9,
          child: InkWell(
            onTap: onTap,

            child: Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: AppColor.grey,
                    blurRadius: 2,
                    spreadRadius: 0,
                    offset: Offset(0, 1),
                  ),
                ],
                color:
                    style != null
                        ? Color.fromARGB(255, 250, 208, 208)
                        : AppColor.white,
                border: Border.all(color: AppColor.grey),
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.symmetric(vertical: 7),
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              child: Text(
                title,
                style:
                    style ??
                    textStyles.albertsans(
                      18,
                      FontWeight.w700,
                      AppColor.primarydark,
                    ),
              ),
            ),
          ),
        ),
        Expanded(flex: 2, child: Container()),
      ],
    );
  }
}
