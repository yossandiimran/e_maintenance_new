import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import 'package:e_maintenance/widget/Alert.dart';
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
      if (!mounted || _processing) return;

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
          icon: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: tokens.brand.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(Icons.qr_code_rounded, color: tokens.brand, size: 24),
          ),
          title: const Text('Hasil scan'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: tokens.surfaceElevated,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: tokens.borderSoft),
                ),
                child: Text(
                  code,
                  style: dialogContext.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                    fontFamily: 'monospace',
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Serial number ini akan digunakan untuk mengambil data kendaraan. Pastikan barcode yang discan sudah benar.',
                style: dialogContext.textTheme.bodySmall?.copyWith(color: tokens.textMuted),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(dialogContext).pop(false),
                    child: const Text('Scan ulang'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: FilledButton(
                    onPressed: () => Navigator.of(dialogContext).pop(true),
                    child: const Text('Lanjutkan'),
                  ),
                ),
              ],
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
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            // ── Header overlay ──
            Container(
              padding: const EdgeInsets.fromLTRB(8, 6, 16, 10),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: <Color>[Colors.black.withValues(alpha: 0.7), Colors.transparent],
                ),
              ),
              child: Row(
                children: <Widget>[
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18, color: Colors.white),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Scanner QR',
                          style: context.textTheme.titleLarge?.copyWith(color: Colors.white),
                        ),
                        Text(
                          'Arahkan kamera ke barcode kendaraan.',
                          style: context.textTheme.bodySmall?.copyWith(color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // ── Camera view ──
            Expanded(
              child: QRView(
                key: _qrKey,
                onQRViewCreated: _handleViewCreated,
                overlay: QrScannerOverlayShape(
                  borderColor: tokens.brand,
                  borderRadius: 24,
                  borderLength: 32,
                  borderWidth: 6,
                  cutOutSize: 260,
                  overlayColor: Colors.black54,
                ),
                onPermissionSet: (controller, granted) {
                  if (!granted) {
                    Alert.showErrorSnackBar(context, 'Izin kamera dibutuhkan untuk melakukan scan.');
                  }
                },
              ),
            ),

            // ── Footer overlay ──
            Container(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: <Color>[Colors.black.withValues(alpha: 0.7), Colors.transparent],
                ),
              ),
              child: Row(
                children: <Widget>[
                  Icon(
                    _result != null ? Icons.qr_code_rounded : Icons.center_focus_weak_rounded,
                    size: 18,
                    color: _result != null ? tokens.brand : Colors.white54,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      _result?.code ?? 'Menunggu scan barcode…',
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: _result != null ? Colors.white : Colors.white54,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    height: 36,
                    child: OutlinedButton(
                      onPressed: _resumeScan,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: const BorderSide(color: Colors.white38),
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                      ),
                      child: const Text('Ulangi'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
