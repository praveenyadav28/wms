import 'package:flutter/material.dart';
import 'package:wms_mst/components/api.dart';
import 'package:wms_mst/components/layout.dart';
import 'package:wms_mst/components/prefences.dart';
import 'package:wms_mst/components/showprospect.dart';
import 'package:wms_mst/utils/colors.dart';
import 'package:wms_mst/utils/mediaquery.dart';
import 'package:wms_mst/utils/textformfield.dart';

class SearchProspect extends StatefulWidget {
  const SearchProspect({super.key});

  @override
  State<SearchProspect> createState() => _SearchProspectState();
}

class _SearchProspectState extends State<SearchProspect> {
  final TextEditingController _mobileController = TextEditingController();

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

  //All Prospect Data List
  List<dynamic> getProspectList = [];

  //All Prospect Data List
  List filteredList = [];

  //initstat
  @override
  void initState() {
    setState(() {
      staffFunction().then(
        (value) => getallprospact().then(
          (value) => setState(() {
            filteredList = getProspectList;
          }),
        ),
      );
    });

    super.initState();
  }

  void filterList(String searchText) {
    setState(() {
      filteredList =
          getProspectList
              .where(
                (prospect) =>
                    prospect['customer_Name'].toLowerCase().contains(
                      searchText.toLowerCase(),
                    ) ||
                    prospect['mob_No'].toLowerCase().contains(
                      searchText.toLowerCase(),
                    ),
              )
              .toList();
    });
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
        title: const Text("Search Prospect", overflow: TextOverflow.ellipsis),
      ),
      backgroundColor: AppColor.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: Sizes.width * 0.02,
          vertical: Sizes.height * 0.02,
        ),
        child: Column(
          children: [
            addMasterOutside(
              children: [
                Column(
                  children: [
                    commonTextField(
                      _mobileController,
                      onChanged: (value) => filterList(value),
                      labelText: 'Mobile No. / Customer Name',
                      prefixIcon: Icon(
                        Icons.search,
                        size: 24,
                        color: AppColor.black,
                      ),
                    ),
                  ],
                ),
              ],
              context: context,
            ),
            SizedBox(height: Sizes.height * 0.02),
            ShowProspect(
              dateList: filteredList,
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
    List response = await ApiService.fetchData(
      "CRM/GetProspect?locationid=${Preference.getString(PrefKeys.locationId)}&StaffId=${Preference.getString(PrefKeys.staffId)}",
    );
    getProspectList =
        response
            .where(
              (prospect) =>
                  prospect['enquiryStatus'] == 105 ||
                  prospect['enquiryStatus'] == 106 ||
                  prospect['enquiryStatus'] == 107 ||
                  prospect['enquiryStatus'] == 108,
            )
            .toList();
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
