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
import 'package:wms_mst/utils/button.dart';
import 'package:wms_mst/utils/colors.dart';
import 'package:wms_mst/utils/images.dart';
import 'package:wms_mst/utils/mediaquery.dart';
import 'package:wms_mst/utils/textformfield.dart';
import 'package:wms_mst/utils/textstyle.dart';
import 'package:barcode/barcode.dart';

class Quotation extends StatefulWidget {
  const Quotation({super.key});

  @override
  State<Quotation> createState() => _QuotationState();
}

class _QuotationState extends State<Quotation> {
  final TextEditingController _prefixController = TextEditingController();
  final TextEditingController _quotationNoController = TextEditingController();
  final TextEditingController _quoteToController = TextEditingController();
  final TextEditingController _shipToController = TextEditingController();
  final TextEditingController _modeTypeController = TextEditingController();
  final TextEditingController _paymentTermController = TextEditingController();
  final TextEditingController _installationDateController =
      TextEditingController();
  final TextEditingController _softwareIdController = TextEditingController();
  final TextEditingController _softwareNameController = TextEditingController();
  final TextEditingController _qtyController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _specialDiscountController =
      TextEditingController();
  final TextEditingController _discountController = TextEditingController();
  final TextEditingController _netAmtController = TextEditingController();
  final TextEditingController _termsController = TextEditingController();
  TextEditingController invoiceDatePickar = TextEditingController(
    text: DateFormat('dd-MM-yyyy').format(DateTime.now()),
  );
  StyleText textStyles = StyleText();
  bool _isVisible = false;

  void calculateAmounts() {
    double qty = double.tryParse(_qtyController.text) ?? 0;
    double price = double.tryParse(_priceController.text) ?? 0;
    double discount = double.tryParse(_discountController.text) ?? 0;
    double spldiscount = double.tryParse(_specialDiscountController.text) ?? 0;

    double totalAmount = qty * price;
    double netAmount = totalAmount - discount - spldiscount;
    _netAmtController.text = netAmount.toStringAsFixed(2);
  }

  @override
  void initState() {
    // TODO: implement initState
    _termsController.text = """* Above price quoted for one Software only.
* 18 % GST Exclude software amount.
* Above Price are valid for Today.
* Online Training will be provide free of cost.
* After one year from the date of license activation of DMS AMC will be charge only 4000/*.
* This is Online Web base Software As Per your Choice.
* This Amount Will not Refundable after install.""";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.primary,
        centerTitle: true,
        title: Text(
          "Quotation",
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
                            flex: 2,
                            child: commonTextField(
                              _prefixController,
                              labelText: "Prefix",
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            flex: 3,
                            child: commonTextField(
                              _quotationNoController,
                              labelText: "Quotation No",
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
                        _quoteToController,
                        labelText: "Quote To",
                        borderColor: AppColor.colYellow.withValues(alpha: 0.6),
                      ),
                      commonTextField(_shipToController, labelText: "Ship To"),
                      commonTextField(
                        _installationDateController,
                        labelText: "Installation Date",
                      ),
                      commonTextField(
                        _modeTypeController,
                        labelText: "Installation Mode",
                      ),
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
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: commonTextField(
                              _softwareIdController,
                              labelText: "ID",
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            flex: 2,
                            child: commonTextField(
                              _softwareNameController,
                              labelText: "Software Name",
                            ),
                          ),
                        ],
                      ),
                      commonTextField(
                        _paymentTermController,
                        labelText: "Payment Term",
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
                              _specialDiscountController,
                              labelText: "Spl Discount",
                              keyboardType: TextInputType.number,
                              onChanged: (value) => calculateAmounts(),
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
                      CheckboxListTile(
                        title: Text(
                          'Show Text',
                          style: textStyles.sarifProText(
                            18,
                            FontWeight.w500,
                            AppColor.black,
                          ),
                        ),
                        value: _isVisible,
                        onChanged: (bool? newValue) {
                          setState(() {
                            _isVisible = newValue!;
                          });
                        },
                      ),
                    ],
                    context: context,
                  ),
                  SizedBox(height: Sizes.height * .02),
                  CoverTextField(
                    widget: TextFormField(
                      controller: _termsController,
                      style: textStyles.albertsans(
                        15,
                        FontWeight.w500,
                        AppColor.primarydark,
                      ),
                      maxLines: null,
                      decoration: InputDecoration(
                        isDense: true,
                        hintText: "Terms & Conditions",
                        hintStyle: textStyles.albertsans(
                          15,
                          FontWeight.w500,
                          AppColor.black.withValues(alpha: .6),
                        ),
                        border: OutlineInputBorder(borderSide: BorderSide.none),
                      ),
                    ),
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
    final barcodeData =
        "${_prefixController.text.toString()}-${_quotationNoController.text.toString()}";
    final barcode = Barcode.code128();
    final barcodeImage = barcode.toSvg(
      barcodeData,
      drawText: false,
      height: 30,
      width: 100,
    );
    // Define page size and orientation
    const pageFormat = PdfPageFormat.a4;

    // Create a table for item descriptions
    final List<String> headers = [
      'ID',
      'Description                 ',
      'Unit',
      'Unit Price ',
      'Qty',
      'Total',
    ];
    double netAmount = double.parse(_netAmtController.text);
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
                        pw.Text(
                          "MODERN SOFTWARE TECHNOLOGIES PRIVATE LIMITED\n\n",
                          style: pw.TextStyle(
                            fontSize: 13,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.green800,
                          ),
                        ),
                        pw.Row(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Expanded(
                              flex: 3,
                              child: pw.Image(
                                pw.MemoryImage(imageBytes),
                                width: Sizes.width * .15,
                                height: Sizes.height * .1,
                              ),
                            ),
                            pw.Expanded(
                              flex: 5,
                              child: pw.Column(
                                crossAxisAlignment: pw.CrossAxisAlignment.start,
                                children: [
                                  pw.Text(
                                    "The Valueof Digital Word",
                                    style: pw.TextStyle(
                                      fontSize: 13,
                                      fontWeight: pw.FontWeight.bold,
                                      color: PdfColors.black,
                                    ),
                                  ),
                                  pw.Text(
                                    "2nd Floor, Dev Krishnam, Purohit Ka Bass, Geejgarh Vihar Colony, Bais Godam, Jaipur, Rajasthan - 302006\nPhone: +8949486258: +8824587052,\nEmail: info.modernsoftwaretech@gmail.com\nWebsite: modernsoftwaretechnologies.com",
                                    style: pw.TextStyle(
                                      fontSize: 10,
                                      fontWeight: pw.FontWeight.normal,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            pw.Expanded(flex: 6, child: pw.Container()),
                          ],
                        ),
                        pw.Align(
                          alignment: pw.Alignment.centerRight,
                          child: pw.Row(
                            mainAxisAlignment: pw.MainAxisAlignment.end,
                            children: [
                              pw.Text(
                                "QuoteNo. : ${_prefixController.text}-${_quotationNoController.text}  ",
                              ),
                              pw.SvgImage(
                                svg: barcodeImage,
                              ), // Embed the barcode image
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  pw.Row(
                    children: [
                      pw.Expanded(
                        flex: 6,
                        child: pw.Container(
                          height: 1,
                          width: double.infinity,
                          color: PdfColors.black,
                          margin: const pw.EdgeInsets.symmetric(vertical: 14),
                        ),
                      ),
                      pw.Text(
                        '    Quotation    ',
                        style: pw.TextStyle(fontSize: 13),
                        textAlign: pw.TextAlign.center,
                      ),
                      pw.Expanded(
                        flex: 2,
                        child: pw.Container(
                          height: 1,
                          width: double.infinity,
                          color: PdfColors.black,
                          margin: const pw.EdgeInsets.symmetric(vertical: 14),
                        ),
                      ),
                    ],
                  ),
                  pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Expanded(
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text('Quote to'),
                            pw.Container(
                              height: 40,
                              width: Sizes.width * .35,
                              padding: pw.EdgeInsets.all(8),
                              decoration: pw.BoxDecoration(
                                border: pw.Border.all(color: PdfColors.black),
                              ),
                              child: pw.Text(
                                _quoteToController.text,
                                style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      pw.SizedBox(width: Sizes.width * .06),

                      pw.Expanded(
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text('Ship to'),
                            pw.Container(
                              height: 40,
                              padding: pw.EdgeInsets.all(8),
                              width: Sizes.width * .35,
                              decoration: pw.BoxDecoration(
                                border: pw.Border.all(color: PdfColors.black),
                              ),
                              child: pw.Text(
                                _shipToController.text,
                                style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  pw.SizedBox(height: Sizes.height * .02),
                  // Item Description Table
                  pw.Table.fromTextArray(
                    headers: headers,
                    data: [
                      [
                        pw.Container(
                          alignment: pw.Alignment.topCenter,
                          child: pw.Text(
                            _softwareIdController.text,
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          ),
                        ),
                        pw.Container(
                          alignment: pw.Alignment.topCenter,
                          child: pw.Text(
                            _softwareNameController.text,
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          ),
                        ),
                        pw.Container(
                          alignment: pw.Alignment.topCenter,
                          child: pw.Text(
                            'PCS',
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          ),
                        ),

                        pw.Container(
                          alignment: pw.Alignment.topCenter,
                          child: pw.Text(
                            _priceController.text,
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          ),
                        ),
                        pw.Container(
                          alignment: pw.Alignment.topCenter,
                          child: pw.Text(
                            _qtyController.text,
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          ),
                        ),
                        pw.Container(
                          alignment: pw.Alignment.topCenter,
                          child: pw.Text(
                            "${double.parse(_priceController.text.isEmpty ? "0" : _priceController.text) * double.parse(_qtyController.text.isEmpty ? "0" : _qtyController.text)}",

                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
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
                      verticalInside: pw.BorderSide(color: PdfColors.black),
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
                    cellHeight: 40,
                    headerHeight: 30,
                  ),

                  pw.Row(
                    children: [
                      pw.Expanded(
                        child: pw.Text(
                          'Discount  ',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          textAlign: pw.TextAlign.end,
                        ),
                        flex: 14,
                      ),
                      pw.Container(
                        width: 1,
                        height: 30,
                        color: PdfColors.black,
                      ),
                      pw.Expanded(
                        flex: 2,
                        child: pw.Text(
                          _discountController.text.isEmpty
                              ? "0"
                              : _discountController.text,
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          textAlign: pw.TextAlign.center,
                        ),
                      ),
                      pw.Container(
                        width: 1,
                        height: 30,
                        color: PdfColors.black,
                      ),
                    ],
                  ),

                  pw.Row(
                    children: [
                      pw.Expanded(child: pw.Container(), flex: 14),
                      pw.Container(width: 1, height: 1, color: PdfColors.black),
                      pw.Expanded(
                        flex: 2,
                        child: pw.Container(
                          width: double.infinity,
                          height: 1,
                          color: PdfColors.black,
                        ),
                      ),
                    ],
                  ),
                  pw.Row(
                    children: [
                      pw.Expanded(
                        child: pw.Text(
                          'Special Discount  ',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          textAlign: pw.TextAlign.end,
                        ),
                        flex: 14,
                      ),

                      pw.Container(
                        width: 1,
                        height: 30,
                        color: PdfColors.black,
                      ),
                      pw.Expanded(
                        flex: 2,
                        child: pw.Text(
                          _specialDiscountController.text.isEmpty
                              ? "0"
                              : _specialDiscountController.text,
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          textAlign: pw.TextAlign.center,
                        ),
                      ),
                      pw.Container(
                        width: 1,
                        height: 30,
                        color: PdfColors.black,
                      ),
                    ],
                  ),

                  pw.Container(
                    height: 1.2,
                    width: double.infinity,
                    color: PdfColors.black,
                  ),
                  pw.Row(
                    children: [
                      pw.Expanded(
                        child: pw.Text(
                          'Total  ',
                          textAlign: pw.TextAlign.end,
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                        ),
                        flex: 14,
                      ),

                      pw.Container(
                        width: 1,
                        height: 30,
                        color: PdfColors.black,
                      ),
                      pw.Expanded(
                        flex: 2,
                        child: pw.Text(
                          _netAmtController.text,
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          textAlign: pw.TextAlign.center,
                        ),
                      ),
                      pw.Container(
                        width: 1,
                        height: 30,
                        color: PdfColors.black,
                      ),
                    ],
                  ),

                  pw.Container(
                    height: 1.2,
                    width: double.infinity,
                    color: PdfColors.black,
                  ),

                  pw.Padding(
                    padding: const pw.EdgeInsets.all(10),
                    child: pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.start,
                      children: [
                        pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text(
                              'Terms -',
                              style: pw.TextStyle(fontSize: 8),
                            ),
                            pw.SizedBox(height: 6),
                            pw.Text(
                              _termsController.text,
                              style: pw.TextStyle(fontSize: 9),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  pw.Container(
                    height: 1,
                    width: double.infinity,
                    color: PdfColors.black,
                    margin: const pw.EdgeInsets.symmetric(vertical: 15),
                  ),
                  pw.Center(
                    child: pw.Text(
                      "Address: 2nd Floor, Dev Krishnam, Bais Godam, Jaipur\nPhone: +8949486258  Mob: +8824587052  Email: info.modernsoftwaretech@gmail.com  Website: www.modernsoftwaretechnologies.com",
                      style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 8,
                      ),
                      textAlign: pw.TextAlign.center,
                    ),
                  ),
                  pw.SizedBox(height: 20),
                  !_isVisible
                      ? pw.Container()
                      : pw.Align(
                        alignment: pw.Alignment.centerLeft,
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
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
