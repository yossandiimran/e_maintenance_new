import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:e_maintenance/controllers/app_settings_controller.dart';
import 'package:e_maintenance/controllers/session_controller.dart';
import 'package:e_maintenance/core/config/app_environment.dart';
import 'package:e_maintenance/helper/firebaseMessagingHelper.dart';
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

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController(text: 'centr@l1001');
  final _hostController = TextEditingController();

  bool _obscurePassword = true;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _hostController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final authService = context.read<AuthService>();
    final messagingHelper = context.read<FirebaseMessagingHelper>();
    final sessionController = context.read<SessionController>();
    final settingsController = context.read<AppSettingsController>();

    final result = await Alert.runWithLoading(
      context: context,
      message: 'Memverifikasi akun...',
      task: () async {
        final deviceToken = await messagingHelper.getDeviceToken();
        final loginResult = await authService.login(
          username: _usernameController.text,
          password: _passwordController.text,
          deviceToken: deviceToken,
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

    if (!mounted) {
      return;
    }

    if (!result.isSuccess) {
      Alert.showErrorSnackBar(context, result.errorMessage ?? 'Login gagal.');
      return;
    }

    Alert.showSuccessSnackBar(context, 'Login berhasil. Selamat bekerja.');
    await AppRouter.replaceWithHome(context);
  }

  Future<void> _showHostDialog() async {
    final settingsController = context.read<AppSettingsController>();
    _hostController.text = settingsController.activeHost;

    final saved = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Host API'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Ubah host backend jika perangkat perlu memakai VPN, staging, atau server lokal.',
                style: dialogContext.textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _hostController,
                decoration: const InputDecoration(
                  labelText: 'Host / IP',
                  hintText: '210.210.165.197',
                  prefixIcon: Icon(Icons.dns_outlined),
                ),
              ),
            ],
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

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final host = context.watch<AppSettingsController>().activeHost;

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
                tokens.heroEnd.withValues(alpha: context.isDarkMode ? 0.6 : 0.22),
                tokens.pageBackground,
              ],
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      const Expanded(child: AppBrandBlocks()),
                      const SizedBox(width: 8),
                      IconButton(
                        onPressed: _showHostDialog,
                        icon: const Icon(Icons.settings_outlined, size: 20),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  AppSurfaceCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Container(
                              width: 64,
                              height: 64,
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                gradient: tokens.brandGradient,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Image.asset(AppEnvironment.launcherIconAsset),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text('Masuk ke workspace', style: context.textTheme.displayMedium),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Satu tempat untuk scan, inspeksi, laporan, dan pengelolaan user.',
                                    style: context.textTheme.bodyMedium?.copyWith(color: tokens.textMuted),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: <Widget>[
                            AppStatusChip(
                              label: 'Host $host',
                              icon: Icons.dns_rounded,
                              color: tokens.accent,
                            ),
                            const AppStatusChip(
                              label: 'Tema light/dark',
                              icon: Icons.light_mode_outlined,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  AppSurfaceCard(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('Login akun', style: context.textTheme.titleLarge),
                          const SizedBox(height: 4),
                          Text(
                            'Gunakan username dan password yang sudah diatur administrator.',
                            style: context.textTheme.bodyMedium?.copyWith(color: tokens.textMuted),
                          ),
                          const SizedBox(height: 12),
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
                              prefixIcon: const Icon(Icons.lock_outline_rounded),
                              suffixIcon: IconButton(
                                onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                                icon: Icon(
                                  _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
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
                          const SizedBox(height: 14),
                          SizedBox(
                            width: double.infinity,
                            child: FilledButton.icon(
                              onPressed: _login,
                              icon: const Icon(Icons.login_rounded),
                              label: const Text('Masuk aplikasi'),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: <Widget>[
                              Text(
                                'Version ${AppEnvironment.appVersion}',
                                style: context.textTheme.labelMedium?.copyWith(color: tokens.textMuted),
                              ),
                              const Spacer(),
                              TextButton(
                                onPressed: () {
                                  Alert.showMessage(
                                    context: context,
                                    title: 'Butuh bantuan?',
                                    message: 'Silakan hubungi admin internal untuk reset password akun.',
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
    );
  }
}
