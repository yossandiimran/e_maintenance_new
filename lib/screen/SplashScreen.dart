import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:e_maintenance/controllers/session_controller.dart';
import 'package:e_maintenance/route.dart';
import 'package:e_maintenance/widget/Alert.dart';
import 'package:e_maintenance/widget/CustomWidget.dart';
import 'package:e_maintenance/widget/TextStyling.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _redirect());
  }

  Future<void> _redirect() async {
    await Future<void>.delayed(const Duration(milliseconds: 850));
    if (!mounted) {
      return;
    }

    final sessionController = context.read<SessionController>();
    if (sessionController.isLoggedIn) {
      final session = sessionController.session!;
      if (session.isSessionExpired) {
        await sessionController.logout();
        if (!mounted) return;
        Alert.showErrorSnackBar(context, 'Sesi login sudah kedaluwarsa (6 jam). Silakan login kembali.');
        await AppRouter.replaceWithLogin(context);
        return;
      }
      await AppRouter.replaceWithHome(context);
      return;
    }

    await AppRouter.replaceWithLogin(context);
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) {
          Alert.confirmExit(context);
        }
      },
      child: Scaffold(
        backgroundColor: tokens.pageBackground,
        body: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: <Color>[
                tokens.heroEnd.withValues(alpha: context.isDarkMode ? 0.65 : 0.28),
                tokens.pageBackground,
              ],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const AppBrandBlocks(),
                  const Spacer(),
                  AppSurfaceCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Center(
                          child: Container(
                            width: 88,
                            height: 88,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(26),
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                  color: tokens.brand.withValues(alpha: 0.25),
                                  blurRadius: 24,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(26),
                              child: Image.asset(
                                'assets/icon.png',
                                width: 88,
                                height: 88,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text('E-Maintenance', style: context.textTheme.displayLarge),
                        const SizedBox(height: 6),
                        Text(
                          'Pusat kerja inspeksi kendaraan yang kini lebih rapi, hangat, dan nyaman dipakai di layar Android.',
                          style: context.textTheme.bodyLarge?.copyWith(color: tokens.textSecondary),
                        ),
                        const SizedBox(height: 14),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: const <Widget>[
                            AppStatusChip(label: 'Scan serial', icon: Icons.qr_code_scanner_rounded),
                            AppStatusChip(label: 'Checklist', icon: Icons.fact_check_outlined),
                            AppStatusChip(label: 'Laporan', icon: Icons.description_outlined),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Row(
                    children: <Widget>[
                      const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(strokeWidth: 2.6),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          'Menyiapkan workspace...',
                          style: context.textTheme.bodyMedium?.copyWith(color: tokens.textMuted),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
