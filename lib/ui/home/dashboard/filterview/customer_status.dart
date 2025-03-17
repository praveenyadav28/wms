import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wms_mst/components/api.dart';
import 'package:wms_mst/components/decoration.dart';
import 'package:wms_mst/components/layout.dart';
import 'package:wms_mst/components/prefences.dart';
import 'package:wms_mst/components/showprospect.dart';
import 'package:wms_mst/utils/button.dart';
import 'package:wms_mst/utils/colors.dart';
import 'package:wms_mst/utils/images.dart';
import 'package:wms_mst/utils/mediaquery.dart';
import 'package:wms_mst/utils/textformfield.dart';
import 'package:wms_mst/utils/textstyle.dart';

class CustomerStatus extends StatefulWidget {
  const CustomerStatus({super.key});

  @override
  State<CustomerStatus> createState() => _CustomerStatusState();
}

class _CustomerStatusState extends State<CustomerStatus> {
  //Staff
  List<Map<String, dynamic>> staffList = [];
  int? staffid;

  //Enquery Status
  final List<Map<String, dynamic>> prospectStatusList = [
    {'id': 105, 'name': 'In Process'},
    {'id': 107, 'name': 'Not Intrested'},
    {'id': 108, 'name': 'Sale Closed'},
  ];
  int prospectstatusId = 105;

  //Priority
  final List<Map<String, dynamic>> priorityDataList = [
    {'id': 1, 'name': 'Cold'},
    {'id': 2, 'name': 'Normal'},
    {'id': 3, 'name': 'Hot'},
  ];

  //All Prospect Data List
  List<dynamic> getProspectListPriority = [];

  //DateFilter
  TextEditingController datepickar1 = TextEditingController(
    text: DateFormat('yyyy/MM/dd').format(DateTime.now()),
  );
  TextEditingController datepickar2 = TextEditingController(
    text: DateFormat(
      'yyyy/MM/dd',
    ).format(DateTime.now().add(const Duration(days: 7))),
  );

  StyleText textStyles = StyleText();
  //initstate
  @override
  void initState() {
    setState(() {
      staffFunction().then((value) {
        staffid = staffList[0]['id'];
        getallprospact().then((value) => setState(() {}));
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.primary,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
        centerTitle: true,
        title: const Text("Customer Status", overflow: TextOverflow.ellipsis),
      ),
      backgroundColor: AppColor.white,
      body: DecorationContainer(
        url: Images.other1,
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: Sizes.width * 0.02,
            vertical: Sizes.height * 0.02,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: Sizes.width * .76,
                child: addMasterOutside(
                  children: [
                    DateRange(
                      datepickar1: datepickar1,
                      datepickar2: datepickar2,
                    ),

                    DoubleDropdown(
                      staffDropdown: CoverTextField(
                        widget: DropdownButton<int>(
                          underline: Container(),
                          value: staffid,
                          items:
                              staffList.map((data) {
                                return DropdownMenuItem<int>(
                                  value: data['id'],
                                  child: Text(
                                    data['staff_Name'],
                                    style: textStyles.sarifProText(
                                      16,
                                      FontWeight.w500,
                                      AppColor.primarydark,
                                    ),
                                  ),
                                );
                              }).toList(),
                          icon: const Icon(Icons.keyboard_arrow_down_outlined),
                          isExpanded: true,
                          onChanged: (selectedId) {
                            setState(() {
                              staffid = selectedId!;
                            });
                          },
                        ),
                      ),

                      child: CoverTextField(
                        widget: DropdownButton<int>(
                          underline: Container(),
                          value: prospectstatusId,
                          items:
                              prospectStatusList.map((data) {
                                return DropdownMenuItem<int>(
                                  value: data['id'],
                                  child: Text(
                                    data['name'],
                                    style: textStyles.sarifProText(
                                      16,
                                      FontWeight.w500,
                                      AppColor.primarydark,
                                    ),
                                  ),
                                );
                              }).toList(),
                          icon: const Icon(Icons.keyboard_arrow_down_outlined),
                          isExpanded: true,
                          onChanged: (selectedId) {
                            setState(() {
                              prospectstatusId = selectedId!;
                            });
                          },
                        ),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DefaultButton(
                          hight: 50,
                          width: 150,
                          onTap: () {
                            getallprospact();
                          },
                          text: '🔎 Find',
                          buttonColor: AppColor.white,
                          textColor: AppColor.black,
                        ),
                      ],
                    ),
                  ],
                  context: context,
                ),
              ),

              SizedBox(height: Sizes.height * 0.02),
              ShowProspect(
                dateList: getProspectListPriority,
                priorityDataList: priorityDataList,
                prospectStatusList: prospectStatusList,
                staffList: staffList,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future getallprospact() async {
    final formattedDateFrom = DateFormat(
      'yyyy/MM/dd',
    ).format(DateFormat('yyyy/MM/dd').parse(datepickar1.text));
    final formattedDateTo = DateFormat(
      'yyyy/MM/dd',
    ).format(DateFormat('yyyy/MM/dd').parse(datepickar2.text));
    var response = await ApiService.fetchData(
      "CRM/CustomerStatusWiseSummary?datefrom=$formattedDateFrom&dateto=$formattedDateTo&locationid=${Preference.getString(PrefKeys.locationId)}&StaffId=${Preference.getString(PrefKeys.staffId)}",
    );
    List<dynamic> prospectdataList = response['salesExecutiveWiseSummary'];

    // Find the selected customer type from the dropdown
    var selectedstaff =
        Preference.getString(PrefKeys.userType) == "Staff"
            ? prospectdataList.firstWhere(
              (element) =>
                  element['staffId'] == Preference.getString(PrefKeys.staffId),
              orElse: () => null,
            )
            : prospectdataList.firstWhere(
              (element) => element['staffId'] == staffid.toString(),
              orElse: () => null,
            );

    // If a matching customer type is found, update getProspectListPriority
    if (selectedstaff != null) {
      setState(() {
        getProspectListPriority =
            selectedstaff['salesExecutiveDetails'][prospectstatusId == 105
                ? "process"
                : prospectstatusId == 107
                ? "notInterested"
                : "saleClose"];
      });
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
}
