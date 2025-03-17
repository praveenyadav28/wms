import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart';
import 'package:wms_mst/components/api.dart';
import 'package:wms_mst/components/layout.dart';
import 'package:wms_mst/components/prefences.dart';
import 'package:wms_mst/components/showprospect.dart';
import 'package:wms_mst/components/sidemenu.dart';
import 'package:wms_mst/model/group.dart';
import 'package:wms_mst/ui/home/drawer.dart/utils/excel.dart';
import 'package:wms_mst/utils/button.dart';
import 'package:wms_mst/utils/colors.dart';
import 'package:wms_mst/utils/mediaquery.dart';
import 'package:wms_mst/utils/textformfield.dart';
import 'package:wms_mst/utils/textstyle.dart';
import 'package:http/http.dart' as http;

class ReportScreen extends StatefulWidget {
  const ReportScreen({Key? key}) : super(key: key);

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  List<dynamic> getReportsData = [];

  TextEditingController datepickar1 = TextEditingController(
    text: DateFormat('yyyy/MM/dd').format(DateTime.now()),
  );
  TextEditingController datepickar2 = TextEditingController(
    text: DateFormat('yyyy/MM/dd').format(DateTime.now()),
  );

  //Staff
  List<Map<String, dynamic>> staffList = [];

  //Product
  List<Map<String, dynamic>> productList = [];

  //Priority
  final List<Map<String, dynamic>> priorityDataList = [
    {'id': 1, 'name': 'Cold'},
    {'id': 2, 'name': 'Normal'},
    {'id': 3, 'name': 'Hot'},
  ];

  //Prospect Status
  final List<Map<String, dynamic>> prospectStatusList = [
    {'id': 105, 'name': 'In Process'},
    {'id': 106, 'name': 'Lost'},
    {'id': 107, 'name': 'Not Intrested'},
    {'id': 108, 'name': 'Sale Closed'},
  ];

  List<Staffmodel> salesmanList = [];
  int? salesmanId;

  @override
  void initState() {
    staffData();
    staffFunction();
    productFunction();
    setState(() {});
    super.initState();
  }

  StyleText textStyles = StyleText();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideMenu(),
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Scheduled Report",
          overflow: TextOverflow.ellipsis,
          style: textStyles.abyssinicaSilText(
            20,
            FontWeight.w600,
            AppColor.white,
          ),
        ),
        backgroundColor: AppColor.primary,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.picture_as_pdf, color: AppColor.white),
                  onPressed: () async {
                    generatePDF();
                  },
                ),
                IconButton(
                  icon: Icon(Icons.expand_circle_down, color: AppColor.white),
                  onPressed: () async {
                    createExcelAllrospect(
                      getReportsData,
                      customerType: [],
                      enquesyType: productList,
                      occupation: [],
                      salesXid: staffList,
                      sourceId: [],
                      prospectStatusList: prospectStatusList,
                    );
                  },
                ),
              ],
            ),
          ),
        ],
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
                DateRange(datepickar1: datepickar1, datepickar2: datepickar2),
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
                  child: Expanded(
                    child: DefaultButton(
                      hight: 45,
                      width: double.infinity,
                      text: '🔎 Find',
                      buttonColor: AppColor.white,
                      textColor: AppColor.black,
                      onTap: () {
                        getallprospact(
                          dateFrom: datepickar1.text,
                          dateTo: datepickar2.text,
                        ).then((value) => setState(() {}));
                      },
                    ),
                  ),
                ),
              ],
              context: context,
            ),
            SizedBox(height: Sizes.height * 0.01),
            ShowProspect(
              dateList: getReportsData,
              priorityDataList: priorityDataList,
              prospectStatusList: prospectStatusList,
              staffList: staffList,
            ),
          ],
        ),
      ),
    );
  }

  Future getallprospact({
    required String dateFrom,
    required String dateTo,
  }) async {
    final formattedDateFrom = DateFormat(
      'yyyy/MM/dd',
    ).format(DateFormat('yyyy/MM/dd').parse(dateFrom));
    final formattedDateTo = DateFormat(
      'yyyy/MM/dd',
    ).format(DateFormat('yyyy/MM/dd').parse(dateTo));

    List response = await ApiService.fetchData(
      "CRM/GetScheduleReportALLDATA?datefrom=$formattedDateFrom&dateto=$formattedDateTo&locationid=${Preference.getString(PrefKeys.locationId)}&StaffId=${Preference.getString(PrefKeys.staffId) != "0" ? Preference.getString(PrefKeys.staffId) : salesmanId ?? 0}",
    );
    getReportsData =
        response.where((prospect) => prospect['enquiryStatus'] == 105).toList();
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

  Future<void> productFunction() async {
    await fetchDataByMiscTypeId(18, productList);
  }

  Future<void> generatePDF() async {
    final pdf = pw.Document();

    // Define page size and orientation
    final pageFormat = PdfPageFormat.a4;

    // Define table headers
    final List<String> headers = [
      'Ref. No.',
      'Customer Name',
      'Product',
      'Mobile No.',
      'Ref. Date',
      'City',
      'Status',
    ];

    // Create a list to store table rows
    final List<List<String>> tableRows = [];

    // Iterate through the getReportsData and add data to the tableRows
    for (var index = 0; index < getReportsData.length; index++) {
      //Prospect Status
      int enquerystatusId = getReportsData[index]['enquiryStatus'];
      String enquerystatusName =
          enquerystatusId == 1
              ? "In Process"
              : prospectStatusList.firstWhere(
                (element) => element['id'] == enquerystatusId,
                orElse: () => {'name': ''},
              )['name'];

      //Product
      int productId = getReportsData[index]['model_Id'];
      String productName =
          productList.isEmpty
              ? ''
              : productList.firstWhere(
                (element) => element['id'] == productId,
                orElse: () => {'name': ''},
              )['name'];
      final List<String> rowData = [
        '${getReportsData[index]?["ref_No"] ?? 'N/A'}',
        '${getReportsData[index]?["customer_Name"] ?? 'N/A'}',
        productName,
        '${getReportsData[index]?["mob_No"] ?? 'N/A'}',
        '${getReportsData[index]?["ref_Date"] ?? 'N/A'}',
        '${getReportsData[index]?["city"] ?? 'N/A'}',
        enquerystatusName,
      ];

      // Add rowData to tableRows
      tableRows.add(rowData);
    }

    // Add the table to the PDF document
    pdf.addPage(
      pw.Page(
        pageFormat: pageFormat,
        margin: pw.EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        build:
            (context) => pw.Column(
              children: [
                pw.Text(
                  "All Prospect",
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                ),
                pw.SizedBox(height: 10),
                pw.Table.fromTextArray(
                  headers: headers,
                  data: tableRows,
                  cellAlignment: pw.Alignment.center,
                  border: pw.TableBorder.all(),
                  headerDecoration: pw.BoxDecoration(color: PdfColors.grey300),
                  headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  cellStyle: const pw.TextStyle(),
                  cellPadding: const pw.EdgeInsets.all(5),
                ),
              ],
            ),
      ),
    );

    // // Save the PDF to the device
    // final output = await Printing.layoutPdf(
    //   onLayout: (format) async => pdf.save(),
    // );

    final file = File('example.pdf');
    await file.writeAsBytes(await pdf.save());
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
