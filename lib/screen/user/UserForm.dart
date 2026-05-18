import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:e_maintenance/app/app_theme.dart';
import 'package:e_maintenance/controllers/session_controller.dart';
import 'package:e_maintenance/helper/global.dart';
import 'package:e_maintenance/model/app_models.dart';
import 'package:e_maintenance/service/UserService.dart';
import 'package:e_maintenance/widget/Alert.dart';
import 'package:e_maintenance/widget/CustomWidget.dart';
import 'package:e_maintenance/widget/TextStyling.dart';

class UserForm extends StatefulWidget {
  const UserForm({
    super.key,
    this.initialData = const UserFormData(),
  });

  final UserFormData initialData;

  @override
  State<UserForm> createState() => _UserFormState();
}

class _UserFormState extends State<UserForm>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _usernameController;
  late final TextEditingController _locationController;
  static const String _usersRoleId = '4';

  late final AnimationController _animCtrl;
  late final Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _usernameController =
        TextEditingController(text: widget.initialData.username);
    final sessionLocation =
        context.read<SessionController>().session?.werks ?? '';
    final defaultLocation = sessionLocation.trim().isNotEmpty
        ? sessionLocation
        : widget.initialData.location;
    _locationController = TextEditingController(text: defaultLocation);

    _animCtrl = AnimationController(vsync: this, duration: AppMotion.slow);
    _fadeAnim = CurvedAnimation(parent: _animCtrl, curve: AppMotion.standard);
    _animCtrl.forward();
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    _usernameController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final location = _locationController.text.trim();
    if (location.isEmpty) {
      Alert.showErrorSnackBar(
        context,
        'Lokasi user login tidak tersedia. Silakan login ulang.',
      );
      return;
    }

    final draft = widget.initialData.copyWith(
      username: _usernameController.text.trim(),
      location: location,
      roleId: _usersRoleId,
    );

    final result = await Alert.runWithLoading(
      context: context,
      message: 'Menyimpan user...',
      task: () => context.read<UserService>().saveUser(draft),
    );

    if (!mounted) {
      return;
    }

    if (!result.isSuccess) {
      Alert.showErrorSnackBar(
          context, result.errorMessage ?? 'User gagal disimpan.');
      return;
    }

    Alert.showSuccessSnackBar(context, 'User berhasil disimpan.');
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final isEditing = widget.initialData.isEditing;

    return AppPageScaffold(
      title: isEditing ? 'Edit user' : 'Tambah user',
      subtitle:
          'Form akun dibuat lebih ringkas, jelas, dan tanpa password default.',
      child: FadeTransition(
        opacity: _fadeAnim,
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // ── form header icon ──
              AppStaggeredItem(
                index: 0,
                child: AppSectionHeader(
                  title: isEditing ? 'Ubah data user' : 'Data user baru',
                ),
              ),
              const SizedBox(height: 10),

              // ── form card ──
              AppStaggeredItem(
                index: 1,
                child: AppSurfaceCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      TextFormField(
                        controller: _usernameController,
                        inputFormatters: <TextInputFormatter>[
                          LowerCaseTextFormatter()
                        ],
                        decoration: const InputDecoration(
                          labelText: 'Username',
                          prefixIcon: Icon(Icons.person_outline_rounded),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Username wajib diisi.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _locationController,
                        readOnly: true,
                        decoration: const InputDecoration(
                          labelText: 'Lokasi',
                          prefixIcon: Icon(Icons.location_on_outlined),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Lokasi wajib diisi.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        initialValue: 'Users',
                        readOnly: true,
                        decoration: const InputDecoration(
                          labelText: 'Hak akses',
                          prefixIcon: Icon(Icons.shield_outlined),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // ── info chip ──
              AppStaggeredItem(
                index: 2,
                child: Row(
                  children: <Widget>[
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: tokens.brand.withValues(
                            alpha: context.isDarkMode ? 0.22 : 0.10),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(Icons.info_outline_rounded,
                          size: 16, color: tokens.brand),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Password default mengikuti konfigurasi.',
                        style: context.textTheme.bodySmall
                            ?.copyWith(color: tokens.textMuted),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // ── save button ──
              AppStaggeredItem(
                index: 3,
                child: SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: FilledButton.icon(
                    onPressed: _save,
                    icon: Icon(isEditing
                        ? Icons.save_outlined
                        : Icons.person_add_alt_1_outlined),
                    label: Text(isEditing ? 'Simpan perubahan' : 'Tambah user'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
