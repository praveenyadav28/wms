import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrGenerator extends StatefulWidget {
  const QrGenerator({super.key});

  @override
  State<QrGenerator> createState() => _QrGeneratorState();
}

class _QrGeneratorState extends State<QrGenerator> {
  GlobalKey globalKey = GlobalKey();
  String qrData = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          children: [
            Container(
              child: QrImageView(
                data: qrData,
                version: QrVersions.auto,
                size: 200,
              ),
            ),
            SizedBox(height: 100),
            // QrGenerator(key: globalKey),
            TextFormField(
              onChanged: (value) {
                setState(() {});
                qrData = value;
              },
            ),
          ],
        ),
      ),
    );
  }
}
