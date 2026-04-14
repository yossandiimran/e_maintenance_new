import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:e_maintenance/controllers/app_settings_controller.dart';
import 'package:e_maintenance/controllers/session_controller.dart';
import 'package:e_maintenance/route.dart';
import 'package:e_maintenance/screen/Dashboard.dart';
import 'package:e_maintenance/screen/menu/Profile.dart';
import 'package:e_maintenance/service/AuthService.dart';
import 'package:e_maintenance/widget/Alert.dart';
import 'package:e_maintenance/widget/TextStyling.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkSessionExpiry();
      _syncOperationalSettings();
    });
  }

  Future<void> _checkSessionExpiry() async {
    final sessionController = context.read<SessionController>();
    final session = sessionController.session;
    if (session != null && session.isSessionExpired) {
      await sessionController.logout();
      if (!mounted) return;
      Alert.showErrorSnackBar(context, 'Sesi login sudah kedaluwarsa (6 jam). Silakan login kembali.');
      await AppRouter.replaceWithLogin(context);
    }
  }

  Future<void> _syncOperationalSettings() async {
    final authService = context.read<AuthService>();
    final settingsController = context.read<AppSettingsController>();
    final result = await authService.fetchOperationalSettings();
    if (!result.isSuccess || result.data == null) {
      return;
    }

    await authService.cacheOperationalSettings(result.data!);
    await settingsController.syncRemoteSettings(result.data!);
  }

  Future<void> _logout() async {
    final confirmed = await Alert.confirm(
      context: context,
      title: 'Logout sekarang?',
      message: 'Sesi akun akan diakhiri di perangkat ini.',
      confirmLabel: 'Logout',
      destructive: true,
    );

    if (!confirmed || !mounted) {
      return;
    }

    final sessionController = context.read<SessionController>();
    final authService = context.read<AuthService>();
    final currentSession = sessionController.session;

    await Alert.runWithLoading(
      context: context,
      message: 'Menutup sesi...',
      task: () async {
        if (currentSession != null) {
          await authService.unregisterDevice(userId: currentSession.id);
        }
        await sessionController.logout();
      },
    );

    if (!mounted) {
      return;
    }

    await AppRouter.replaceWithLogin(context);
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final pages = <Widget>[
      Dashboard(
        onOpenSettings: () => Navigator.of(context).push(AppRouter.settings()),
        onLogout: _logout,
      ),
      Profile(
        onOpenSettings: () => Navigator.of(context).push(AppRouter.settings()),
        onLogout: _logout,
      ),
    ];

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
                tokens.heroEnd.withValues(alpha: context.isDarkMode ? 0.35 : 0.16),
                tokens.pageBackground,
              ],
            ),
          ),
          child: SafeArea(
            child: IndexedStack(
              index: _selectedIndex,
              children: pages,
            ),
          ),
        ),
        bottomNavigationBar: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(14, 0, 14, 10),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: tokens.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: tokens.borderSoft),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: tokens.shadow,
                    blurRadius: 16,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: NavigationBar(
                selectedIndex: _selectedIndex,
                backgroundColor: Colors.transparent,
                onDestinationSelected: (value) => setState(() => _selectedIndex = value),
                destinations: const <NavigationDestination>[
                  NavigationDestination(
                    icon: Icon(Icons.grid_view_rounded),
                    selectedIcon: Icon(Icons.grid_view_rounded),
                    label: 'Workspace',
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.person_outline_rounded),
                    selectedIcon: Icon(Icons.person_rounded),
                    label: 'Akun',
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
