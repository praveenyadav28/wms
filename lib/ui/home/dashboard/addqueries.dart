// ignore_for_file: must_be_immutable, use_build_context_synchronously, depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wms_mst/components/api.dart';
import 'package:wms_mst/components/layout.dart';
import 'package:wms_mst/components/prefences.dart';
import 'package:wms_mst/components/showprospect.dart';
import 'package:wms_mst/model/group.dart';
import 'package:wms_mst/utils/button.dart';
import 'package:wms_mst/utils/colors.dart';
import 'package:wms_mst/utils/mediaquery.dart';
import 'package:wms_mst/utils/snackbar.dart';
import 'package:wms_mst/utils/textformfield.dart';
import 'package:wms_mst/utils/textstyle.dart';
import 'package:http/http.dart' as http;

class AddQueries extends StatefulWidget {
  AddQueries({required this.index, super.key});
  int index = 0;
  @override
  State<AddQueries> createState() => _AddQueriesState();
}

class _AddQueriesState extends State<AddQueries>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  //All Prospect Data List
  List<dynamic> getListPunchToday = [];
  List<dynamic> getListFollowToday = [];
  List<dynamic> getListDemoToday = [];
  List<dynamic> getListFollowtomarrow = [];
  List<dynamic> getListScheduled = [];

  //Staff
  List<Map<String, dynamic>> staffList = [];

  //Priority
  final List<Map<String, dynamic>> priorityDataList = [
    {'id': 1, 'name': 'Cold'},
    {'id': 2, 'name': 'Normal'},
    {'id': 3, 'name': 'Hot'},
  ];

  List<Staffmodel> salesmanList = [];
  int? salesmanId;
  @override
  void initState() {
    staffData().then((value) => setState(() {}));
    staffFunction();
    allReportData().then((value) => setState(() {}));
    _tabController = TabController(
      length: 5,
      vsync: this,
      initialIndex: widget.index,
    );
    super.initState();
  }

  StyleText textStyles = StyleText();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.primarydark,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
        centerTitle: true,
        title: const Text('Add Enquiries', overflow: TextOverflow.ellipsis),
        bottom: TabBar(
          isScrollable: true,
          overlayColor: WidgetStatePropertyAll(AppColor.grey),
          controller: _tabController,
          tabs: [
            Tab(
              text: 'Enquery Punched Today',
              icon: Image.network(
                "https://raw.githubusercontent.com/praveenyadav28/wms-images/refs/heads/main/icon/17806297%201.png",
                height: 24,
              ),
            ),
            Tab(
              text: "Tomorrow’s Follow-up",
              icon: Image.network(
                "https://raw.githubusercontent.com/praveenyadav28/wms-images/refs/heads/main/icon/17806420%201.png",
                height: 24,
              ),
            ),
            Tab(
              text: "Today’s Follow-up",
              icon: Image.network(
                "https://raw.githubusercontent.com/praveenyadav28/wms-images/refs/heads/main/icon/17806211%201.png",
                height: 24,
              ),
            ),
            Tab(
              text: 'Weekly Lead',
              icon: Image.network(
                "https://raw.githubusercontent.com/praveenyadav28/wms-images/refs/heads/main/icon/17806386%201.png",
                height: 24,
              ),
            ),
            Tab(
              text: 'Today’s Demo ',
              icon: Image.network(
                "https://raw.githubusercontent.com/praveenyadav28/wms-images/refs/heads/main/icon/17806281%201.png",
                height: 24,
              ),
            ),
          ],
        ),
      ),
      backgroundColor: AppColor.white,
      body: Column(
        children: [
          if (Preference.getString(PrefKeys.userType) == "Staff")
            Container()
          else
            Padding(
              padding: EdgeInsets.only(
                left: Sizes.width * 0.02,
                right: Sizes.width * 0.02,
                top: Sizes.height * 0.02,
              ),
              child: addMasterOutside(
                children: [
                  DoubleDropdown(
                    staffDropdown: CoverTextField(
                      widget: DropdownButton(
                        underline: Container(),
                        isDense: true,
                        hint: Text(
                          'Select Staff',
                          style: textStyles.sarifProText(
                            16,
                            FontWeight.w700,
                            AppColor.black,
                          ),
                        ),
                        isExpanded: true,
                        value: salesmanId,
                        items:
                            salesmanList.map((employee) {
                              return DropdownMenuItem(
                                value: employee.id,
                                child: Text(
                                  employee.staffName,
                                  style: textStyles.abyssinicaSilText(
                                    18,
                                    FontWeight.w700,
                                    AppColor.black,
                                  ),
                                ),
                              );
                            }).toList(),
                        onChanged: (value) {
                          setState(() {
                            salesmanId = value;
                          });
                        },
                      ),
                    ),
                    child: DefaultButton(
                      text: '🔎 Find',
                      buttonColor: AppColor.white,
                      textColor: AppColor.black,
                      hight: 45,
                      width: double.infinity,
                      onTap: () {
                        setState(() {
                          allReportData().then((value) => setState(() {}));
                        });
                      },
                    ),
                  ),
                ],
                context: context,
              ),
            ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                totalenquery(context, getListPunchToday),
                totalenquery(context, getListFollowtomarrow),
                totalenquery(context, getListFollowToday),
                totalenquery(context, getListScheduled),
                totalenquery(context, getListDemoToday),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget totalenquery(BuildContext context, List dateList) {
    //Prospect Status
    final List<Map<String, dynamic>> prospectStatusList = [
      {'id': 105, 'name': 'In Process'},
      {'id': 106, 'name': 'Lost'},
      {'id': 107, 'name': 'Not Intrested'},
      {'id': 108, 'name': 'Sale Closed'},
    ];
    if (dateList.isEmpty) {
      return const Center(child: Text("No prospect found"));
    } else {
      return SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: Sizes.width * 0.02,
          vertical: Sizes.height * 0.02,
        ),
        child: ShowProspect(
          dateList: dateList,
          priorityDataList: priorityDataList,
          prospectStatusList: prospectStatusList,
          staffList: staffList,
        ),
      );
    }
  }

  Future<void> allReportData() async {
    try {
      List response = await ApiService.fetchData(
        "CRM/GetScheduleReportALLDATA?datefrom=${DateFormat('yyyy/MM/dd').format(DateTime.now())}&dateto=${DateFormat('yyyy/MM/dd').format(DateTime.now())}&locationid=${Preference.getString(PrefKeys.locationId)}&StaffId=${Preference.getString(PrefKeys.staffId) != "0" ? Preference.getString(PrefKeys.staffId) : salesmanId ?? 0}",
      );
      getListFollowToday =
          response
              .where((prospect) => prospect['enquiryStatus'] == 105)
              .toList();
      getListDemoToday =
          response
              .where(
                (prospect) =>
                    prospect['enquiryStatus'] == 105 &&
                    prospect['modelTest_Id'] == 1,
              )
              .toList();
      List responsetomaroow = await ApiService.fetchData(
        "CRM/GetScheduleReportALLDATA?datefrom=${DateFormat('yyyy/MM/dd').format(DateTime.now().add(const Duration(days: 1)))}&dateto=${DateFormat('yyyy/MM/dd').format(DateTime.now().add(const Duration(days: 1)))}&locationid=${Preference.getString(PrefKeys.locationId)}&StaffId=${Preference.getString(PrefKeys.staffId) != "0" ? Preference.getString(PrefKeys.staffId) : salesmanId ?? 0}",
      );
      getListFollowtomarrow =
          responsetomaroow
              .where((prospect) => prospect['enquiryStatus'] == 105)
              .toList();
      List responseweekly = await ApiService.fetchData(
        "CRM/GetProspectDateWiseReportALLDATA?datefrom=${DateFormat('yyyy/MM/dd').format(DateTime.now().subtract(const Duration(days: 7)))}&dateto=${DateFormat('yyyy/MM/dd').format(DateTime.now())}&locationid=${Preference.getString(PrefKeys.locationId)}&StaffId=${Preference.getString(PrefKeys.staffId) != "0" ? Preference.getString(PrefKeys.staffId) : salesmanId ?? 0}",
      );
      getListScheduled =
          responseweekly
              .where((prospect) => prospect['enquiryStatus'] == 105)
              .toList();
      final formattedDateFrom = DateFormat('yyyy/MM/dd').format(DateTime.now());
      List responseToday = await ApiService.fetchData(
        "CRM/GetProspectDateWiseReportALLDATA?datefrom=$formattedDateFrom&dateto=$formattedDateFrom&locationid=${Preference.getString(PrefKeys.locationId)}&StaffId=${Preference.getString(PrefKeys.staffId) != "0" ? Preference.getString(PrefKeys.staffId) : salesmanId ?? 0}",
      );
      getListPunchToday =
          responseToday
              .where((prospect) => prospect['enquiryStatus'] == 105)
              .toList();
    } catch (error) {
      showCustomSnackbar(context, '$error');
    }
  }

  Future<void> staffFunction() async {
    try {
      final dynamic response = await ApiService.fetchData(
        'UserController1/GetStaffDetailsLocationwise?locationid=${Preference.getString(PrefKeys.locationId)}',
      );

      if (response is List<dynamic>) {
        staffList = List<Map<String, dynamic>>.from(response);
      } else {}
    } catch (e) {}
  }

  Future<void> staffData() async {
    final url = Uri.parse(
      'http://lms.muepetro.com/api/UserController1/GetStaffDetailsLocationwise?locationid=${Preference.getString(PrefKeys.locationId)}',
    );
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        salesmanList = staffmodelFromJson(response.body);
      }
    } catch (e) {
      print("Error fetching staff data: $e");
      // Handle error
    }
  }
}
