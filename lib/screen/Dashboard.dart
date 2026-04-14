import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:e_maintenance/controllers/app_settings_controller.dart';
import 'package:e_maintenance/controllers/session_controller.dart';
import 'package:e_maintenance/route.dart';
import 'package:e_maintenance/widget/Alert.dart';
import 'package:e_maintenance/widget/CustomWidget.dart';
import 'package:e_maintenance/widget/TextStyling.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({
    super.key,
    required this.onOpenSettings,
    required this.onLogout,
  });

  final VoidCallback onOpenSettings;
  final Future<void> Function() onLogout;

  void _openRestricted(BuildContext context, bool restricted, Route<void> route) {
    if (restricted) {
      Alert.showErrorSnackBar(context, 'Akses menu ini khusus admin atau supervisor.');
      return;
    }

    Navigator.of(context).push(route);
  }

  Future<void> _openScanner(BuildContext context) async {
    final barcode = await Navigator.of(context).push<String?>(AppRouter.scanner());
    if (barcode == null || barcode.trim().isEmpty || !context.mounted) {
      return;
    }

    await Navigator.of(context).push(AppRouter.inspection(barcode));
  }

  @override
  Widget build(BuildContext context) {
    final session = context.watch<SessionController>().session;
    final tokens = context.tokens;
    final activeHost = context.watch<AppSettingsController>().activeHost;
    final isRestricted = session?.isRestrictedOperator ?? true;

    if (session == null) {
      return const Center(child: AppLoadingView());
    }

    final menuItems = <Widget>[
      AppActionCard(
        icon: Icons.qr_code_scanner_rounded,
        title: 'Cek kendaraan',
        subtitle: 'Scan serial number lalu lanjutkan checklist inspeksi harian, mingguan, bulanan, atau tutup pabrik.',
        accentColor: tokens.brand,
        onTap: () => _openScanner(context),
      ),
      AppActionCard(
        icon: Icons.description_outlined,
        title: 'Laporan transaksi',
        subtitle: 'Lihat histori inspeksi kendaraan, detail checklist, dan dokumentasi foto.',
        accentColor: tokens.accent,
        onTap: () => _openRestricted(context, isRestricted, AppRouter.transactionReportFilter()),
      ),
      AppActionCard(
        icon: Icons.groups_rounded,
        title: 'Laporan user',
        subtitle: 'Pantau user yang aktif melakukan pengecekan dan siapa yang masih belum menjalankan tugas.',
        accentColor: tokens.success,
        onTap: () => _openRestricted(context, isRestricted, AppRouter.userReport()),
      ),
      AppActionCard(
        icon: Icons.manage_accounts_outlined,
        title: 'Manajemen user',
        subtitle: 'Tambah, edit, dan rapikan akun user beserta hak akses operasionalnya.',
        accentColor: tokens.warning,
        onTap: () => _openRestricted(context, isRestricted, AppRouter.userManagement()),
      ),
      AppActionCard(
        icon: Icons.tune_rounded,
        title: 'Pengaturan aplikasi',
        subtitle: 'Kelola host aktif, light/dark mode, pengecekan koneksi, dan preferensi operasional.',
        accentColor: tokens.danger,
        onTap: onOpenSettings,
      ),
    ];

    return RefreshIndicator(
      onRefresh: () async {},
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const AppBrandBlocks(),
                    const SizedBox(height: 10),
                    Text('Workspace', style: context.textTheme.displayMedium),
                    const SizedBox(height: 4),
                    Text(
                      'Selamat datang, ${session.name}.',
                      style: context.textTheme.bodyMedium?.copyWith(color: tokens.textMuted),
                    ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                onSelected: (value) async {
                  if (value == 'settings') {
                    onOpenSettings();
                    return;
                  }

                  await onLogout();
                },
                itemBuilder: (context) => const <PopupMenuEntry<String>>[
                  PopupMenuItem<String>(
                    value: 'settings',
                    child: Text('Pengaturan'),
                  ),
                  PopupMenuItem<String>(
                    value: 'logout',
                    child: Text('Logout'),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          AppSurfaceCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: <Widget>[
                    AppStatusChip(
                      label: 'Host $activeHost',
                      icon: Icons.dns_rounded,
                      color: tokens.accent,
                    ),
                    AppStatusChip(
                      label: isRestricted ? 'Mode operator' : 'Mode admin',
                      icon: isRestricted ? Icons.lock_outline_rounded : Icons.verified_user_outlined,
                      color: isRestricted ? tokens.warning : tokens.success,
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Text('Operasional harian kendaraan', style: context.textTheme.titleLarge),
                const SizedBox(height: 4),
                Text(
                  'Menu disusun untuk penggunaan lapangan.',
                  style: context.textTheme.bodyMedium?.copyWith(color: tokens.textMuted),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          ...menuItems.expand((item) => <Widget>[item, const SizedBox(height: 10)]),
        ],
      ),
    );
  }
}
