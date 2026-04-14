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

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _animCtrl;
  late final Animation<double> _fadeIn;
  late final Animation<Offset> _slideUp;

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _fadeIn = CurvedAnimation(parent: _animCtrl, curve: Curves.easeOutCubic);
    _slideUp = Tween<Offset>(begin: const Offset(0, 0.08), end: Offset.zero)
        .animate(CurvedAnimation(parent: _animCtrl, curve: Curves.easeOutCubic));
    _animCtrl.forward();

    WidgetsBinding.instance.addPostFrameCallback((_) => _redirect());
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    super.dispose();
  }

  Future<void> _redirect() async {
    await Future<void>.delayed(const Duration(milliseconds: 1100));
    if (!mounted) return;

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
        if (!didPop) Alert.confirmExit(context);
      },
      child: Scaffold(
        backgroundColor: tokens.pageBackground,
        body: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: const Alignment(0, 0.5),
              colors: <Color>[
                tokens.heroEnd.withValues(alpha: context.isDarkMode ? 0.5 : 0.25),
                tokens.pageBackground,
              ],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
              child: FadeTransition(
                opacity: _fadeIn,
                child: SlideTransition(
                  position: _slideUp,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const AppBrandBlocks(),
                      const Spacer(flex: 2),
                      Center(
                        child: Container(
                          width: 92,
                          height: 92,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(28),
                            border: Border.all(
                              color: tokens.brand.withValues(alpha: 0.18),
                              width: 2,
                            ),
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                color: tokens.brand.withValues(alpha: 0.18),
                                blurRadius: 32,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(26),
                            child: Image.asset(
                              'assets/icon.png',
                              width: 92,
                              height: 92,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: Text(
                          'E-Maintenance',
                          style: context.textTheme.displayLarge,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Center(
                        child: Text(
                          'Pusat kerja inspeksi kendaraan.\nLebih rapi, hangat, dan nyaman.',
                          style: context.textTheme.bodyMedium?.copyWith(color: tokens.textMuted),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 18),
                      Center(
                        child: Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          alignment: WrapAlignment.center,
                          children: const <Widget>[
                            AppStatusChip(label: 'Scan serial', icon: Icons.qr_code_scanner_rounded),
                            AppStatusChip(label: 'Checklist', icon: Icons.fact_check_outlined),
                            AppStatusChip(label: 'Laporan', icon: Icons.description_outlined),
                          ],
                        ),
                      ),
                      const Spacer(flex: 3),
                      Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2.2, color: tokens.brand),
                            ),
                            const SizedBox(width: 14),
                            Text(
                              'Menyiapkan workspace…',
                              style: context.textTheme.bodySmall?.copyWith(color: tokens.textMuted),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
