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

    final initial = session.name.isNotEmpty ? session.name[0].toUpperCase() : '?';

    return ListView(
      physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      padding: const EdgeInsets.fromLTRB(18, 10, 18, 100),
      children: <Widget>[
        const AppBrandBlocks(),
        const SizedBox(height: 12),
        Text('Akun', style: context.textTheme.displayMedium),
        const SizedBox(height: 3),
        Text(
          'Preferensi dan info profil.',
          style: context.textTheme.bodySmall?.copyWith(color: tokens.textMuted),
        ),
        const SizedBox(height: 16),

        // ── Profile card ──
        AppSurfaceCard(
          child: Column(
            children: <Widget>[
              // Avatar
              Container(
                width: 68,
                height: 68,
                decoration: BoxDecoration(
                  gradient: tokens.brandGradient,
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: tokens.brand.withValues(alpha: 0.2),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    initial,
                    style: context.textTheme.displayMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(session.name, style: context.textTheme.headlineMedium, textAlign: TextAlign.center),
              const SizedBox(height: 3),
              Text(
                '@${session.username}',
                style: context.textTheme.bodySmall?.copyWith(color: tokens.textMuted),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                alignment: WrapAlignment.center,
                children: <Widget>[
                  AppStatusChip(
                    label: session.werks,
                    icon: Icons.location_on_outlined,
                    color: tokens.accent,
                  ),
                  AppStatusChip(
                    label: settings.themeMode == ThemeMode.dark ? 'Gelap' : 'Terang',
                    icon: settings.themeMode == ThemeMode.dark ? Icons.dark_mode_outlined : Icons.light_mode_outlined,
                    color: tokens.brand,
                  ),
                  if (!session.isRestrictedOperator)
                    AppStatusChip(
                      label: 'Admin',
                      icon: Icons.verified_user_outlined,
                      color: tokens.success,
                    ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),

        // ── Menu items ──
        AppStaggeredItem(
          index: 0,
          child: AppActionCard(
            icon: Icons.tune_rounded,
            title: 'Pengaturan',
            subtitle: 'Dark mode, host backend, tes koneksi.',
            onTap: onOpenSettings,
          ),
        ),
        const SizedBox(height: 10),
        if (!session.isRestrictedOperator) ...<Widget>[
          AppStaggeredItem(
            index: 1,
            child: AppActionCard(
              icon: Icons.manage_accounts_outlined,
              title: 'Manajemen user',
              subtitle: 'Pengelolaan akun dan hak akses.',
              accentColor: tokens.success,
              onTap: () => Navigator.of(context).push(AppRouter.userManagement()),
            ),
          ),
          const SizedBox(height: 10),
        ],
        AppStaggeredItem(
          index: session.isRestrictedOperator ? 1 : 2,
          child: AppActionCard(
            icon: Icons.logout_rounded,
            title: 'Logout',
            subtitle: 'Akhiri sesi dan kembali ke login.',
            accentColor: tokens.danger,
            onTap: onLogout,
          ),
        ),
      ],
    );
  }
}
