import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:e_maintenance/controllers/session_controller.dart';
import 'package:e_maintenance/route.dart';
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

  Future<void> _openScanner(BuildContext context) async {
    final barcode = await Navigator.of(context).push<String?>(AppRouter.scanner());
    if (barcode == null || barcode.trim().isEmpty || !context.mounted) return;
    await Navigator.of(context).push(AppRouter.inspection(barcode));
  }

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 11) return 'Selamat pagi';
    if (hour < 15) return 'Selamat siang';
    if (hour < 18) return 'Selamat sore';
    return 'Selamat malam';
  }

  @override
  Widget build(BuildContext context) {
    final session = context.watch<SessionController>().session;
    final tokens = context.tokens;
    final isRestricted = session?.isRestrictedOperator ?? true;

    if (session == null) {
      return const Center(child: AppLoadingView());
    }

    final menuItems = <_MenuItem>[
      _MenuItem(
        icon: Icons.qr_code_scanner_rounded,
        title: 'Cek kendaraan',
        subtitle: 'Scan serial number lalu lanjutkan checklist inspeksi.',
        color: tokens.brand,
        onTap: () => _openScanner(context),
      ),
      if (!isRestricted) ...<_MenuItem>[
        _MenuItem(
          icon: Icons.description_outlined,
          title: 'Laporan transaksi',
          subtitle: 'Histori inspeksi kendaraan dan dokumentasi foto.',
          color: tokens.accent,
          onTap: () => Navigator.of(context).push(AppRouter.transactionReportFilter()),
        ),
        _MenuItem(
          icon: Icons.groups_rounded,
          title: 'Laporan user',
          subtitle: 'Pantau user yang aktif melakukan pengecekan.',
          color: tokens.success,
          onTap: () => Navigator.of(context).push(AppRouter.userReport()),
        ),
        _MenuItem(
          icon: Icons.manage_accounts_outlined,
          title: 'Manajemen user',
          subtitle: 'Tambah, edit, dan atur hak akses user.',
          color: tokens.warning,
          onTap: () => Navigator.of(context).push(AppRouter.userManagement()),
        ),
      ],
      _MenuItem(
        icon: Icons.tune_rounded,
        title: 'Pengaturan',
        subtitle: 'Host aktif, dark mode, dan koneksi.',
        color: tokens.danger,
        onTap: onOpenSettings,
      ),
    ];

    return RefreshIndicator(
      onRefresh: () async {},
      color: tokens.brand,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
        padding: const EdgeInsets.fromLTRB(18, 10, 18, 100),
        children: <Widget>[
          // ── Header ──
          const AppBrandBlocks(),
          const SizedBox(height: 12),
          Text('Workspace', style: context.textTheme.displayMedium),
          const SizedBox(height: 3),
          Text(
            '${_greeting()}, ${session.name}.',
            style: context.textTheme.bodyMedium?.copyWith(color: tokens.textMuted),
          ),
          const SizedBox(height: 16),

          // ── Menu items with stagger animation ──
          ...List.generate(menuItems.length, (index) {
            final item = menuItems[index];
            return AppStaggeredItem(
              index: index,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: AppActionCard(
                  icon: item.icon,
                  title: item.title,
                  subtitle: item.subtitle,
                  accentColor: item.color,
                  onTap: item.onTap,
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _MenuItem {
  const _MenuItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;
}
