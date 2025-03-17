//TextRow
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:wms_mst/utils/colors.dart';
import 'package:wms_mst/utils/mediaquery.dart';
import 'package:wms_mst/utils/reuse_widget.dart';
import 'package:wms_mst/utils/textstyle.dart';
export 'package:url_launcher/url_launcher.dart';

datastyle(
  String title,
  String subtitle,
  BuildContext context, {
  bool dense = false,
}) {
  StyleText textStyles = StyleText();
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 8),
    child: Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: textStyles.abyssinicaSilText(
              17,
              FontWeight.w500,
              AppColor.black,
            ),
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: Text(
            subtitle.trim(),
            style: textStyles.abyssinicaSilText(
              17,
              FontWeight.w500,
              AppColor.grey,
            ),
            textAlign: TextAlign.end,
          ),
        ),
      ],
    ),
  );
}

class ReuseContainer extends StatelessWidget {
  const ReuseContainer({
    super.key,
    required this.text,
    required this.child,
    this.child1,
    this.isList,
    this.child2,
  });
  final String? text;
  final Widget? child;
  final Widget? child1;
  final Widget? child2;
  final bool? isList;
  @override
  Widget build(BuildContext context) {
    StyleText textStyles = StyleText();
    return Container(
      padding: const EdgeInsets.only(bottom: 12, left: 8, right: 8),
      decoration: BoxDecoration(
        color: AppColor.primary,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          SizedBox(
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 1,
                  child: child1 ?? const SizedBox(width: 0, height: 0),
                ),
                Expanded(
                  flex: 4,
                  child: Text(
                    text!,
                    style: textStyles.abyssinicaSilText(
                      20,
                      FontWeight.w500,
                      Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: child2 ?? const SizedBox(width: 0, height: 0),
                ),
              ],
            ),
          ),
          Container(
            padding:
                isList == true
                    ? EdgeInsets.zero
                    : EdgeInsets.symmetric(
                      vertical: Sizes.height * 0.02,
                      horizontal: Sizes.width * 0.02,
                    ),
            decoration: BoxDecoration(
              color: AppColor.white,
              borderRadius: BorderRadius.circular(15),
            ),
            child: child,
          ),
        ],
      ),
    );
  }
}

//Url Louncher
Future sendMessage(
  BuildContext context,
  String phoneNumber,
  String name,
) async {
  if (!await launchUrl(
    Uri.parse("sms:$phoneNumber?body=$name"),
    mode: LaunchMode.externalApplication,
  )) {
    throw Exception('Could not launch ');
  }
}

Future makeCall(BuildContext context, String phoneNumber) async {
  if (!await launchUrl(
    Uri.parse("tel:$phoneNumber"),
    mode: LaunchMode.externalApplication,
  )) {
    throw Exception('Could not launch ');
  }
}

Future openWhatsApp(
  BuildContext context,
  String phoneNumber,
  String name,
) async {
  if (!await launchUrl(
    Uri.parse("https://wa.me/+91$phoneNumber?text=$name"),
    mode: LaunchMode.externalApplication,
  )) {
    throw Exception('Could not launch ');
  }
}

void checkAndOpenWhatsApp(String phoneNumber, String message) async {
  String encodedMessage = Uri.encodeComponent(message);
  String url = "https://wa.me/$phoneNumber?text=$encodedMessage";
  if (Platform.isWindows) {
    try {
      await Process.run('cmd', ['/c', 'start', url]);
    } catch (e) {
      print('Error opening WhatsApp: $e');
    }
  } else {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      print('Could not launch WhatsApp');
    }
  }

  // try {
  //   // Microsoft Store App
  //   await Process.run('explorer', [
  //     'shell:AppsFolder\\5319275A.WhatsAppDesktop_cv1g1gvanyjgm!App',
  //   ]);
  // } catch (e) {
  //   print('Error opening Store App: $e');
  //   try {
  //     // Fallback to Start Command
  //     await Process.run('cmd', ['/c', 'start WhatsApp:']);
  //   } catch (e) {
  //     print('Error opening with Start: $e');
  //   }
  // }
}
