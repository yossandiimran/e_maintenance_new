import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:e_maintenance/controllers/app_settings_controller.dart';
import 'package:e_maintenance/controllers/session_controller.dart';
import 'package:e_maintenance/route.dart';
import 'package:e_maintenance/widget/CustomWidget.dart';
import 'package:e_maintenance/widget/TextStyling.dart';

class Profile extends StatelessWidget {
  const Profile({
    super.key,
    required this.onOpenSettings,
    required this.onLogout,
  });

  final VoidCallback onOpenSettings;
  final Future<void> Function() onLogout;

  @override
  Widget build(BuildContext context) {
    final session = context.watch<SessionController>().session;
    final settings = context.watch<AppSettingsController>();
    final tokens = context.tokens;

    if (session == null) {
      return const Center(child: AppLoadingView());
    }

    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
      children: <Widget>[
        const AppBrandBlocks(),
        const SizedBox(height: 10),
        Text('Akun', style: context.textTheme.displayMedium),
        const SizedBox(height: 4),
        Text(
          'Preferensi akun dan aplikasi.',
          style: context.textTheme.bodyMedium?.copyWith(color: tokens.textMuted),
        ),
        const SizedBox(height: 12),
        AppSurfaceCard(
          child: Column(
            children: <Widget>[
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  gradient: tokens.brandGradient,
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Icon(Icons.person_rounded, size: 36, color: tokens.pageBackground),
              ),
              const SizedBox(height: 12),
              Text(session.name, style: context.textTheme.headlineMedium, textAlign: TextAlign.center),
              const SizedBox(height: 6),
              Text(
                session.username,
                style: context.textTheme.bodyMedium?.copyWith(color: tokens.textMuted),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                alignment: WrapAlignment.center,
                children: <Widget>[
                  AppStatusChip(
                    label: 'Lokasi ${session.werks}',
                    icon: Icons.location_on_outlined,
                    color: tokens.accent,
                  ),
                  AppStatusChip(
                    label: settings.themeMode == ThemeMode.dark ? 'Dark mode' : 'Light mode',
                    icon: settings.themeMode == ThemeMode.dark ? Icons.dark_mode_outlined : Icons.light_mode_outlined,
                    color: tokens.brand,
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        AppActionCard(
          icon: Icons.tune_rounded,
          title: 'Pengaturan aplikasi',
          subtitle: 'Atur light/dark mode, host backend, tes koneksi, dan sinkronisasi setting server.',
          onTap: onOpenSettings,
        ),
        const SizedBox(height: 10),
        if (!session.isRestrictedOperator) ...<Widget>[
          AppActionCard(
            icon: Icons.manage_accounts_outlined,
            title: 'Manajemen user',
            subtitle: 'Masuk ke modul pengelolaan akun internal dan hak akses operasional.',
            accentColor: tokens.success,
            onTap: () => Navigator.of(context).push(AppRouter.userManagement()),
          ),
          const SizedBox(height: 10),
        ],
        AppActionCard(
          icon: Icons.logout_rounded,
          title: 'Logout',
          subtitle: 'Akhiri sesi di perangkat ini dan kembali ke halaman login.',
          accentColor: tokens.danger,
          onTap: onLogout,
        ),
      ],
    );
  }
}
