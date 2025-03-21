// ignore_for_file: unused_local_variable

import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wms_mst/components/decoration.dart';
import 'package:wms_mst/components/layout.dart';
import 'package:wms_mst/components/responsive.dart';
import 'package:wms_mst/components/sidemenu.dart';
import 'package:wms_mst/ui/home/drawer/utils/convert.dart';
import 'package:wms_mst/utils/button.dart';
import 'package:wms_mst/utils/colors.dart';
import 'package:wms_mst/utils/images.dart';
import 'package:wms_mst/utils/mediaquery.dart';
import 'package:wms_mst/utils/textformfield.dart';
import 'package:wms_mst/utils/textstyle.dart';

class Invoice extends StatefulWidget {
  const Invoice({super.key});

  @override
  State<Invoice> createState() => _InvoiceState();
}

class _InvoiceState extends State<Invoice> {
  final TextEditingController _prefixController = TextEditingController();
  final TextEditingController _invoiceNoController = TextEditingController();
  final TextEditingController _customernameController = TextEditingController();
  final TextEditingController _mobileNoController = TextEditingController();
  final TextEditingController _gstNoController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _softwareNameController = TextEditingController();
  final TextEditingController _qtyController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _gstAmtController = TextEditingController();
  final TextEditingController _discountController = TextEditingController();
  final TextEditingController _netAmtController = TextEditingController();
  TextEditingController invoiceDatePickar = TextEditingController(
    text: DateFormat('dd-MM-yyyy').format(DateTime.now()),
  );
  StyleText textStyles = StyleText();
  final double gstRate = 0.18; // 18% GST

  void calculateAmounts() {
    double qty = double.tryParse(_qtyController.text) ?? 0;
    double price = double.tryParse(_priceController.text) ?? 0;
    double discount = double.tryParse(_discountController.text) ?? 0;

    double totalAmount = qty * price;
    double discountedAmount = totalAmount - discount;
    double gstAmount = discountedAmount * gstRate;
    double netAmount = discountedAmount + gstAmount;

    _gstAmtController.text = gstAmount.toStringAsFixed(2);
    _netAmtController.text = netAmount.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.primary,
        centerTitle: true,
        title: Text(
          "Invoice",
          overflow: TextOverflow.ellipsis,
          style: textStyles.abyssinicaSilText(
            25,
            FontWeight.w600,
            AppColor.white,
          ),
        ),
      ),
      drawer: SideMenu(),
      body: DecorationContainer(
        url: Images.prospectBackground,
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              vertical: Sizes.height * 0.02,
              horizontal:
                  (Responsive.isMobile(context))
                      ? Sizes.width * .03
                      : Sizes.width * 0.15,
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
                        "Personal Details ",
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
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: commonTextField(
                              _prefixController,
                              labelText: "Prefix",
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: commonTextField(
                              _invoiceNoController,
                              labelText: "Invoice No",
                            ),
                          ),
                        ],
                      ),

                      CoverTextField(
                        widget: InkWell(
                          onTap: () async {
                            FocusScope.of(context).requestFocus(FocusNode());
                            await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate: DateTime(2200),
                            ).then((selectedDate) {
                              if (selectedDate != null) {
                                invoiceDatePickar.text = DateFormat(
                                  'yyyy/MM/dd',
                                ).format(selectedDate);
                              }
                            });
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                invoiceDatePickar.text,
                                style: textStyles.sarifProText(
                                  16,
                                  FontWeight.w500,
                                  AppColor.primarydark,
                                ),
                              ),
                              Icon(
                                Icons.edit_calendar,
                                color: AppColor.primarydark,
                              ),
                            ],
                          ),
                        ),
                      ),

                      commonTextField(
                        _customernameController,
                        labelText: "Customer Name",
                        borderColor: AppColor.colYellow.withValues(alpha: 0.6),
                      ),
                      commonTextField(
                        _mobileNoController,
                        labelText: "Mobile No.",
                        keyboardType: TextInputType.number,
                        maxLength: 10,
                      ),
                      commonTextField(_gstNoController, labelText: "GSTIN No"),
                      commonTextField(_stateController, labelText: "State"),
                    ],
                    context: context,
                  ),
                  SizedBox(height: Sizes.height * .05),

                  Row(
                    children: [
                      Text(
                        "Software Details ",
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
                    children: [
                      commonTextField(
                        _softwareNameController,
                        labelText: "Software Name",
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: commonTextField(
                              _qtyController,
                              labelText: "Qty",
                              onChanged: (value) => calculateAmounts(),
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: commonTextField(
                              _priceController,
                              labelText: "Price",
                              onChanged: (value) => calculateAmounts(),
                            ),
                          ),
                        ],
                      ),

                      Row(
                        children: [
                          Expanded(
                            child: commonTextField(
                              _discountController,
                              labelText: "Discount",
                              keyboardType: TextInputType.number,
                              onChanged: (value) => calculateAmounts(),
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: commonTextField(
                              _gstAmtController,
                              readOnly: true,
                              labelText: "GST Amt",
                              keyboardType: TextInputType.number,
                              borderColor: AppColor.red.withValues(alpha: .7),
                            ),
                          ),
                        ],
                      ),
                      commonTextField(
                        _netAmtController,
                        readOnly: true,
                        labelText: "Net Amount",
                        borderColor: AppColor.red.withValues(alpha: .7),
                      ),
                    ],
                    context: context,
                  ),
                  SizedBox(height: Sizes.height * .02),
                  DefaultButton(
                    text: "Save",
                    hight: 50,
                    width: 170,
                    buttonColor: Color(0xff55B1F7),
                    onTap: () {
                      generateInvoicePDF();
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> generateInvoicePDF() async {
    Future<Uint8List> loadImage() async {
      final ByteData data = await rootBundle.load('assets/Modern_logoPNG.png');
      return data.buffer.asUint8List();
    }

    Uint8List imageBytes = await loadImage();

    final pdf = pw.Document();
    // Define page size and orientation
    const pageFormat = PdfPageFormat.a4;

    // Create a table for item descriptions
    final List<String> headers = [
      'S.N.',
      'ITEM DESCRIPTIONS',
      'HSN',
      'Qty',
      'Price',
      'GST Rate',
      'GST Amount',
      'Amount',
    ];
    double netAmount = double.parse(_netAmtController.text);
    int netAmountInt = netAmount.toInt();
    String amountInWords = NumberToWords.convert(netAmountInt);
    pdf.addPage(
      pw.Page(
        pageFormat: pageFormat,
        margin: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        build:
            (context) => pw.Container(
              decoration: pw.BoxDecoration(color: PdfColors.white),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.center,
                children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 10,
                    ),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.center,
                      children: [
                        pw.Row(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Column(
                              children: [
                                pw.Image(
                                  pw.MemoryImage(imageBytes),
                                  width: Sizes.width * .25,
                                  height: Sizes.height * .15,
                                ),
                                pw.SizedBox(height: 8),
                                pw.Text(
                                  "GSTIN:08AANCM6324R1ZN",
                                  style: pw.TextStyle(fontSize: 7),
                                ),
                              ],
                            ),
                            pw.Column(
                              children: [
                                pw.Text(
                                  "MODERN SOFTWARE TECHNOLOGIES PRIVATE LIMITED\n\n",
                                  style: pw.TextStyle(
                                    fontSize: 13,
                                    fontWeight: pw.FontWeight.bold,
                                    color: PdfColors.green800,
                                  ),
                                ),
                                pw.Text(
                                  "The Valueof Digital Word\n\n",
                                  style: pw.TextStyle(
                                    fontSize: 11,
                                    fontWeight: pw.FontWeight.bold,
                                    color: PdfColors.green,
                                  ),
                                ),
                                pw.Text(
                                  "138-A DeviNagar\nNew Sanaganeer Road, Jaipur, Rajasthan - 302019\nPhone: +8949486258: +8824587052,\nEmail: info.modernsoftwaretech@gmail.com\nWebsite: modernsoftwaretechnologies.com",
                                  style: pw.TextStyle(
                                    fontSize: 9,
                                    fontWeight: pw.FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  pw.Container(
                    height: 2,
                    width: double.infinity,
                    color: PdfColors.green800,
                    margin: const pw.EdgeInsets.only(bottom: 4),
                  ),
                  pw.Text(
                    'TAX INVOICE',
                    style: pw.TextStyle(fontSize: 11),
                    textAlign: pw.TextAlign.center,
                  ),
                  pw.Container(
                    width: double.infinity,
                    margin: const pw.EdgeInsets.only(top: 4),
                    padding: pw.EdgeInsets.symmetric(vertical: 5),
                    decoration: pw.BoxDecoration(
                      color: PdfColors.white,
                      border: pw.Border.all(color: PdfColors.black),
                    ),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.center,
                      children: [
                        pw.Padding(
                          padding: const pw.EdgeInsets.symmetric(
                            horizontal: 10,
                          ),
                          child: pw.Row(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            mainAxisAlignment:
                                pw.MainAxisAlignment.spaceBetween,
                            children: [
                              pw.Expanded(
                                child: pw.Row(
                                  crossAxisAlignment:
                                      pw.CrossAxisAlignment.start,
                                  children: [
                                    pw.Column(
                                      crossAxisAlignment:
                                          pw.CrossAxisAlignment.start,
                                      children: [
                                        pw.Text(
                                          'Party Details:',
                                          style: pw.TextStyle(
                                            fontSize: 8,
                                            fontWeight: pw.FontWeight.bold,
                                            fontStyle: pw.FontStyle.italic,
                                          ),
                                        ),
                                        pw.SizedBox(height: 5),
                                        pw.Text('NAME'),
                                        pw.SizedBox(height: 5),
                                        pw.Text('ADDRESS'),
                                        pw.SizedBox(height: 5),
                                        pw.Text('PHONE'),
                                        pw.SizedBox(height: 5),
                                        pw.Text('GSTIN No.'),
                                        pw.SizedBox(height: 10),
                                      ],
                                    ),
                                    pw.Column(
                                      crossAxisAlignment:
                                          pw.CrossAxisAlignment.start,
                                      children: [
                                        pw.Text(
                                          'Details',
                                          style: pw.TextStyle(
                                            fontSize: 8,
                                            color: PdfColors.white,
                                            fontWeight: pw.FontWeight.bold,
                                          ),
                                        ),
                                        pw.SizedBox(height: 5),
                                        pw.Text(
                                          ':  ${_customernameController.text}',
                                        ),
                                        pw.SizedBox(height: 5),
                                        pw.Text(':  ${_stateController.text}'),
                                        pw.SizedBox(height: 5),
                                        pw.Text(
                                          ':  ${_mobileNoController.text}',
                                        ),
                                        pw.SizedBox(height: 5),
                                        pw.Text(':  ${_gstNoController.text}'),
                                        pw.SizedBox(height: 10),
                                      ],
                                    ),
                                  ],
                                ),
                              ),

                              pw.Expanded(
                                child: pw.Row(
                                  crossAxisAlignment:
                                      pw.CrossAxisAlignment.start,
                                  children: [
                                    pw.Column(
                                      crossAxisAlignment:
                                          pw.CrossAxisAlignment.start,
                                      children: [
                                        pw.SizedBox(height: 5),
                                        pw.Text('Invoice No.'),
                                        pw.SizedBox(height: 5),
                                        pw.Text('Date & Time'),
                                      ],
                                    ),
                                    pw.Column(
                                      crossAxisAlignment:
                                          pw.CrossAxisAlignment.start,
                                      children: [
                                        pw.SizedBox(height: 5),
                                        pw.Text(
                                          ':  ${_prefixController.text}-${_invoiceNoController.text}',
                                        ),
                                        pw.SizedBox(height: 5),
                                        pw.Text(':  ${invoiceDatePickar.text}'),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Item Description Table
                        pw.Table.fromTextArray(
                          headers: headers,
                          data: [
                            [
                              pw.Container(
                                alignment: pw.Alignment.topCenter,
                                child: pw.Text('1'),
                              ),
                              pw.Container(
                                alignment: pw.Alignment.topCenter,
                                child: pw.Text(_softwareNameController.text),
                              ),
                              pw.Container(
                                alignment: pw.Alignment.topCenter,
                                child: pw.Text('998314'),
                              ),
                              pw.Container(
                                alignment: pw.Alignment.topCenter,
                                child: pw.Text(_qtyController.text),
                              ),
                              pw.Container(
                                alignment: pw.Alignment.topCenter,
                                child: pw.Text(_priceController.text),
                              ),
                              pw.Container(
                                alignment: pw.Alignment.topCenter,
                                child: pw.Text('18%'),
                              ),
                              pw.Container(
                                alignment: pw.Alignment.topCenter,
                                child: pw.Text(_gstAmtController.text),
                              ),
                              pw.Container(
                                alignment: pw.Alignment.topCenter,
                                child: pw.Text(
                                  "${double.parse(_priceController.text.isEmpty ? "0" : _priceController.text) * double.parse(_qtyController.text.isEmpty ? "0" : _qtyController.text)}",
                                ),
                              ),
                            ],
                          ],
                          cellAlignment: pw.Alignment.center,
                          border: const pw.TableBorder(
                            top: pw.BorderSide(color: PdfColors.black),
                            left: pw.BorderSide(color: PdfColors.black),
                            right: pw.BorderSide(color: PdfColors.black),
                            bottom: pw.BorderSide(color: PdfColors.black),
                            verticalInside: pw.BorderSide(
                              color: PdfColors.black,
                            ),
                          ),
                          headerDecoration: const pw.BoxDecoration(
                            color: PdfColors.grey200,
                          ),
                          headerStyle: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                            fontSize: 8,
                          ),
                          cellStyle: const pw.TextStyle(fontSize: 7),
                          cellPadding: const pw.EdgeInsets.all(5),
                          cellHeight: 100,
                          headerHeight: 30,
                        ),

                        pw.Row(
                          children: [
                            pw.Expanded(
                              child: pw.Text(
                                "Other Amount : 0.00",
                                textAlign: pw.TextAlign.center,
                              ),
                              flex: 3,
                            ),
                            pw.Expanded(
                              child: pw.Text(
                                "Total QTY : ${_qtyController.text}",
                                textAlign: pw.TextAlign.center,
                              ),
                              flex: 3,
                            ),
                            pw.Container(
                              width: 1,
                              height: 20,
                              color: PdfColors.black,
                              margin: const pw.EdgeInsets.symmetric(
                                horizontal: 4,
                              ),
                            ),
                            pw.Expanded(
                              flex: 2,
                              child: pw.Text(
                                'Taxable Amount:',
                                textAlign: pw.TextAlign.center,
                              ),
                            ),
                            pw.Container(
                              width: 1,
                              height: 20,
                              color: PdfColors.black,
                              margin: const pw.EdgeInsets.symmetric(
                                horizontal: 4,
                              ),
                            ),
                            pw.Expanded(
                              flex: 2,
                              child: pw.Text(
                                "${double.parse(_priceController.text.isEmpty ? "0" : _priceController.text) * double.parse(_qtyController.text.isEmpty ? "0" : _qtyController.text)}",
                                textAlign: pw.TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                        pw.Container(
                          height: 1,
                          width: double.infinity,
                          color: PdfColors.black,
                        ),

                        pw.Row(
                          children: [
                            pw.Expanded(
                              child: pw.RichText(
                                text: pw.TextSpan(
                                  children: [
                                    pw.TextSpan(
                                      text: "   Amount in Words: ",
                                      style: pw.TextStyle(
                                        fontSize: 10,
                                        fontWeight: pw.FontWeight.bold,
                                      ),
                                    ),
                                    pw.TextSpan(
                                      text: amountInWords,
                                      style: pw.TextStyle(fontSize: 10),
                                    ),
                                  ],
                                ),
                                textAlign: pw.TextAlign.left,
                              ),
                              flex: 6,
                            ),
                            pw.Container(
                              width: 1,
                              height: 60,
                              color: PdfColors.black,
                              margin: const pw.EdgeInsets.symmetric(
                                horizontal: 4,
                              ),
                            ),
                            pw.Expanded(
                              flex: 2,
                              child: pw.Column(
                                crossAxisAlignment:
                                    pw.CrossAxisAlignment.center,
                                children: [
                                  pw.Text('IGST Amount'),

                                  pw.SizedBox(height: 5),
                                  pw.Text('Discount'),
                                ],
                              ),
                            ),
                            pw.Container(
                              width: 1,
                              height: 60,
                              color: PdfColors.black,
                              margin: const pw.EdgeInsets.symmetric(
                                horizontal: 4,
                              ),
                            ),
                            pw.Expanded(
                              flex: 2,
                              child: pw.Column(
                                crossAxisAlignment:
                                    pw.CrossAxisAlignment.center,
                                children: [
                                  pw.Text(_gstAmtController.text),
                                  pw.SizedBox(height: 5),
                                  pw.Text(
                                    _discountController.text.isEmpty
                                        ? "0.00"
                                        : _discountController.text,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        pw.Container(
                          height: 1,
                          width: double.infinity,
                          color: PdfColors.black,
                        ),

                        pw.Row(
                          children: [
                            pw.Expanded(child: pw.Text("  Remark : "), flex: 6),
                            pw.Container(
                              width: 1,
                              height: 15,
                              color: PdfColors.black,
                              margin: const pw.EdgeInsets.symmetric(
                                horizontal: 4,
                              ),
                            ),
                            pw.Expanded(
                              flex: 2,
                              child: pw.Text(
                                'Net Amount',
                                style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold,
                                ),
                                textAlign: pw.TextAlign.center,
                              ),
                            ),
                            pw.Container(
                              width: 1,
                              height: 15,
                              color: PdfColors.black,
                              margin: const pw.EdgeInsets.symmetric(
                                horizontal: 4,
                              ),
                            ),
                            pw.Expanded(
                              flex: 2,
                              child: pw.Text(
                                _netAmtController.text,
                                style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold,
                                ),
                                textAlign: pw.TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                        pw.Container(
                          height: 1,
                          width: double.infinity,
                          color: PdfColors.black,
                        ),

                        pw.Padding(
                          padding: const pw.EdgeInsets.all(10),
                          child: pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Text(
                                'Terms and Conditions:',
                                style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold,
                                ),
                              ),
                              pw.Text(
                                '    E.&O.E.',
                                style: pw.TextStyle(fontSize: 9),
                              ),
                              pw.Text(
                                '1. Payment by Cheque/DD/Pay Order in favour of Modern Software Technologies Pvt Ltd, Jaipur.',
                                style: pw.TextStyle(fontSize: 9),
                              ),
                              pw.Text(
                                '2. Invoice Valid On Only Full Realization Of Payments',
                                style: pw.TextStyle(fontSize: 9),
                              ),
                              pw.Text(
                                '3. Subject To Jaipur Jurisdiction.',
                                style: pw.TextStyle(fontSize: 9),
                              ),

                              pw.SizedBox(height: 30),
                              pw.Row(
                                mainAxisAlignment:
                                    pw.MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: pw.CrossAxisAlignment.start,
                                children: [
                                  pw.Column(
                                    crossAxisAlignment:
                                        pw.CrossAxisAlignment.start,
                                    children: [
                                      pw.Text(
                                        'Account Details:',
                                        style: pw.TextStyle(
                                          fontWeight: pw.FontWeight.bold,
                                        ),
                                      ),
                                      pw.Text(
                                        '  A/C.NO.-250207202029',
                                        style: pw.TextStyle(
                                          fontSize: 9,
                                          fontWeight: pw.FontWeight.bold,
                                        ),
                                      ),
                                      pw.Text(
                                        '  NAME - MODERN SOFTWARE TECHNOLOGIES PRIVATE LIMITED.',
                                        style: pw.TextStyle(
                                          fontSize: 9,
                                          fontWeight: pw.FontWeight.bold,
                                        ),
                                      ),
                                      pw.Text(
                                        '  IFSC CODE - INDB0001491BRANCH-MANSAROVAR,JAIPUR BANK',
                                        style: pw.TextStyle(
                                          fontSize: 9,
                                          fontWeight: pw.FontWeight.bold,
                                        ),
                                      ),
                                      pw.Text(
                                        '  NAME - INDUSIND BANK LIMITED',
                                        style: pw.TextStyle(
                                          fontSize: 9,
                                          fontWeight: pw.FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  pw.Text(
                                    'For MODERN SOFTWARE TECHNOLOHIES PRIVATE LIMITED',
                                    style: pw.TextStyle(
                                      fontWeight: pw.FontWeight.bold,
                                      fontSize: 8,
                                    ),
                                  ),
                                ],
                              ),
                              pw.Row(
                                mainAxisAlignment:
                                    pw.MainAxisAlignment.spaceAround,
                                children: [
                                  pw.Text(''),
                                  pw.Text(''),
                                  pw.Text(
                                    'Authorised Signature',
                                    style: pw.TextStyle(fontSize: 8),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  pw.Container(
                    height: 2,
                    width: double.infinity,
                    color: PdfColors.green800,
                    margin: const pw.EdgeInsets.only(top: 20),
                  ),
                  pw.Center(
                    child: pw.Text(
                      "Address:138-A, Devi Nagar,New Sanganeer Road, Jaipur, Rajasthan\nPhone: +8949486258  Mob: +8824587052  Email: info.modernsoftwaretech@gmail.com  Website: www.modernsoftwaretechnologies.com",
                      style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 8,
                      ),
                      textAlign: pw.TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
      ),
    );

    // Save the PDF to the device
    final output = await Printing.layoutPdf(
      onLayout: (format) async => pdf.save(),
    );

    final file = File('invoice.pdf');
    await file.writeAsBytes(await pdf.save());
  }
}
