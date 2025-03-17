import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:wms_mst/components/api.dart';
import 'package:wms_mst/components/prefences.dart';
import 'package:wms_mst/components/showprospect.dart';
import 'package:wms_mst/components/sidemenu.dart';
import 'package:wms_mst/ui/home/drawer.dart/utils/excel.dart';
import 'package:wms_mst/utils/colors.dart';
import 'package:wms_mst/utils/mediaquery.dart';

class AllProspacts extends StatefulWidget {
  const AllProspacts({super.key});

  @override
  State<AllProspacts> createState() => _AllProspactsState();
}

class _AllProspactsState extends State<AllProspacts> {
  //Staff
  List<Map<String, dynamic>> staffList = [];

  //Enquiry
  List<Map<String, dynamic>> enquiryList = [];

  //Product
  List<Map<String, dynamic>> productList = [];

  //CustomerType
  List<Map<String, dynamic>> customertypeList = [];

  //Source
  List<Map<String, dynamic>> sourceList = [];

  //Occupation
  List<Map<String, dynamic>> occupationList = [];

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

  //All Prospect Data List
  List<dynamic> getProspectList = [];

  @override
  void initState() {
    setState(() {
      occuptionData();
      customerTypeData();
      sourceData();
      staffFunction();
      productFunction();
      getallprospact().then((value) => setState(() {}));
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideMenu(),
      appBar: AppBar(
        centerTitle: true,
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
                      getProspectList,
                      customerType: customertypeList,
                      enquesyType: enquiryList,
                      occupation: occupationList,
                      salesXid: staffList,
                      sourceId: sourceList,
                      prospectStatusList: prospectStatusList,
                    );
                  },
                ),
              ],
            ),
          ),
        ],
        backgroundColor: AppColor.primary,
        title: const Text("All Prospect", overflow: TextOverflow.ellipsis),
      ),
      backgroundColor: AppColor.white,
      body:
          getProspectList.isEmpty
              ? const Center(child: Text("No Prospect Created"))
              : SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  vertical: Sizes.height * 0.02,
                  horizontal: Sizes.width * .02,
                ),
                child: Column(
                  children: [
                    ShowProspect(
                      dateList: getProspectList,
                      priorityDataList: priorityDataList,
                      prospectStatusList: prospectStatusList,
                      staffList: staffList,
                    ),
                  ],
                ),
              ),
    );
  }

  Future<void> generatePDF() async {
    final pdf = pw.Document();

    // Define page size and orientation
    const pageFormat = PdfPageFormat.a4;

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

    // Iterate through the getProspectList and add data to the tableRows
    for (var index = 0; index < getProspectList.length; index++) {
      //Prospect Status
      int enquerystatusId = getProspectList[index]['enquiryStatus'];
      String enquerystatusName =
          enquerystatusId == 1
              ? "In Process"
              : prospectStatusList.firstWhere(
                (element) => element['id'] == enquerystatusId,
                orElse: () => {'name': ''},
              )['name'];

      //Product
      int productId = getProspectList[index]['model_Id'];
      String productName =
          productList.isEmpty
              ? ''
              : productList.firstWhere(
                (element) => element['id'] == productId,
                orElse: () => {'name': ''},
              )['name'];
      final List<String> rowData = [
        '${getProspectList[index]?["ref_No"] ?? 'N/A'}',
        '${getProspectList[index]?["customer_Name"] ?? 'N/A'}',
        productName,
        '${getProspectList[index]?["mob_No"] ?? 'N/A'}',
        '${getProspectList[index]?["ref_Date"] ?? 'N/A'}',
        '${getProspectList[index]?["city"] ?? 'N/A'}',
        enquerystatusName,
      ];

      // Add rowData to tableRows
      tableRows.add(rowData);
    }

    // Add the table to the PDF document
    pdf.addPage(
      pw.Page(
        pageFormat: pageFormat,
        margin: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
                  headerDecoration: const pw.BoxDecoration(
                    color: PdfColors.grey300,
                  ),
                  headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  cellStyle: const pw.TextStyle(),
                  cellPadding: const pw.EdgeInsets.all(5),
                ),
              ],
            ),
      ),
    );

    // Save the PDF to the device
    // ignore: unused_local_variable
    final output = await Printing.layoutPdf(
      onLayout: (format) async => pdf.save(),
    );

    final file = File('example.pdf');
    await file.writeAsBytes(await pdf.save());
  }

  Future<void> sourceData() async {
    await fetchDataByMiscTypeId(29, sourceList);
  }

  Future<void> customerTypeData() async {
    await fetchDataByMiscTypeId(50, customertypeList);
  }

  Future<void> occuptionData() async {
    await fetchDataByMiscTypeId(23, occupationList);
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

  Future<void> getallprospact() async {
    // Fetch prospect data
    var prospectResponse = await ApiService.fetchData(
      "CRM/GetProspect?locationid=${Preference.getString(PrefKeys.locationId)}&StaffId=${Preference.getString(PrefKeys.staffId)}",
    );
    getProspectList = prospectResponse;
  }
}
