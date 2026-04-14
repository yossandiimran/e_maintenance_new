import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:e_maintenance/controllers/app_settings_controller.dart';
import 'package:e_maintenance/controllers/session_controller.dart';
import 'package:e_maintenance/route.dart';
import 'package:e_maintenance/service/AuthService.dart';
import 'package:e_maintenance/service/RestartGlassfish.dart';
import 'package:e_maintenance/widget/Alert.dart';
import 'package:e_maintenance/widget/CustomWidget.dart';
import 'package:e_maintenance/widget/TextStyling.dart';

class ConfigSettingPage extends StatefulWidget {
  const ConfigSettingPage({super.key});

  @override
  State<ConfigSettingPage> createState() => _ConfigSettingPageState();
}

class _ConfigSettingPageState extends State<ConfigSettingPage> {
  final _hostController = TextEditingController();

  @override
  void dispose() {
    _hostController.dispose();
    super.dispose();
  }

  Future<void> _saveHost() async {
    final settingsController = context.read<AppSettingsController>();
    _hostController.text = settingsController.activeHost;

    final saved = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Ubah host aktif'),
          content: TextFormField(
            controller: _hostController,
            decoration: const InputDecoration(
              labelText: 'Host / IP backend',
              prefixIcon: Icon(Icons.dns_outlined),
            ),
          ),
          actions: <Widget>[
            OutlinedButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Batal'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );

    if (saved != true) {
      return;
    }

    await settingsController.setHostOverride(_hostController.text);
    if (!mounted) {
      return;
    }

    Alert.showSuccessSnackBar(context, 'Host aktif berhasil diperbarui.');
  }

  Future<void> _testConnection() async {
    final service = context.read<RestartGlassfishService>();
    final host = context.read<AppSettingsController>().activeHost;
    final result = await Alert.runWithLoading(
      context: context,
      message: 'Menguji koneksi host...',
      task: () => service.checkConnection(host),
    );

    if (!mounted) {
      return;
    }

    if (result.isSuccess) {
      Alert.showSuccessSnackBar(context, 'Host aktif berhasil dijangkau.');
      return;
    }

    Alert.showErrorSnackBar(context, result.errorMessage ?? 'Koneksi host gagal.');
  }

  Future<void> _restartConnection() async {
    final result = await Alert.runWithLoading(
      context: context,
      message: 'Merestart koneksi backend...',
      task: () => context.read<RestartGlassfishService>().restartConnection(),
    );

    if (!mounted) {
      return;
    }

    if (result.isSuccess) {
      Alert.showSuccessSnackBar(context, result.data ?? 'Restart koneksi berhasil.');
      return;
    }

    Alert.showErrorSnackBar(context, result.errorMessage ?? 'Restart koneksi gagal.');
  }

  Future<void> _syncServerSettings() async {
    final authService = context.read<AuthService>();
    final settingsController = context.read<AppSettingsController>();
    final result = await Alert.runWithLoading(
      context: context,
      message: 'Menyinkronkan setting server...',
      task: () => authService.fetchOperationalSettings(),
    );

    if (!mounted) {
      return;
    }

    if (!result.isSuccess || result.data == null) {
      Alert.showErrorSnackBar(context, result.errorMessage ?? 'Sinkronisasi gagal.');
      return;
    }

    await authService.cacheOperationalSettings(result.data!);
    await settingsController.syncRemoteSettings(result.data!);
    if (!mounted) {
      return;
    }

    Alert.showSuccessSnackBar(context, 'Setting operasional berhasil disegarkan.');
  }

  @override
  Widget build(BuildContext context) {
    final session = context.watch<SessionController>().session;
    final settingsController = context.watch<AppSettingsController>();
    final tokens = context.tokens;
    final isRestricted = session?.isRestrictedOperator ?? true;
    final isDark = settingsController.themeMode == ThemeMode.dark;

    return AppPageScaffold(
      title: 'Pengaturan',
      subtitle: 'Kontrol host aktif, mode light/dark, dan utilitas operasional aplikasi.',
      actions: <Widget>[
        // ── compact dark-mode toggle (like login settings icon) ──
        IconButton(
          onPressed: () {
            settingsController.setThemeMode(isDark ? ThemeMode.light : ThemeMode.dark);
          },
          tooltip: isDark ? 'Beralih ke mode terang' : 'Beralih ke mode gelap',
          icon: Icon(isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded, size: 20),
        ),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // ── status chips + operasional header (moved to top) ──
          AppSurfaceCard(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Operasional', style: context.textTheme.titleLarge),
                const SizedBox(height: 4),
                Text(
                  'Kontrol penting dirapikan dalam satu panel.',
                  style: context.textTheme.bodyMedium?.copyWith(color: tokens.textMuted),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: <Widget>[
                    AppStatusChip(
                      label: 'Host ${settingsController.activeHost}',
                      icon: Icons.dns_rounded,
                      color: tokens.accent,
                    ),
                    AppStatusChip(
                      label: isRestricted ? 'Operator' : 'Admin',
                      icon: isRestricted ? Icons.lock_outline_rounded : Icons.verified_user_outlined,
                      color: isRestricted ? tokens.warning : tokens.success,
                    ),
                    AppStatusChip(
                      label: isDark ? 'Mode gelap' : 'Mode terang',
                      icon: isDark ? Icons.dark_mode_rounded : Icons.light_mode_outlined,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          AppActionCard(
            icon: Icons.dns_outlined,
            title: 'Ganti host backend',
            subtitle: 'Ubah IP atau host aktif tanpa harus menyentuh source code aplikasi.',
            onTap: _saveHost,
            accentColor: tokens.accent,
          ),
          const SizedBox(height: 10),
          AppActionCard(
            icon: Icons.wifi_tethering_outlined,
            title: 'Tes koneksi host',
            subtitle: 'Periksa cepat apakah backend saat ini dapat dijangkau dari perangkat.',
            onTap: _testConnection,
            accentColor: tokens.success,
          ),
          const SizedBox(height: 10),
          AppActionCard(
            icon: Icons.sync_rounded,
            title: 'Sinkronkan setting server',
            subtitle: 'Ambil ulang setting operasional seperti URL SAP, credential, dan konfigurasi runtime.',
            onTap: _syncServerSettings,
            accentColor: tokens.brand,
          ),
          if (!isRestricted) ...<Widget>[
            const SizedBox(height: 10),
            AppActionCard(
              icon: Icons.restart_alt_rounded,
              title: 'Restart koneksi backend',
              subtitle: 'Reset koneksi backend jika SAP atau integrasi operasional sedang timeout.',
              onTap: _restartConnection,
              accentColor: tokens.warning,
            ),
            const SizedBox(height: 10),
            AppActionCard(
              icon: Icons.manage_accounts_outlined,
              title: 'Kelola user',
              subtitle: 'Masuk ke modul pengelolaan akun dan hak akses user.',
              onTap: () => Navigator.of(context).push(AppRouter.userManagement()),
              accentColor: tokens.danger,
            ),
          ],
        ],
      ),
    );
  }
}
