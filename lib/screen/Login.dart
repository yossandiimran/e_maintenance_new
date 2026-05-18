import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:e_maintenance/controllers/app_settings_controller.dart';
import 'package:e_maintenance/controllers/session_controller.dart';
import 'package:e_maintenance/core/config/app_environment.dart';
import 'package:e_maintenance/route.dart';
import 'package:e_maintenance/service/AuthService.dart';
import 'package:e_maintenance/widget/Alert.dart';
import 'package:e_maintenance/widget/CustomWidget.dart';
import 'package:e_maintenance/widget/TextStyling.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController(text: 'centr@l1001');
  final _hostController = TextEditingController();

  bool _obscurePassword = true;
  late final AnimationController _animCtrl;
  late final Animation<double> _fadeIn;

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
    _fadeIn = CurvedAnimation(parent: _animCtrl, curve: Curves.easeOutCubic);
    _animCtrl.forward();
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _hostController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    final authService = context.read<AuthService>();
    final sessionController = context.read<SessionController>();
    final settingsController = context.read<AppSettingsController>();

    final result = await Alert.runWithLoading(
      context: context,
      message: 'Memverifikasi akun…',
      task: () async {
        final loginResult = await authService.login(
          username: _usernameController.text,
          password: _passwordController.text,
        );
        if (!loginResult.isSuccess || loginResult.data == null) {
          return loginResult;
        }

        await sessionController.setSession(loginResult.data!);

        final settingsResult = await authService.fetchOperationalSettings();
        if (settingsResult.isSuccess && settingsResult.data != null) {
          await authService.cacheOperationalSettings(settingsResult.data!);
          await settingsController.syncRemoteSettings(settingsResult.data!);
        }

        return loginResult;
      },
    );

    if (!mounted) return;

    if (!result.isSuccess) {
      Alert.showErrorSnackBar(context, result.errorMessage ?? 'Login gagal.');
      return;
    }

    Alert.showSuccessSnackBar(context, 'Login berhasil. Selamat bekerja.');
    await AppRouter.replaceWithHome(context);
  }

  void _openSettingsSheet() {
    final settingsController = context.read<AppSettingsController>();
    _hostController.text = settingsController.activeHost;

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (sheetContext, setSheetState) {
            final tokens = sheetContext.tokens;
            final isDark = settingsController.themeMode == ThemeMode.dark;

            return Padding(
              padding: EdgeInsets.fromLTRB(
                20,
                14,
                20,
                16 + MediaQuery.of(sheetContext).viewInsets.bottom,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    width: 36,
                    height: 4,
                    decoration: BoxDecoration(
                      color: tokens.border,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text('Pengaturan', style: sheetContext.textTheme.titleLarge),
                  const SizedBox(height: 16),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: tokens.surfaceMuted,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: tokens.borderSoft),
                    ),
                    child: Row(
                      children: <Widget>[
                        Icon(
                          isDark
                              ? Icons.dark_mode_rounded
                              : Icons.light_mode_rounded,
                          size: 18,
                          color: tokens.brand,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            isDark ? 'Mode gelap' : 'Mode terang',
                            style: sheetContext.textTheme.bodyMedium,
                          ),
                        ),
                        Switch.adaptive(
                          value: isDark,
                          activeColor: tokens.brand,
                          onChanged: (value) async {
                            final newMode =
                                value ? ThemeMode.dark : ThemeMode.light;
                            await settingsController.setThemeMode(newMode);
                            setSheetState(() {});
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _hostController,
                    decoration: const InputDecoration(
                      labelText: 'Host / IP',
                      hintText: '210.210.165.197',
                      prefixIcon: Icon(Icons.dns_outlined),
                    ),
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: () async {
                        await settingsController
                            .setHostOverride(_hostController.text);
                        if (!mounted) return;
                        Navigator.of(sheetContext).pop();
                        Alert.showSuccessSnackBar(
                            context, 'Pengaturan disimpan.');
                      },
                      icon: const Icon(Icons.save_rounded, size: 18),
                      label: const Text('Simpan Host'),
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final settingsCtrl = context.watch<AppSettingsController>();
    final host = settingsCtrl.activeHost;
    final isDark = settingsCtrl.themeMode == ThemeMode.dark;

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
              end: const Alignment(0, 0.4),
              colors: <Color>[
                tokens.heroEnd
                    .withValues(alpha: context.isDarkMode ? 0.45 : 0.2),
                tokens.pageBackground,
              ],
            ),
          ),
          child: SafeArea(
            child: FadeTransition(
              opacity: _fadeIn,
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(18, 12, 18, 24),
                physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // ── top bar ──
                    Row(
                      children: <Widget>[
                        const Expanded(child: AppBrandBlocks()),
                        const SizedBox(width: 10),
                        Material(
                          color: tokens.surface.withValues(alpha: 0.7),
                          borderRadius: BorderRadius.circular(12),
                          child: InkWell(
                            onTap: _openSettingsSheet,
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              width: 38,
                              height: 38,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: tokens.borderSoft),
                              ),
                              child: Icon(Icons.settings_outlined,
                                  size: 18, color: tokens.textSecondary),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // ── hero header ──
                    Row(
                      children: <Widget>[
                        Container(
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                                color: tokens.brand.withValues(alpha: 0.14),
                                width: 1.5),
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                color: tokens.brand.withValues(alpha: 0.14),
                                blurRadius: 16,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(14),
                            child: Image.asset('assets/icon.png',
                                width: 52, height: 52, fit: BoxFit.cover),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text('Masuk ke workspace',
                                  style: context.textTheme.displayMedium),
                              const SizedBox(height: 3),
                              Text(
                                'Scan, inspeksi, dan laporan dalam satu tempat.',
                                style: context.textTheme.bodySmall
                                    ?.copyWith(color: tokens.textMuted),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.only(left: 66),
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: <Widget>[
                          AppStatusChip(
                            label: host,
                            icon: Icons.dns_rounded,
                            color: tokens.accent,
                          ),
                          AppStatusChip(
                            label: isDark ? 'Gelap' : 'Terang',
                            icon: isDark
                                ? Icons.dark_mode_rounded
                                : Icons.light_mode_outlined,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // ── login form ──
                    AppSurfaceCard(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text('Login akun',
                                style: context.textTheme.titleLarge),
                            const SizedBox(height: 3),
                            Text(
                              'Gunakan username dan password dari administrator.',
                              style: context.textTheme.bodySmall
                                  ?.copyWith(color: tokens.textMuted),
                            ),
                            const SizedBox(height: 14),
                            TextFormField(
                              controller: _usernameController,
                              textInputAction: TextInputAction.next,
                              decoration: const InputDecoration(
                                labelText: 'Username',
                                hintText: 'Masukkan username',
                                prefixIcon: Icon(Icons.person_outline_rounded),
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Username wajib diisi.';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              controller: _passwordController,
                              obscureText: _obscurePassword,
                              textInputAction: TextInputAction.done,
                              decoration: InputDecoration(
                                labelText: 'Password',
                                hintText: 'Masukkan password',
                                prefixIcon:
                                    const Icon(Icons.lock_outline_rounded),
                                suffixIcon: IconButton(
                                  onPressed: () => setState(() =>
                                      _obscurePassword = !_obscurePassword),
                                  icon: Icon(
                                    _obscurePassword
                                        ? Icons.visibility_outlined
                                        : Icons.visibility_off_outlined,
                                    size: 20,
                                  ),
                                ),
                              ),
                              onFieldSubmitted: (_) => _login(),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Password wajib diisi.';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              width: double.infinity,
                              height: 48,
                              child: FilledButton.icon(
                                onPressed: _login,
                                icon: const Icon(Icons.login_rounded, size: 18),
                                label: const Text('Masuk'),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: <Widget>[
                                Text(
                                  'v${AppEnvironment.appVersion}',
                                  style: context.textTheme.labelSmall
                                      ?.copyWith(color: tokens.textMuted),
                                ),
                                const Spacer(),
                                TextButton(
                                  onPressed: () {
                                    Alert.showMessage(
                                      context: context,
                                      title: 'Butuh bantuan?',
                                      message:
                                          'Silakan hubungi admin internal untuk reset password akun.',
                                    );
                                  },
                                  child: const Text('Lupa password?'),
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
          ),
        ),
      ),
    );
  }
}
