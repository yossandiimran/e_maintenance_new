import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:e_maintenance/app/app_theme.dart';
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
  String _searchQuery = '';
  final _searchController = TextEditingController();

  List<AppUser> get _filteredUsers {
    if (_searchQuery.isEmpty) return _users;
    final q = _searchQuery.toLowerCase();
    return _users.where((u) {
      return u.name.toLowerCase().contains(q) ||
          u.username.toLowerCase().contains(q) ||
          u.roleLabel.toLowerCase().contains(q) ||
          u.location.toLowerCase().contains(q);
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadUsers());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
    final tokens = context.tokens;
    final displayUsers = _filteredUsers;

    return AppPageScaffold(
      title: 'Manajemen user',
      subtitle: 'Kelola akun operasional dengan layout yang ringkas dan tindakan yang lebih aman.',
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
                  children: <Widget>[
                    // ── search bar ──
                    TextFormField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Cari nama, username, atau role...',
                        prefixIcon: const Icon(Icons.search_rounded, size: 20),
                        suffixIcon: _searchQuery.isNotEmpty
                            ? IconButton(
                                onPressed: () {
                                  _searchController.clear();
                                  setState(() => _searchQuery = '');
                                },
                                icon: const Icon(Icons.close_rounded, size: 18),
                              )
                            : null,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      ),
                      onChanged: (value) => setState(() => _searchQuery = value.trim()),
                    ),
                    const SizedBox(height: 12),

                    if (displayUsers.isEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 32),
                        child: Column(
                          children: <Widget>[
                            Icon(Icons.search_off_rounded, size: 36, color: tokens.textMuted),
                            const SizedBox(height: 8),
                            Text(
                              'Tidak ada user yang cocok dengan "$_searchQuery"',
                              style: context.textTheme.bodyMedium?.copyWith(color: tokens.textMuted),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      )
                    else
                      AppSurfaceCard(
                        padding: EdgeInsets.zero,
                        child: Column(
                          children: <Widget>[
                            // ── table header ──
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                              decoration: BoxDecoration(
                                color: tokens.brand.withValues(alpha: context.isDarkMode ? 0.14 : 0.06),
                                borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
                              ),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Text(
                                      _searchQuery.isEmpty
                                          ? '${displayUsers.length} user terdaftar'
                                          : '${displayUsers.length} dari ${_users.length} user',
                                      style: context.textTheme.labelMedium?.copyWith(
                                        color: tokens.brand,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    'Aksi',
                                    style: context.textTheme.labelMedium?.copyWith(
                                      color: tokens.textMuted,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Divider(height: 1, color: tokens.borderSoft),

                            // ── rows ──
                            ...List.generate(displayUsers.length, (index) {
                              final user = displayUsers[index];
                              final isAdmin = user.roleId == '1';

                              return Column(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                    child: Row(
                                      children: <Widget>[
                                        // ── avatar ──
                                        Container(
                                          width: 34,
                                          height: 34,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            gradient: isAdmin ? tokens.brandGradient : null,
                                            color: isAdmin ? null : tokens.surfaceMuted,
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          child: Text(
                                            user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
                                            style: context.textTheme.labelLarge?.copyWith(
                                              color: isAdmin ? Colors.white : tokens.textSecondary,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 10),

                                        // ── name, username, role ──
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                user.name,
                                                style: context.textTheme.titleMedium,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              Row(
                                                children: <Widget>[
                                                  Flexible(
                                                    child: Text(
                                                      '@${user.username}',
                                                      overflow: TextOverflow.ellipsis,
                                                      style: context.textTheme.labelSmall?.copyWith(color: tokens.textMuted),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.symmetric(horizontal: 4),
                                                    child: Text('•', style: context.textTheme.labelSmall?.copyWith(color: tokens.textMuted)),
                                                  ),
                                                  _RoleBadge(label: user.roleLabel, tokens: tokens, isAdmin: isAdmin),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 4),

                                        // ── action icons ──
                                        SizedBox(
                                          width: 72,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: <Widget>[
                                              _ActionIcon(
                                                icon: Icons.edit_outlined,
                                                color: tokens.brand,
                                                onTap: () => _openForm(UserFormData.fromUser(user)),
                                              ),
                                              const SizedBox(width: 4),
                                              _ActionIcon(
                                                icon: Icons.delete_outline_rounded,
                                                color: tokens.danger,
                                                onTap: () => _deleteUser(user),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (index < displayUsers.length - 1)
                                    Divider(height: 1, indent: 58, endIndent: 14, color: tokens.borderSoft),
                                ],
                              );
                            }),

                            // ── bottom padding ──
                            const SizedBox(height: 4),
                          ],
                        ),
                      ),
                  ],
                ),
    );
  }
}

// ── Tiny role badge ──
class _RoleBadge extends StatelessWidget {
  const _RoleBadge({
    required this.label,
    required this.tokens,
    required this.isAdmin,
  });

  final String label;
  final AppTokens tokens;
  final bool isAdmin;

  @override
  Widget build(BuildContext context) {
    final color = isAdmin ? tokens.brand : tokens.accent;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
      decoration: BoxDecoration(
        color: color.withValues(alpha: context.isDarkMode ? 0.18 : 0.10),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: context.textTheme.labelSmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w700,
          fontSize: 10,
        ),
      ),
    );
  }
}

// ── Compact action icon button ──
class _ActionIcon extends StatelessWidget {
  const _ActionIcon({
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 32,
        height: 32,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: color.withValues(alpha: context.isDarkMode ? 0.16 : 0.08),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 16, color: color),
      ),
    );
  }
}
