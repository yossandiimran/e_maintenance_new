import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:e_maintenance/controllers/session_controller.dart';
import 'package:e_maintenance/model/app_models.dart';
import 'package:e_maintenance/route.dart';
import 'package:e_maintenance/service/UserService.dart';
import 'package:e_maintenance/widget/Alert.dart';
import 'package:e_maintenance/widget/CustomWidget.dart';
import 'package:e_maintenance/widget/TextStyling.dart';

class User extends StatefulWidget {
  const User({super.key});

  @override
  State<User> createState() => _UserState();
}

class _UserState extends State<User> {
  bool _loading = true;
  List<AppUser> _users = <AppUser>[];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadUsers());
  }

  Future<void> _loadUsers() async {
    final session = context.read<SessionController>().session;
    if (session == null) {
      return;
    }

    final result = await context.read<UserService>().fetchUsers(location: session.werks);
    if (!mounted) {
      return;
    }

    if (!result.isSuccess || result.data == null) {
      setState(() => _loading = false);
      Alert.showErrorSnackBar(context, result.errorMessage ?? 'Daftar user gagal dimuat.');
      return;
    }

    setState(() {
      _users = result.data!..sort((a, b) => a.name.compareTo(b.name));
      _loading = false;
    });
  }

  Future<void> _openForm(UserFormData data) async {
    await Navigator.of(context).push(AppRouter.userForm(data));
    if (!mounted) {
      return;
    }
    await _loadUsers();
  }

  Future<void> _deleteUser(AppUser user) async {
    final userService = context.read<UserService>();
    final confirmed = await Alert.confirm(
      context: context,
      title: 'Hapus user?',
      message: 'User ${user.username} akan dihapus dari daftar aplikasi.',
      confirmLabel: 'Hapus',
      destructive: true,
    );

    if (!confirmed) {
      return;
    }

    final result = await Alert.runWithLoading(
      context: context,
      message: 'Menghapus user...',
      task: () => userService.deleteUser(user.id),
    );

    if (!mounted) {
      return;
    }

    if (!result.isSuccess) {
      Alert.showErrorSnackBar(context, result.errorMessage ?? 'User gagal dihapus.');
      return;
    }

    Alert.showSuccessSnackBar(context, 'User berhasil dihapus.');
    await _loadUsers();
  }

  @override
  Widget build(BuildContext context) {
    return AppPageScaffold(
      title: 'Manajemen user',
      subtitle: 'Kelola akun operasional dengan layout mobile yang lebih rapi dan tindakan yang lebih aman.',
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openForm(const UserFormData()),
        icon: const Icon(Icons.person_add_alt_1_outlined),
        label: const Text('Tambah user'),
      ),
      child: _loading
          ? const SizedBox(height: 320, child: AppLoadingView())
          : _users.isEmpty
              ? AppEmptyState(
                  title: 'Belum ada user',
                  message: 'Belum ada data user yang tersedia untuk lokasi saat ini.',
                  icon: Icons.group_outlined,
                  action: FilledButton.icon(
                    onPressed: () => _openForm(const UserFormData()),
                    icon: const Icon(Icons.person_add_alt_1_outlined),
                    label: const Text('Tambah user'),
                  ),
                )
              : Column(
                  children: _users.map((user) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: AppSurfaceCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(user.name, style: context.textTheme.titleLarge),
                            const SizedBox(height: 4),
                            Text(
                              '@${user.username}  •  ${user.roleLabel}  •  ${user.location}',
                              style: context.textTheme.bodyMedium,
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: OutlinedButton.icon(
                                    onPressed: () => _openForm(UserFormData.fromUser(user)),
                                    icon: const Icon(Icons.edit_outlined),
                                    label: const Text('Edit'),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: FilledButton.icon(
                                    onPressed: () => _deleteUser(user),
                                    icon: const Icon(Icons.delete_outline_rounded),
                                    label: const Text('Hapus'),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
    );
  }
}
