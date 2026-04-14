import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import 'package:e_maintenance/widget/Alert.dart';
import 'package:e_maintenance/widget/CustomWidget.dart';
import 'package:e_maintenance/widget/TextStyling.dart';

class QrScanner extends StatefulWidget {
  const QrScanner({super.key});

  @override
  State<QrScanner> createState() => _QrScannerState();
}

class _QrScannerState extends State<QrScanner> {
  final GlobalKey _qrKey = GlobalKey(debugLabel: 'qr-view');
  QRViewController? _controller;
  Barcode? _result;
  bool _processing = false;

  @override
  void reassemble() {
    super.reassemble();
    _controller?.resumeCamera();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void _handleViewCreated(QRViewController controller) {
    _controller = controller;
    controller.scannedDataStream.listen((scanData) {
      if (!mounted || _processing) {
        return;
      }

      _processing = true;
      setState(() => _result = scanData);
      controller.pauseCamera();
      _showScanPreview(scanData.code?.trim() ?? '');
    });
  }

  Future<void> _showScanPreview(String code) async {
    if (code.isEmpty) {
      _resumeScan();
      return;
    }

    final tokens = context.tokens;
    final confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Hasil scan'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: tokens.surfaceElevated,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: tokens.borderSoft),
                ),
                child: Row(
                  children: <Widget>[
                    Icon(Icons.qr_code_rounded, color: tokens.brand, size: 28),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        code,
                        style: dialogContext.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Serial number di atas akan digunakan untuk mengambil data kendaraan. Pastikan barcode yang discan sudah benar.',
                style: dialogContext.textTheme.bodyMedium?.copyWith(color: tokens.textMuted),
              ),
            ],
          ),
          actions: <Widget>[
            OutlinedButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Scan ulang'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('Lanjutkan'),
            ),
          ],
        );
      },
    );

    if (!mounted) return;

    if (confirmed == true) {
      Navigator.of(context).pop(code);
    } else {
      _resumeScan();
    }
  }

  void _resumeScan() {
    setState(() {
      _result = null;
      _processing = false;
    });
    _controller?.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    return Scaffold(
      backgroundColor: tokens.pageBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 14),
          child: Column(
            children: <Widget>[
              AppSurfaceCard(
                child: Row(
                  children: <Widget>[
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('Scanner QR', style: context.textTheme.titleLarge),
                          const SizedBox(height: 4),
                          Text(
                            'Arahkan kamera ke barcode atau QR kendaraan untuk memulai inspeksi.',
                            style: context.textTheme.bodyMedium?.copyWith(color: tokens.textMuted),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(22),
                  child: QRView(
                    key: _qrKey,
                    onQRViewCreated: _handleViewCreated,
                    overlay: QrScannerOverlayShape(
                      borderColor: tokens.brand,
                      borderRadius: 24,
                      borderLength: 30,
                      borderWidth: 8,
                      cutOutSize: 280,
                    ),
                    onPermissionSet: (controller, granted) {
                      if (!granted) {
                        Alert.showErrorSnackBar(context, 'Izin kamera dibutuhkan untuk melakukan scan.');
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(height: 10),
              AppSurfaceCard(
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        _result?.code ?? 'Menunggu scan barcode...',
                        style: context.textTheme.bodyMedium?.copyWith(color: tokens.textMuted),
                      ),
                    ),
                    const SizedBox(width: 12),
                    OutlinedButton(
                      onPressed: _resumeScan,
                      child: const Text('Ulangi'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
