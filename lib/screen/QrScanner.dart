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
    controller?.resumeCamera();
  }

  @override
  void initState() {
    super.initState();
    controller?.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    final ui = CustomWidget();
    return Scaffold(
      backgroundColor: linearBg,
      body: Container(
        decoration: BoxDecoration(gradient: global.heroGradient),
        child: SafeArea(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
                child: Container(
                  padding: const EdgeInsets.all(18),
                  decoration: ui.linearPanelDecoration(radius: 24),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        style: IconButton.styleFrom(
                          backgroundColor: global.surfaceL1,
                          side: BorderSide(color: global.borderSubtle),
                        ),
                        icon: Icon(Icons.arrow_back_ios_new_rounded, color: linearTextPrimary, size: 18),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Scanner QR", style: textStyling.linearTitle(20, strong: true)),
                            const SizedBox(height: 4),
                            Text(
                              "Arahkan kamera ke barcode atau QR kendaraan untuk melanjutkan inspeksi.",
                              style: textStyling.linearBody(13, color: linearTextTertiary),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(28),
                    child: _buildQrView(context),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: ui.linearPanelDecoration(radius: 24),
                  child: Column(
                    children: [
                      if (result != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Row(
                            children: [
                              Icon(Icons.check_circle_rounded, color: linearSuccessPill, size: 18),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  result?.code ?? '-',
                                  style: textStyling.linearMono(12, color: linearTextSecondary),
                                ),
                              ),
                            ],
                          ),
                        ),
                      Row(
                        children: <Widget>[
                          if (result != null)
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () async {
                                  setState(() {
                                    result = null;
                                  });
                                  await controller?.resumeCamera();
                                },
                                style: ui.linearGhostButtonStyle(),
                                icon: const Icon(Icons.refresh_rounded),
                                label: const Text("Ulangi"),
                              ),
                            ),
                          if (result != null) const SizedBox(width: 12),
                          Expanded(
                            child: FilledButton.icon(
                              onPressed: () => Navigator.pop(context),
                              style: ui.linearPrimaryButtonStyle(
                                backgroundColor: result != null ? linearSuccess : defRed,
                              ),
                              icon: Icon(result != null ? Icons.check_circle : Icons.close_rounded),
                              label: Text(result != null ? "Lanjutkan" : "Tutup"),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
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
    controller.scannedDataStream.listen((scanData) {
      setState(() => result = scanData);
      controller.pauseCamera();
      qrCode = result != null ? '${result!.code}' : '-';
      if (!mounted) return;
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
