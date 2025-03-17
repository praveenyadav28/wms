import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:wms_mst/components/api.dart';
import 'package:wms_mst/components/prefences.dart';
import 'package:wms_mst/model/group.dart';
import 'package:wms_mst/utils/colors.dart';
import 'package:wms_mst/utils/textstyle.dart';
import 'package:http/http.dart' as http;

class StackedColumnChart extends StatefulWidget {
  StackedColumnChart({
    super.key,
    required this.datefrom,
    required this.dateto,
    required this.staffId,
  });

  String datefrom;
  String dateto;
  String staffId;
  @override
  State<StackedColumnChart> createState() => _StackedColumnChartState();
}

class _StackedColumnChartState extends State<StackedColumnChart> {
  List customerStatusStatus = [];

  List<Map<String, dynamic>> salesmanList = [];
  @override
  void initState() {
    staffData();
    getallcustomerType().then((value) => setState(() {}));
    // TODO: implement initState
    super.initState();
  }

  StyleText textStyles = StyleText();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        width: 80 * double.parse(customerStatusStatus.length.toString()),
        child: SfCartesianChart(
          title: ChartTitle(
            text: "Cutomer Status",
            textStyle: textStyles.abyssinicaSilText(
              18,
              FontWeight.w600,
              AppColor.primary,
            ),
            alignment: ChartAlignment.center,
          ),
          primaryXAxis: const CategoryAxis(
            maximumLabelWidth: 200, // Adjust label width as needed
          ),
          series: <CartesianSeries>[
            StackedColumnSeries<SkillData, String>(
              color: AppColor.blue,
              dataSource: <SkillData>[
                ...List.generate(customerStatusStatus.length, (index) {
                  //Staff
                  int staffId = int.parse(
                    customerStatusStatus[index]['staffId'],
                  );
                  String staffName =
                      salesmanList.isEmpty
                          ? ''
                          : salesmanList.firstWhere(
                            (element) => element['id'] == staffId,
                            orElse: () => {'name': ''},
                          )['name'];
                  return SkillData(
                    staffName,
                    (customerStatusStatus[index]["salesExecutiveDetails"]['saleClose']
                            as List)
                        .length,
                  );
                }),
              ],
              xValueMapper: (SkillData skill, _) => skill.person,
              yValueMapper: (SkillData skill, _) => skill.skill,
              // dataLabelSettings: const DataLabelSettings(isVisible: true),
              width: 0.8,
            ),
            StackedColumnSeries<SkillData, String>(
              color: AppColor.red,
              dataSource: <SkillData>[
                ...List.generate(customerStatusStatus.length, (index) {
                  //Staff
                  int staffId = int.parse(
                    customerStatusStatus[index]['staffId'],
                  );
                  String staffName =
                      salesmanList.isEmpty
                          ? ''
                          : salesmanList.firstWhere(
                            (element) => element['id'] == staffId,
                            orElse: () => {'name': ''},
                          )['name'];
                  return SkillData(
                    staffName,
                    (customerStatusStatus[index]["salesExecutiveDetails"]['lost']
                            as List)
                        .length,
                  );
                }),
              ],
              xValueMapper: (SkillData skill, _) => skill.person,
              yValueMapper: (SkillData skill, _) => skill.skill,
              // dataLabelSettings: const DataLabelSettings(isVisible: true),
              width: 0.8,
            ),
            StackedColumnSeries<SkillData, String>(
              color: AppColor.red,
              dataSource: <SkillData>[
                ...List.generate(customerStatusStatus.length, (index) {
                  //Staff
                  int staffId = int.parse(
                    customerStatusStatus[index]['staffId'],
                  );
                  String staffName =
                      salesmanList.isEmpty
                          ? ''
                          : salesmanList.firstWhere(
                            (element) => element['id'] == staffId,
                            orElse: () => {'name': ''},
                          )['name'];
                  return SkillData(
                    staffName,
                    (customerStatusStatus[index]["salesExecutiveDetails"]['notInterested']
                            as List)
                        .length,
                  );
                }),
              ],
              xValueMapper: (SkillData skill, _) => skill.person,
              yValueMapper: (SkillData skill, _) => skill.skill,
              // dataLabelSettings: const DataLabelSettings(isVisible: true),
              width: 0.8,
            ),
            StackedColumnSeries<SkillData, String>(
              color: Color(0xffFFB95A),
              dataSource: <SkillData>[
                ...List.generate(customerStatusStatus.length, (index) {
                  //Staff
                  int staffId = int.parse(
                    customerStatusStatus[index]['staffId'],
                  );
                  String staffName =
                      salesmanList.isEmpty
                          ? ''
                          : salesmanList.firstWhere(
                            (element) => element['id'] == staffId,
                            orElse: () => {'name': ''},
                          )['name'];
                  return SkillData(
                    staffName,
                    (customerStatusStatus[index]["salesExecutiveDetails"]['process']
                            as List)
                        .length,
                  );
                }),
              ],
              xValueMapper: (SkillData skill, _) => skill.person,
              yValueMapper: (SkillData skill, _) => skill.skill,
              // dataLabelSettings: const DataLabelSettings(isVisible: true),
              width: 0.8,
            ),
          ],
        ),
      ),
    );
  }

  Future getallcustomerType() async {
    var response = await ApiService.fetchData(
      "CRM/CustomerStatusWiseSummary?datefrom=${widget.datefrom}&dateto=${widget.dateto}&locationid=${Preference.getString(PrefKeys.locationId)}&StaffId=${widget.staffId}",
    );
    customerStatusStatus = response["salesExecutiveWiseSummary"];
  }

  Future<void> staffData() async {
    final url = Uri.parse(
      'http://lms.muepetro.com/api/UserController1/GetStaffDetailsLocationwise?locationid=${Preference.getString(PrefKeys.locationId)}',
    );
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<Staffmodel> staffmodelList = staffmodelFromJson(
          response.body,
        );
        salesmanList.clear();
        for (var item in staffmodelList) {
          salesmanList.add({'id': item.id, 'name': item.staffName});
        }
        setState(() {});
      }
    } catch (e) {}
  }
}

class StackedPieChart extends StatefulWidget {
  StackedPieChart({
    super.key,
    required this.datefrom,
    required this.dateto,
    required this.staffId,
  });

  String datefrom;
  String dateto;
  String staffId;

  @override
  State<StackedPieChart> createState() => _StackedPieChartState();
}

class _StackedPieChartState extends State<StackedPieChart> {
  List<Map<String, dynamic>> customerStatusStatus = [];
  List<Map<String, dynamic>> salesmanList = [];
  List<SkillData2> chartData = []; // Store chart data

  @override
  void initState() {
    super.initState();
    _fetchData(); // Combine data fetching into one function
  }

  Future<void> _fetchData() async {
    await Future.wait([
      staffData(),
      getallcustomerType(),
    ]); // Fetch data concurrently

    _buildChartData(); // Build chart data after fetching
  }

  Future getallcustomerType() async {
    var response = await ApiService.fetchData(
      "CRM/CustomerStatusWiseSummary?datefrom=${widget.datefrom}&dateto=${widget.dateto}&locationid=${Preference.getString(PrefKeys.locationId)}&StaffId=${widget.staffId}",
    );
    if (response != null && response["salesExecutiveWiseSummary"] != null) {
      customerStatusStatus = List<Map<String, dynamic>>.from(
        response["salesExecutiveWiseSummary"],
      ); // Safe casting
    } else {
      // Handle the case where the response or data is null
      print("Error: Could not fetch customer status data.");
      return; // Or show an error message, etc.
    }
  }

  Future<void> staffData() async {
    final url = Uri.parse(
      'http://lms.muepetro.com/api/UserController1/GetStaffDetailsLocationwise?locationid=${Preference.getString(PrefKeys.locationId)}',
    );
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<Staffmodel> staffmodelList = staffmodelFromJson(
          response.body,
        );
        salesmanList.clear();
        for (var item in staffmodelList) {
          salesmanList.add({'id': item.id, 'name': item.staffName});
        }
      } else {
        print(
          "Error: Could not fetch staff data. Status code: ${response.statusCode}",
        );
        // Handle error, e.g., show a message to the user
      }
    } catch (e) {
      print("Error fetching staff data: $e");
      // Handle error
    }
  }

  void _buildChartData() {
    chartData.clear(); // Clear previous data
    Map<String, int> aggregatedData = {}; // Aggregate data by category

    if (customerStatusStatus.isNotEmpty) {
      for (int i = 0; i < customerStatusStatus.length; i++) {
        final details =
            customerStatusStatus[i]['salesExecutiveDetails']
                as Map<String, dynamic>?;
        if (details != null) {
          _aggregateList(aggregatedData, details, 'saleClose');
          _aggregateList(aggregatedData, details, 'process');
          _aggregateList(aggregatedData, details, 'notInterested');
        }
      }

      // Create chart data from aggregated data
      aggregatedData.forEach((category, count) {
        chartData.add(SkillData2(category, count)); // No staffIndex needed here
      });
    }

    setState(() {});
  }

  // Helper function to aggregate list counts
  void _aggregateList(
    Map<String, int> aggregatedData,
    Map<String, dynamic> details,
    String key,
  ) {
    final list = details[key] as List?;
    if (list != null) {
      aggregatedData.update(
        key.toLowerCase(), // Use consistent lowercase keys
        (existingCount) => existingCount + list.length,
        ifAbsent: () => list.length,
      );
    }
  }

  final Map<String, Color> colorMap = {
    'saleClose': AppColor.blue,
    'process': Color(0xffFFB95A),
    'notInterested': AppColor.red,
  };

  StyleText textStyles = StyleText();
  @override
  Widget build(BuildContext context) {
    return SfCircularChart(
      title: ChartTitle(
        text: "Cutomer Status",
        textStyle: textStyles.abyssinicaSilText(
          18,
          FontWeight.w600,
          AppColor.primary,
        ),
        alignment: ChartAlignment.center,
      ),
      legend: Legend(isVisible: true),
      series: <PieSeries>[
        PieSeries<SkillData2, String>(
          dataSource: chartData,
          pointColorMapper: (SkillData2 sales, _) => colorMap[sales.person],
          xValueMapper: (SkillData2 skill, _) => skill.person,
          yValueMapper: (SkillData2 skill, _) => skill.skill,
          dataLabelMapper:
              (SkillData2 data, _) =>
                  "${data.person}: ${data.skill}", // No staff index needed
        ),
      ],
    );
  }
}

class SkillData2 {
  final String person;
  final int skill;
  final int? staffIndex;

  SkillData2(this.person, this.skill, {this.staffIndex});
}

class SkillData {
  final String person;
  final int skill;

  SkillData(this.person, this.skill);
}
