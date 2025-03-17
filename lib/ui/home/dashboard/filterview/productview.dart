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
import 'package:wms_mst/utils/textformfield.dart';
import 'package:wms_mst/utils/textstyle.dart';
import 'package:http/http.dart' as http;

class ProductView extends StatefulWidget {
  const ProductView({super.key});

  @override
  State<ProductView> createState() => _ProductViewState();
}

class _ProductViewState extends State<ProductView> {
  //Staff
  List<Map<String, dynamic>> staffList = [];

  //Enquery Status
  final List<Map<String, dynamic>> prospectStatusList = [
    {'id': 105, 'name': 'In Process'},
    {'id': 107, 'name': 'Not Intrested'},
    {'id': 108, 'name': 'Sale Closed'},
  ];

  //Priority
  final List<Map<String, dynamic>> priorityDataList = [
    {'id': 1, 'name': 'Cold'},
    {'id': 2, 'name': 'Normal'},
    {'id': 3, 'name': 'Hot'},
  ];

  //enquery
  List<Map<String, dynamic>> enqueryList = [];
  int? enqueryid;

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

  List<Staffmodel> salesmanList = [];
  int? salesmanId;
  //initstate
  @override
  void initState() {
    setState(() {
      staffData().then((value) => setState(() {}));
      enqueryData().then((value) => enqueryid = enqueryList[0]['id']);
      staffFunction().then(
        (value) => getallprospact().then((value) => setState(() {})),
      );
    });

    super.initState();
  }

  StyleText textStyles = StyleText();
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
        title: const Text("Product Type", overflow: TextOverflow.ellipsis),
      ),
      backgroundColor: AppColor.white,
      body:
          enqueryList.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: Sizes.width * 0.02,
                  vertical: Sizes.height * 0.02,
                ),
                child: Column(
                  children: [
                    addMasterOutside(
                      children: [
                        DateRange(
                          datepickar1: datepickar1,
                          datepickar2: datepickar2,
                        ),
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
                          child: CoverTextField(
                            widget: DropdownButton<int>(
                              underline: Container(),
                              value: enqueryid,
                              items:
                                  enqueryList.map((data) {
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
                              icon: const Icon(
                                Icons.keyboard_arrow_down_outlined,
                              ),
                              isExpanded: true,
                              onChanged: (selectedId) {
                                setState(() {
                                  enqueryid = selectedId!;
                                });
                              },
                            ),
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            DefaultButton(
                              hight: 50,
                              width: 150,
                              text: '🔎 Find',
                              buttonColor: AppColor.white,
                              textColor: AppColor.black,
                              onTap: () {
                                getallprospact();
                              },
                            ),
                          ],
                        ),
                      ],
                      context: context,
                    ),
                    SizedBox(height: Sizes.height * .02),
                    ShowProspect(
                      dateList: getProspectListPriority,
                      priorityDataList: priorityDataList,
                      prospectStatusList: prospectStatusList,
                      staffList: staffList,
                    ),
                  ],
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
      "CRM/EnquiryTypeWiseSummary?locationid=${Preference.getString(PrefKeys.locationId)}&StaffId=${Preference.getString(PrefKeys.staffId) != "0" ? Preference.getString(PrefKeys.staffId) : salesmanId ?? 0}&datefrom=$formattedDateFrom&dateto=$formattedDateTo",
    );
    List<dynamic> enqueryList = response['enquiry'];

    // Find the selected customer type from the dropdown
    var selectedenquery = enqueryList.firstWhere(
      (element) => element['enquiryName'] == enqueryid.toString(),
      orElse: () => null,
    );

    // If a matching customer type is found, update getProspectListPriority
    if (selectedenquery != null) {
      setState(() {
        List getProspectList =
            selectedenquery['prospectDetails']
                .where((item) => item['enquiryStatus'] == 105)
                .toList();
        getProspectListPriority = getProspectList;
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

  Future<void> enqueryData() async {
    await fetchDataByMiscTypeId(18, enqueryList);
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
