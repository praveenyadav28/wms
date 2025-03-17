// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:wms_mst/components/api.dart';
import 'package:wms_mst/components/decoration.dart';
import 'package:wms_mst/components/prefences.dart';
import 'package:wms_mst/ui/home/prospect/follow_up.dart';
import 'package:wms_mst/utils/button.dart';
import 'package:wms_mst/utils/colors.dart';
import 'package:wms_mst/utils/images.dart';
import 'package:wms_mst/utils/mediaquery.dart';
import 'package:wms_mst/utils/navigation.dart';
import 'package:wms_mst/utils/reuse_widget.dart';
import 'package:wms_mst/utils/snackbar.dart';
import 'package:wms_mst/utils/textstyle.dart';

class ShowProspect extends StatefulWidget {
  const ShowProspect({
    super.key,
    required this.dateList,
    required this.priorityDataList,
    required this.prospectStatusList,
    required this.staffList,
  });
  final List<dynamic> dateList;
  final List<Map<String, dynamic>> priorityDataList;
  final List<Map<String, dynamic>> prospectStatusList;
  final List<Map<String, dynamic>> staffList;
  @override
  State<ShowProspect> createState() => _ShowProspectState();
}

class _ShowProspectState extends State<ShowProspect> {
  StyleText textStyles = StyleText();

  List<Map<String, dynamic>> productList = [];
  List<Map<String, dynamic>> varientList = [];

  @override
  void initState() {
    productFunction();
    varientFunction().then((value) {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      runSpacing: Sizes.height * 0.02,
      spacing: 20,
      children: List.generate(widget.dateList.length, (index) {
        // Priority
        int priorityId = widget.dateList[index]['priority'] ?? 0;
        String priorityName =
            priorityId == 0
                ? ""
                : widget.priorityDataList.firstWhere(
                  (element) => element['id'] == priorityId,
                  orElse: () => {'name': ''},
                )['name'];

        //Prospect Status
        int enquerystatusId = widget.dateList[index]['enquiryStatus'];
        String enquerystatusName =
            enquerystatusId == 1
                ? "In Process"
                : widget.prospectStatusList.firstWhere(
                  (element) => element['id'] == enquerystatusId,
                  orElse: () => {'name': ''},
                )['name'];
        //Staff
        int staffId = widget.dateList[index]['salesEx_id'];
        String staffName =
            widget.staffList.isEmpty
                ? ''
                : widget.staffList.firstWhere(
                  (element) => element['id'] == staffId,
                  orElse: () => {'staff_Name': ''},
                )['staff_Name'];

        //Product
        int productId = widget.dateList[index]['enq_Type'] ?? 0;
        String productName =
            productList.isEmpty
                ? ''
                : productList.firstWhere(
                  (element) => element['id'] == productId,
                  orElse: () => {'name': ''},
                )['name'];

        //Varient
        int varientId = widget.dateList[index]['colour_Id'] ?? 0;
        String varientName =
            varientList.isEmpty
                ? ""
                : varientList.firstWhere(
                  (element) => element['id'] == varientId,
                  orElse: () => {'name': ''},
                )['name'];

        return Container(
          width: Sizes.width <= 800 ? double.infinity : Sizes.width * .31,
          decoration: BoxDecoration(
            color: Color(0xffF0DFFF),
            borderRadius: BorderRadius.circular(25),
          ),
          child: ExpansionTile(
            shape: BeveledRectangleBorder(),
            tilePadding: EdgeInsets.zero,
            title: ListTile(
              minVerticalPadding: 0,
              horizontalTitleGap: 0,
              leading: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 2,
                  horizontal: 7.5,
                ),
                margin: const EdgeInsets.only(right: 10),
                decoration: BoxDecoration(
                  color: AppColor.white,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  '${index + 1}',
                  style: textStyles.abyssinicaSilText(
                    18,
                    FontWeight.w500,
                    AppColor.primary,
                  ),
                ),
              ),
              title: Text(
                '${widget.dateList[index]["customer_Name"] ?? 'N/A'}',
                style: textStyles.sarifProText(
                  18,
                  FontWeight.w600,
                  AppColor.primarydark,
                ),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "$priorityName  ",
                    style: textStyles.sarifProText(
                      15,
                      FontWeight.w500,
                      AppColor.primarydark,
                    ),
                  ),
                  Container(
                    width: 17,
                    height: 17,
                    decoration: insideShadow(
                      color:
                          priorityId == 1
                              ? AppColor.blue
                              : priorityId == 2
                              ? AppColor.colYellow
                              : AppColor.red,
                      radius: 2,
                    ),
                  ),
                ],
              ),
            ),
            subtitle: ListTile(
              minVerticalPadding: 0,
              title: Row(
                children: [
                  Image.network(Images.bellIcon, height: 24),
                  Text(
                    '    ${widget.dateList[index]["currentAppointmentDate"] ?? 'N/A'}',
                    style: textStyles.sarifProText(
                      16,
                      FontWeight.w500,
                      AppColor.blue,
                    ),
                  ),
                ],
              ),
              trailing: Text(
                widget.dateList[index]["modelTest_Id"] == 2
                    ? "Demo Done"
                    : widget.dateList[index]["modelTest_Id"] == 1
                    ? "Demo Fixed"
                    : "Demo Pending",
                style: textStyles.abyssinicaSilText(
                  16,
                  FontWeight.w500,
                  widget.dateList[index]["modelTest_Id"] == 2
                      ? AppColor.blue
                      : widget.dateList[index]["modelTest_Id"] == 1
                      ? AppColor.green
                      : AppColor.red,
                ),
              ),
            ),
            trailing: const SizedBox(width: 0, height: 0),
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        InkWell(
                          child: CircleAvatar(
                            radius: 25,
                            backgroundColor: AppColor.white,
                            child: Image.network(Images.smsIcon, height: 28),
                          ),
                          onTap: () {
                            sendMessage(
                              context,
                              '${widget.dateList[index]["mob_No"] ?? 'N/A'}',
                              'Hi ${widget.dateList[index]["customer_Name"] ?? 'N/A'}',
                            );
                          },
                        ),
                        InkWell(
                          child: CircleAvatar(
                            radius: 25,
                            backgroundColor: AppColor.white,
                            child: Image.network(Images.callIcon, height: 40),
                          ),
                          onTap: () {
                            makeCall(
                              context,
                              '${widget.dateList[index]["mob_No"] ?? 'N/A'}',
                            );
                          },
                        ),
                        InkWell(
                          child: CircleAvatar(
                            radius: 25,
                            backgroundColor: AppColor.white,
                            child: Image.network(
                              Images.whatsappIcon,
                              height: 40,
                            ),
                          ),
                          onTap: () {
                            checkAndOpenWhatsApp(
                              '${widget.dateList[index]["mob_No"] ?? 'N/A'}',
                              'Hi ${widget.dateList[index]["customer_Name"] ?? 'N/A'}',
                            );
                          },
                          // onTap: () => openWhatsApp(
                          //     context,
                          //     '${widget.dateList[index]["mob_No"] ?? 'N/A'}',
                          //     'Hi ${widget.dateList[index]["customer_Name"] ?? 'N/A'}'),
                        ),
                      ],
                    ),
                    SizedBox(height: Sizes.height * 0.02),
                    datastyle(
                      "Mobile No.:",
                      ' ${widget.dateList[index]["mob_No"] ?? 'N/A'}',
                      context,
                    ),
                    datastyle(
                      "Alternative No.:",
                      ' ${widget.dateList[index]["phon_No"] ?? 'N/A'}',
                      context,
                    ),
                    datastyle(
                      "Action Taken:",
                      ' ${widget.dateList[index]["last_ActionTaken"] ?? 'N/A'}',
                      context,
                    ),
                    datastyle(
                      "Remark:",
                      ' ${widget.dateList[index]["last_Remark"] ?? 'N/A'}',
                      context,
                    ),
                    datastyle(
                      "Software Price:",
                      ' ${widget.dateList[index]["remark_Special"] ?? 'N/A'}',
                      context,
                    ),
                    if (widget.prospectStatusList != null ||
                        widget.priorityDataList.isNotEmpty)
                      datastyle("Enquery Status :", enquerystatusName, context),
                    Preference.getString(PrefKeys.userType) == "Staff"
                        ? Container()
                        : datastyle("Staff Name:", staffName, context),
                    datastyle("Product:", productName, context),
                    datastyle("Varient:", varientName, context),

                    datastyle(
                      "Last Contact Date:",
                      ' ${widget.dateList[index]["lastContact_Date"] ?? 'N/A'}',
                      context,
                    ),
                    SizedBox(height: Sizes.height * 0.015),
                    Row(
                      children: [
                        Expanded(
                          child: DefaultButton(
                            hight: 30,
                            width: double.infinity,
                            text: "Follow Up",
                            onTap: () {
                              pushTo(
                                FollowUpScreen(
                                  refnom: "${widget.dateList[index]["ref_No"]}",
                                ),
                              );
                            },
                          ),
                        ),
                        SizedBox(
                          width:
                              Preference.getString(PrefKeys.userType) != "Admin"
                                  ? 0
                                  : 20,
                        ),
                        Preference.getString(PrefKeys.userType) != "Admin"
                            ? Container(width: 0)
                            : Expanded(
                              child: DefaultButton(
                                hight: 30,
                                width: double.infinity,
                                text: "Delete",
                                buttonColor: AppColor.red,
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder:
                                        (context) => AlertDialog(
                                          title: const Text('Delete Prospect'),
                                          content: const Text(
                                            "Are you sure you want to delete this prospect from the list?",
                                          ),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(
                                                  context,
                                                ).pop(); // Closes the dialog
                                              },
                                              child: const Text('No'),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                deleteprospect(
                                                  widget
                                                      .dateList[index]['ref_No'],
                                                );
                                              },
                                              child: const Text('Yes'),
                                            ),
                                          ],
                                        ),
                                  );
                                },
                              ),
                            ),
                      ],
                    ),
                    SizedBox(height: Sizes.height * 0.02),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Future<void> deleteprospect(int? id) async {
    try {
      var response = await ApiService.postData(
        "CRM/DeleteProspect?refno=$id&locationid=${Preference.getString(PrefKeys.locationId)}",
        {'ID': id},
      );
      setState(() {
        if (response['result'] == true) {
          widget.dateList.removeWhere((item) => item['ref_No'] == id);
          setState(() {
            Navigator.pop(context);
          });
          showCustomSnackbarSuccess(context, response['message']);
        } else {
          setState(() {
            Navigator.pop(context);
          });
          showCustomSnackbar(context, response['message']);
        }
      });
    } catch (error) {
      setState(() {
        Navigator.pop(context);
      });
      showCustomSnackbar(context, 'Failed to delete prospect');
    }
  }

  Future<void> productFunction() async {
    await fetchDataByMiscTypeId(18, productList);
  }

  Future<void> varientFunction() async {
    await fetchDataByMiscTypeId(17, varientList);
  }
}
