// ignore_for_file: unnecessary_null_comparison

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:wms_mst/components/api.dart';
import 'package:wms_mst/components/decoration.dart';
import 'package:wms_mst/components/layout.dart';
import 'package:wms_mst/components/prefences.dart';
import 'package:wms_mst/components/responsive.dart';
import 'package:wms_mst/utils/button.dart';
import 'package:wms_mst/utils/colors.dart';
import 'package:wms_mst/utils/images.dart';
import 'package:wms_mst/utils/mediaquery.dart';
import 'package:wms_mst/utils/snackbar.dart';
import 'package:wms_mst/utils/textformfield.dart';
import 'package:wms_mst/utils/textstyle.dart';

class FollowUpScreen extends StatefulWidget {
  final String? refnom;
  FollowUpScreen({super.key, required this.refnom});
  @override
  State<FollowUpScreen> createState() => _FollowUpScreenState();
}

class _FollowUpScreenState extends State<FollowUpScreen> {
  final TextEditingController _splController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _contactnumberController =
      TextEditingController();
  final TextEditingController _remarksController = TextEditingController();
  final TextEditingController _actionController = TextEditingController();
  final TextEditingController _appointmentDate = TextEditingController(
    text: DateFormat('yyyy/MM/dd').format(DateTime.now()),
  );

  bool isload = false;
  //Priority
  final List<Map<String, dynamic>> priorityDataList = [
    {'id': 3, 'name': 'Hot'},
    {'id': 2, 'name': 'Normal'},
    {'id': 1, 'name': 'Cold'},
  ];
  int? selectedPriorityId;

  final List<Map<String, dynamic>> demoDataList = [
    {'id': 0, 'name': 'Demo Pending'},
    {'id': 1, 'name': 'Demo Fixed'},
    {'id': 2, 'name': 'Demo Done'},
  ];
  int selectedDemoId = 0;

  int? productId;

  //Priority
  final List<Map<String, dynamic>> enqueryDataList = [
    {'id': 105, 'name': 'In Process'},
    {'id': 107, 'name': 'Not Intrested'},
    {'id': 108, 'name': 'Sale Closed'},
  ];
  int selectedenqueryId = 105;

  //Data
  List getAllRemarkList = [];
  //date

  List<Map<String, String>> dataList = [];

  refreshData() async {
    await PrefixData();
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      refreshData();
    });
  }

  @override
  void dispose() {
    _splController.clear();
    _remarksController.clear();
    _contactnumberController.clear();
    super.dispose();
  }

  StyleText textStyles = StyleText();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios_new),
        ),
        centerTitle: true,
        backgroundColor: AppColor.primary,
        title: Text("Follow Up", style: TextStyle(color: AppColor.white)),
      ),
      backgroundColor: AppColor.white,
      body: DecorationContainer(
        url: Images.other1,

        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              vertical: Sizes.height * 0.02,
              horizontal:
                  (Responsive.isMobile(context))
                      ? Sizes.width * .03
                      : Sizes.width * 0.13,
            ),
            child: Container(
              decoration: BoxDecoration(
                color: AppColor.black.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.symmetric(
                vertical: Sizes.height * .04,
                horizontal: Sizes.width * .03,
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        "Follow-up Details ",
                        style: textStyles.adlamText(
                          18,
                          FontWeight.w400,
                          AppColor.black,
                        ),
                      ),
                      Expanded(
                        child: Container(height: 1, color: AppColor.black),
                      ),
                    ],
                  ),
                  SizedBox(height: Sizes.height * .02),
                  addMasterOutside(
                    context: context,
                    children: [
                      Stack(
                        children: [
                          commonTextField(
                            _contactController,
                            labelText: "Customer Name",
                            prefixIcon: SizedBox(width: 80),
                            borderColor: AppColor.colYellow.withValues(
                              alpha: 0.6,
                            ),
                          ),
                          SizedBox(
                            width: 80,
                            child: CoverTextField(
                              boxColor:
                                  selectedPriorityId == 1
                                      ? const Color.fromARGB(255, 166, 215, 255)
                                      : selectedPriorityId == 2
                                      ? const Color.fromARGB(255, 252, 240, 136)
                                      : const Color.fromARGB(
                                        255,
                                        250,
                                        126,
                                        117,
                                      ),
                              widget: DropdownButton<int>(
                                underline: Container(),
                                value: selectedPriorityId,
                                items:
                                    priorityDataList.map((data) {
                                      return DropdownMenuItem<int>(
                                        value: data['id'],
                                        child: Text(
                                          data['name'],
                                          style: textStyles.sarifProText(
                                            16,
                                            FontWeight.w500,
                                            AppColor.black,
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                icon: const SizedBox(),
                                isExpanded: false,
                                onChanged: (selectedId) {
                                  setState(() {
                                    selectedPriorityId = selectedId!;
                                    // Call function to make API request
                                  });
                                },
                              ),
                              borderColor: AppColor.transparent,
                            ),
                          ),
                        ],
                      ),
                      commonTextField(
                        _contactnumberController,
                        keyboardType: TextInputType.number,
                        labelText: "Contact Number",
                        maxLength: 10,
                      ),
                      commonTextField(_remarksController, labelText: "Remarks"),

                      commonTextField(
                        _actionController,
                        labelText: "Action Taken",
                      ),
                      commonTextField(
                        _splController,
                        labelText: "Software Price",
                      ),
                      CoverTextField(
                        widget: DropdownButton<Map<String, dynamic>>(
                          underline: Container(),
                          value: enqueryDataList.firstWhere(
                            (item) => item['id'] == selectedenqueryId,
                          ),
                          items:
                              enqueryDataList.map((data) {
                                return DropdownMenuItem<Map<String, dynamic>>(
                                  value: data,
                                  child: Text(
                                    data['name'],
                                    style: textStyles.sarifProText(
                                      16,
                                      FontWeight.w500,
                                      AppColor.black,
                                    ),
                                  ),
                                );
                              }).toList(),
                          icon: Icon(Icons.keyboard_arrow_down_outlined),
                          isExpanded: true,
                          onChanged: (selectedId) {
                            setState(() {
                              selectedenqueryId = selectedId!['id'];
                            });
                          },
                        ),
                      ),
                      if (selectedenqueryId == 105)
                        CoverTextField(
                          widget: InkWell(
                            onTap: () async {
                              FocusScope.of(context).requestFocus(FocusNode());
                              await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime.now(),
                                lastDate: DateTime(2100),
                              ).then((selectedDate) {
                                if (selectedDate != null) {
                                  _appointmentDate.text = DateFormat(
                                    'yyyy/MM/dd',
                                  ).format(selectedDate);
                                }
                              });
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(
                                  _appointmentDate.text,
                                  style: textStyles.sarifProText(
                                    16,
                                    FontWeight.w500,
                                    AppColor.black,
                                  ),
                                ),
                                Icon(
                                  Icons.edit_calendar,
                                  color: AppColor.black,
                                ),
                              ],
                            ),
                          ),
                        ),

                      CoverTextField(
                        widget: DropdownButton<int>(
                          underline: Container(),
                          value: selectedDemoId,
                          items:
                              demoDataList.map((data) {
                                return DropdownMenuItem<int>(
                                  value: data['id'],
                                  child: Text(
                                    data['name'],
                                    style: textStyles.sarifProText(
                                      16,
                                      FontWeight.w500,
                                      AppColor.black,
                                    ),
                                  ),
                                );
                              }).toList(),
                          isExpanded: true,
                          onChanged: (selectedId) {
                            setState(() {
                              selectedDemoId = selectedId!;
                              // Call function to make API request
                            });
                          },
                        ),
                      ),

                      isload == true
                          ? Center(child: CircularProgressIndicator())
                          : DefaultButton(
                            hight: 50,
                            width: double.infinity,
                            buttonColor: Color(0xff55B1F7),
                            text: "Save",
                            onTap: () {
                              isload = true;
                              postFollowUp(context).then(
                                (value) => setState(() {
                                  isload = false;
                                }),
                              );
                            },
                          ),
                    ],
                  ),
                  SizedBox(height: Sizes.height * 0.05),
                  Row(
                    children: [
                      Text(
                        "Recent Follow-up Details ",
                        style: textStyles.adlamText(
                          18,
                          FontWeight.w400,
                          AppColor.black,
                        ),
                      ),
                      Expanded(
                        child: Container(height: 1, color: AppColor.black),
                      ),
                    ],
                  ),

                  SizedBox(height: Sizes.height * 0.02),
                  Wrap(
                    children: List.generate(
                      getAllRemarkList != null ? getAllRemarkList.length : 0,
                      (index) {
                        if (getAllRemarkList != null &&
                            getAllRemarkList.isNotEmpty) {
                          return SizedBox(
                            width:
                                (Responsive.isMobile(context))
                                    ? double.infinity
                                    : (Responsive.isTablet(context))
                                    ? Sizes.width * .45
                                    : Sizes.width * 0.3,
                            child: InkWell(
                              onDoubleTap: () {
                                showDialog(
                                  context: context,
                                  builder:
                                      (context) => AlertDialog(
                                        title: Text(
                                          'Delete Follow Up',
                                          style: textStyles.sarifProText(
                                            18,
                                            FontWeight.w600,
                                            AppColor.black,
                                          ),
                                        ),
                                        content: Text(
                                          "Are you sure you want to delete this follow up from the list?",
                                          style: textStyles.sarifProText(
                                            15,
                                            FontWeight.w500,
                                            AppColor.black,
                                          ),
                                        ),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text('No'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              deleteFollowUp(
                                                getAllRemarkList[index]['id'],
                                              );
                                              setState(() {
                                                PrefixData().then((value) {
                                                  setState(() {
                                                    Navigator.pop(context);
                                                  });
                                                });
                                              });
                                            },
                                            child: Text(
                                              'Yes',
                                              style: TextStyle(
                                                color: AppColor.red,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                );
                              },
                              child: Card(
                                child: Column(
                                  children: [
                                    ListTile(
                                      dense: true,
                                      leading: Text(
                                        "Contact Date :",
                                        style: textStyles.sarifProText(
                                          14,
                                          FontWeight.w500,
                                          AppColor.black,
                                        ),
                                      ),
                                      title: Text(
                                        '${getAllRemarkList[index]['contacted_Date']}',
                                        style: textStyles.sarifProText(
                                          14,
                                          FontWeight.w400,
                                          AppColor.black,
                                        ),
                                      ),
                                      trailing: Text(
                                        "${index + 1}",
                                        style: textStyles.sarifProText(
                                          16,
                                          FontWeight.w500,
                                          AppColor.black,
                                        ),
                                      ),
                                    ),
                                    ListTile(
                                      dense: true,
                                      leading: Text(
                                        "Last Remark :",
                                        style: textStyles.sarifProText(
                                          14,
                                          FontWeight.w500,
                                          AppColor.black,
                                        ),
                                      ),
                                      title: Text(
                                        "${getAllRemarkList[index]['remarks']}",
                                        style: textStyles.sarifProText(
                                          14,
                                          FontWeight.w400,
                                          AppColor.black,
                                        ),
                                      ),
                                    ),
                                    ListTile(
                                      dense: true,
                                      leading: Text(
                                        "Action Taken :",
                                        style: textStyles.sarifProText(
                                          14,
                                          FontWeight.w500,
                                          AppColor.black,
                                        ),
                                      ),
                                      title: Text(
                                        "${getAllRemarkList[index]['actionTaken']}",
                                        style: textStyles.sarifProText(
                                          14,
                                          FontWeight.w400,
                                          AppColor.black,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        } else {
                          return Container();
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> deleteFollowUp(int? id) async {
    try {
      await ApiService.postData("CRM/DeleteFollowUp?ID=$id", {'ID': id});
      setState(() {
        // Remove the deleted item from the list
        getAllRemarkList.removeWhere((item) => item['id'] == id);
      });
      showCustomSnackbarSuccess(context, 'Follow-up deleted successfully');
    } catch (error) {
      showCustomSnackbar(context, 'Failed to delete follow-up');
    }
  }

  Future<void> postFollowUp(BuildContext context) async {
    final String apiUrl = "http://lms.muepetro.com/api/CRM/PostFollowUp";
    Map<String, dynamic> followUpData = {
      "Location_Id": int.parse(Preference.getString(PrefKeys.locationId)),
      "Prefix_Name": "online",
      "Ref_No": int.parse(widget.refnom ?? "0"),
      "Customer_Name": _contactController.text.toString(),
      "Contacted_Date": DateFormat('yyyy/MM/dd').format(DateTime.now()),
      "Contacted_Time": "${TimeOfDay.now().hour}:${TimeOfDay.now().minute}",
      "Follow_Type": productId,
      "Appointment_Date": _appointmentDate.text.toString(),
      "Appointment_Time": "${TimeOfDay.now().hour}:${TimeOfDay.now().minute}",
      "Remarks": _remarksController.text.toString(),
      "Remark_Special": _splController.text.toString(),
      "ActionTaken": _actionController.text.toString(),
      "Priority": selectedPriorityId,
      "EnquiryStatus": selectedenqueryId,
      "Reason": "Not Set Yet",
      "VehiclePurchase": "Not Set Yet",
      "ModelTest_Id": selectedDemoId,
      "ModelTest_Date": DateFormat('yyyy/MM/dd').format(DateTime.now()),
      "Remark_ModelTest": "Not Set Yet",
    };
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(followUpData),
      );
      var message = jsonDecode(response.body);
      if (response.statusCode == 200) {
        Navigator.pop(context);
        PrefixData();
        showCustomSnackbarSuccess(context, message['message']);
      } else {
        showCustomSnackbar(context, message['message']);
      }
    } catch (e) {
      showCustomSnackbar(context, "Exception during follow-up post: $e");
    }
  }

  Future<void> PrefixData() async {
    try {
      final response = await http.get(
        Uri.parse(
          'http://lms.muepetro.com/api/CRM/GetFollowUpData?prefix=online&refno=${widget.refnom}&locationid=${Preference.getString(PrefKeys.locationId)}',
        ),
      );

      if (response.statusCode == 200) {
        List<dynamic> dataList = json.decode(response.body);

        if (dataList.isNotEmpty) {
          setState(() {
            getAllRemarkList = dataList;
          });
          Map<String, dynamic> data = dataList[dataList.length - 1];

          setState(() {
            _contactController.text = data['customer_Name'] ?? '';
            _contactnumberController.text = data['mob_No'] ?? '';
            _splController.text = data['remark_Special'] ?? '';
            selectedPriorityId = data['priority'];
            productId = data['enquiryStatus'];
            selectedDemoId =
                data['modelTest_Id'] != 0 ||
                        data['modelTest_Id'] != 1 ||
                        data['modelTest_Id'] != 2
                    ? 0
                    : data['modelTest_Id'];
          });
        } else {
          _contactController.clear();
          _splController.clear();
          _contactnumberController.clear();
          getAllRemarkList.clear();
        }
      } else {
        throw Exception('Failed to load data');
      }
    } catch (error) {
      debugPrint("$error");
    }
  }
}
