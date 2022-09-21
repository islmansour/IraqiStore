import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hardwarestore/components/user.dart';
import 'package:hardwarestore/models/delivery.dart';
import 'package:hardwarestore/services/api.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class QRScanOrder extends StatefulWidget {
  const QRScanOrder({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _QRScanOrderState();
}

class _QRScanOrderState extends State<QRScanOrder> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Icon(Icons.qr_code_scanner),
        backgroundColor: Colors.red,
      ),
      body: Column(
        children: <Widget>[
          Expanded(flex: 4, child: _buildQrView(context)),
          // Expanded(
          //   flex: 1,
          //   child: FittedBox(
          //     fit: BoxFit.contain,
          //     child: Column(
          //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //       children: <Widget>[
          //         if (result != null)
          //           Text(
          //               'Barcode Type: ${describeEnum(result!.format)}   Data: ${result!.code}')
          //         else
          //           const Text('Scan a code'),
          //         Row(
          //           mainAxisAlignment: MainAxisAlignment.center,
          //           crossAxisAlignment: CrossAxisAlignment.center,
          //           children: <Widget>[
          //             // Container(
          //             //   margin: const EdgeInsets.all(8),
          //             //   child: ElevatedButton(
          //             //       onPressed: () async {
          //             //         await controller?.toggleFlash();
          //             //         setState(() {});
          //             //       },
          //             //       child: FutureBuilder(
          //             //         future: controller?.getFlashStatus(),
          //             //         builder: (context, snapshot) {
          //             //           return Text('Flash: ${snapshot.data}');
          //             //         },
          //             //       )),
          //             // ),
          //           ],
          //         ),
          //       ],
          //     ),
          //   ),
          // )
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 250.0
        : 500.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.red,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
        _updateDelivery(scanData.code!);
        Navigator.pop(context);
      });
    });
  }

  void _updateDelivery(String data) async {
    try {
      List<Delivery>? all = await Repository().getDeliveryByContact(
          Provider.of<GetCurrentUser>(context, listen: false)
              .currentUser!
              .contactId
              .toString());
      String deliveryId = data.substring(0, data.indexOf('#'));
      Delivery _single =
          all!.firstWhere((element) => element.id.toString() == deliveryId);
      _single.qrData = data;
      Repository().upsertDelivery(_single);
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("error scannding code.")),
      );
    }
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
          AppLocalizations.of(context)!.na,
        )),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
