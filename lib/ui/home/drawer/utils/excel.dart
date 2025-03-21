import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:universal_html/html.dart' show AnchorElement;
import 'package:excel/excel.dart';

Future<void> createExcelAllrospect(
  dataList, {
  List<Map<String, dynamic>>? enquesyType,
  List<Map<String, dynamic>>? occupation,
  List<Map<String, dynamic>>? salesXid,
  List<Map<String, dynamic>>? sourceId,
  List<Map<String, dynamic>>? customerType,
  List<Map<String, dynamic>>? prospectStatusList,
}) async {
  var excel = Excel.createExcel();
  var sheet = excel.sheets[excel.getDefaultSheet()];

  // Add headers

  sheet
      ?.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 0))
      .value = TextCellValue('Customer Name');
  sheet
      ?.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: 0))
      .value = TextCellValue('Ref. Date');
  sheet
      ?.cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: 0))
      .value = TextCellValue('Ref Time');
  sheet
      ?.cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: 0))
      .value = TextCellValue('Gender');
  sheet
      ?.cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: 0))
      .value = TextCellValue('Son Off');
  sheet
      ?.cell(CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: 0))
      .value = TextCellValue('Address');
  sheet
      ?.cell(CellIndex.indexByColumnRow(columnIndex: 6, rowIndex: 0))
      .value = TextCellValue('City');
  sheet
      ?.cell(CellIndex.indexByColumnRow(columnIndex: 7, rowIndex: 0))
      .value = TextCellValue('Pin Code');
  sheet
      ?.cell(CellIndex.indexByColumnRow(columnIndex: 8, rowIndex: 0))
      .value = TextCellValue('Phone No.');
  sheet
      ?.cell(CellIndex.indexByColumnRow(columnIndex: 9, rowIndex: 0))
      .value = TextCellValue('Alt. Phone No.');
  sheet
      ?.cell(CellIndex.indexByColumnRow(columnIndex: 10, rowIndex: 0))
      .value = TextCellValue('Email');
  sheet
      ?.cell(CellIndex.indexByColumnRow(columnIndex: 11, rowIndex: 0))
      .value = TextCellValue('Birthday');
  sheet
      ?.cell(CellIndex.indexByColumnRow(columnIndex: 12, rowIndex: 0))
      .value = TextCellValue('Anniversary');
  sheet
      ?.cell(CellIndex.indexByColumnRow(columnIndex: 13, rowIndex: 0))
      .value = TextCellValue('Enquery Type');
  sheet
      ?.cell(CellIndex.indexByColumnRow(columnIndex: 14, rowIndex: 0))
      .value = TextCellValue('Occupation');
  sheet
      ?.cell(CellIndex.indexByColumnRow(columnIndex: 15, rowIndex: 0))
      .value = TextCellValue('Income');
  sheet
      ?.cell(CellIndex.indexByColumnRow(columnIndex: 16, rowIndex: 0))
      .value = TextCellValue('Salesman');
  sheet
      ?.cell(CellIndex.indexByColumnRow(columnIndex: 17, rowIndex: 0))
      .value = TextCellValue('Source');
  sheet
      ?.cell(CellIndex.indexByColumnRow(columnIndex: 18, rowIndex: 0))
      .value = TextCellValue('Scheme');
  sheet
      ?.cell(CellIndex.indexByColumnRow(columnIndex: 19, rowIndex: 0))
      .value = TextCellValue('Customer Type');
  sheet
      ?.cell(CellIndex.indexByColumnRow(columnIndex: 20, rowIndex: 0))
      .value = TextCellValue('Appointment Date');
  sheet
      ?.cell(CellIndex.indexByColumnRow(columnIndex: 21, rowIndex: 0))
      .value = TextCellValue('Appointment Time');
  sheet
      ?.cell(CellIndex.indexByColumnRow(columnIndex: 22, rowIndex: 0))
      .value = TextCellValue('Last Remark');
  sheet
      ?.cell(CellIndex.indexByColumnRow(columnIndex: 23, rowIndex: 0))
      .value = TextCellValue('Special Remark');
  sheet
      ?.cell(CellIndex.indexByColumnRow(columnIndex: 24, rowIndex: 0))
      .value = TextCellValue('Status');

  // Add data rows
  int rowIndex = 1;
  for (var data in dataList) {
    //Staff
    int staffId = data['salesEx_id'];
    String staffName =
        staffId == 0
            ? "Admin"
            : salesXid == null
            ? ''
            : salesXid.firstWhere(
              (element) => element['id'] == staffId,
              orElse: () => {'name': ''},
            )['staff_Name'];

    //Enquiry
    int enquiryId = data['enq_Type'];
    String enquiryType =
        enquesyType == null
            ? ''
            : enquesyType.firstWhere(
              (element) => element['id'] == enquiryId,
              orElse: () => {'name': ''},
            )['name'];

    //Occupation
    int occupationId = data['occupation'];
    String occupationName =
        occupation == null
            ? ''
            : occupation.firstWhere(
              (element) => element['id'] == occupationId,
              orElse: () => {'name': ''},
            )['name'];

    //Source
    int soueceIdGet = data['source_Id'];
    String sourceName =
        sourceId == null
            ? ''
            : sourceId.firstWhere(
              (element) => element['id'] == soueceIdGet,
              orElse: () => {'name': ''},
            )['name'];

    //Prospect Status
    int statusIdGet = data['enquiryStatus'];
    String statusName =
        prospectStatusList == null
            ? 'In Process'
            : prospectStatusList.firstWhere(
              (element) => element['id'] == statusIdGet,
              orElse: () => {'name': ''},
            )['name'];

    //Customer Type
    int customerId = data['c'] != null ? int.parse(data['c']) : 0;
    String customerName =
        customerType == null
            ? ''
            : customerId == 0
            ? ""
            : customerType.firstWhere(
              (element) => element['id'] == customerId,
              orElse: () => {'name': ''},
            )['name'];

    sheet!
        .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: rowIndex))
        .value = TextCellValue(data['customer_Name'].toString());
    sheet
        .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: rowIndex))
        .value = TextCellValue(data['ref_Date'].toString());
    sheet
        .cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: rowIndex))
        .value = TextCellValue(data['ref_Time'].toString());
    sheet
        .cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: rowIndex))
        .value = TextCellValue(
      data['gender_Name'] == "11"
          ? "Male"
          : data['gender_Name'] == "12"
          ? "Female"
          : "Other",
    );

    sheet
        .cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: rowIndex))
        .value = TextCellValue(data['sanOff_Name'].toString());
    sheet
        .cell(CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: rowIndex))
        .value = TextCellValue(data['address_Details'].toString());
    sheet
        .cell(CellIndex.indexByColumnRow(columnIndex: 6, rowIndex: rowIndex))
        .value = TextCellValue(data['city'].toString());
    sheet
        .cell(CellIndex.indexByColumnRow(columnIndex: 7, rowIndex: rowIndex))
        .value = TextCellValue(data['pin_Code'].toString());
    sheet
        .cell(CellIndex.indexByColumnRow(columnIndex: 8, rowIndex: rowIndex))
        .value = TextCellValue(data['mob_No'].toString());
    sheet
        .cell(CellIndex.indexByColumnRow(columnIndex: 9, rowIndex: rowIndex))
        .value = TextCellValue(data['phon_No'].toString());
    sheet
        .cell(CellIndex.indexByColumnRow(columnIndex: 10, rowIndex: rowIndex))
        .value = TextCellValue(data['email_Id'].toString());
    sheet
        .cell(CellIndex.indexByColumnRow(columnIndex: 11, rowIndex: rowIndex))
        .value = TextCellValue(data['birthday_Date'].toString());
    sheet
        .cell(CellIndex.indexByColumnRow(columnIndex: 12, rowIndex: rowIndex))
        .value = TextCellValue(data['anniversary_Date'].toString());

    sheet
        .cell(CellIndex.indexByColumnRow(columnIndex: 13, rowIndex: rowIndex))
        .value = TextCellValue(enquiryType);
    sheet
        .cell(CellIndex.indexByColumnRow(columnIndex: 14, rowIndex: rowIndex))
        .value = TextCellValue(occupationName);
    sheet
        .cell(CellIndex.indexByColumnRow(columnIndex: 15, rowIndex: rowIndex))
        .value = TextCellValue(data['income'].toString());
    sheet
        .cell(CellIndex.indexByColumnRow(columnIndex: 16, rowIndex: rowIndex))
        .value = TextCellValue(staffName);
    sheet
        .cell(CellIndex.indexByColumnRow(columnIndex: 17, rowIndex: rowIndex))
        .value = TextCellValue(sourceName);
    sheet
        .cell(CellIndex.indexByColumnRow(columnIndex: 18, rowIndex: rowIndex))
        .value = TextCellValue(data['scheme'].toString());
    sheet
        .cell(CellIndex.indexByColumnRow(columnIndex: 19, rowIndex: rowIndex))
        .value = TextCellValue(customerName);
    sheet
        .cell(CellIndex.indexByColumnRow(columnIndex: 20, rowIndex: rowIndex))
        .value = TextCellValue(data['appointment_Date'].toString());
    sheet
        .cell(CellIndex.indexByColumnRow(columnIndex: 21, rowIndex: rowIndex))
        .value = TextCellValue(data['appointment_Time'].toString());
    sheet
        .cell(CellIndex.indexByColumnRow(columnIndex: 22, rowIndex: rowIndex))
        .value = TextCellValue(data['last_Remark'].toString());
    sheet
        .cell(CellIndex.indexByColumnRow(columnIndex: 23, rowIndex: rowIndex))
        .value = TextCellValue(data['remark_Special'].toString());
    sheet
        .cell(CellIndex.indexByColumnRow(columnIndex: 24, rowIndex: rowIndex))
        .value = TextCellValue(statusName);
    rowIndex++;
  }

  var bytes = excel.encode();
  if (kIsWeb) {
    AnchorElement(
        href:
            'data:application/octet-stream;charset=utf-16le;base64,${base64.encode(bytes!)}',
      )
      ..setAttribute('download', 'Output.xlsx')
      ..click();
  } else if (Platform.isAndroid) {
    var i = DateTime.now();
    var directory = await getApplicationDocumentsDirectory();

    var file = File("${directory.path}/Output$i.xlsx");
    await file.writeAsBytes(bytes!);

    await OpenFile.open(file.path);
  } else {
    var directory = await getApplicationDocumentsDirectory();

    var file = File("${directory.path}/Output.xlsx");
    await file.writeAsBytes(bytes!);

    await OpenFile.open(file.path);
  }
}
