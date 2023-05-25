// ignore_for_file: file_names, use_key_in_widget_constructors, prefer_typing_uninitialized_variables, no_logic_in_create_state
part of '../header.dart';

class QrScanner extends StatefulWidget {
  final type;
  const QrScanner({var this.type = '-'});

  @override
  State<StatefulWidget> createState() => _QRViewExampleState(type);
}

class _QRViewExampleState extends State<QrScanner> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  final type;
  _QRViewExampleState(this.type);

  @override
  void reassemble() {
    super.reassemble();
    controller!.resumeCamera();
  }

  @override
  void initState() {
    super.initState();
    controller?.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(flex: 5, child: _buildQrView(context)),
          Expanded(
            flex: 1,
            child: Container(
              color: Colors.blueGrey.shade50,
              child: Row(
                children: <Widget>[
                  const Spacer(),
                  if (result != null)
                    Row(
                      children: <Widget>[
                        Container(
                          margin: const EdgeInsets.all(8),
                          child: ElevatedButton(
                            onPressed: () async {
                              setState(() {
                                result = null;
                              });
                              await controller?.resumeCamera();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: defBlue,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                            ),
                            child: Row(children: const [Icon(Icons.code), Text("Ulangi")]),
                          ),
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  if (result != null) const Spacer(),
                  Row(
                    children: <Widget>[
                      // Container(
                      //   margin: const EdgeInsets.all(8),
                      //   child: ElevatedButton(
                      //     onPressed: () async {
                      //       setState(() {
                      //         result = null;
                      //       });
                      //       await controller?.resumeCamera();
                      //     },
                      //     style: ElevatedButton.styleFrom(
                      //       backgroundColor: defaultBlue,
                      //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      //     ),
                      //     child: Row(
                      //       children: const [Icon(Icons.camera), Text("Reset Camera")],
                      //     ),
                      //   ),
                      // ),
                      ElevatedButton(
                        onPressed: () async {
                          // qrVariable = result != null ? '${result!.code}' : '-';
                          // if (type == "qrRakAwl") {
                          //   qrRakAwl = '1000003491';
                          // } else if (type == "qrRakAkh") {
                          //   qrRakAkh = 'P36-1.1';
                          //   // qrRakAkh = 'P36-STORGE';
                          // }
                          // global.alertWarning(context, "Belum Ada Data Yang Di Scan");
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: result != null ? defGreen : defRed,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        ),
                        child: FutureBuilder(
                          future: controller?.getFlashStatus(),
                          builder: (context, snapshot) {
                            return Row(
                              children: [
                                Icon(result != null ? Icons.check_circle : Icons.close),
                                Text(result != null ? "Lanjutkan" : "Belum Melakukan Scan"),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
        borderColor: defRed,
        borderRadius: 10,
        borderLength: 30,
        borderWidth: 10,
        cutOutSize: 300.0,
      ),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) async {
      setState(() => result = scanData);
      controller.pauseCamera();
      qrCode = result != null ? '${result!.code}' : '-';
      Navigator.pop(context, true);
    });
    controller.resumeCamera();
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    if (!p) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('no Permission')));
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
