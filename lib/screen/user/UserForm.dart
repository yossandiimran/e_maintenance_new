import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:e_maintenance/helper/global.dart';
import 'package:e_maintenance/model/app_models.dart';
import 'package:e_maintenance/service/UserService.dart';
import 'package:e_maintenance/widget/Alert.dart';
import 'package:e_maintenance/widget/CustomWidget.dart';

class UserForm extends StatefulWidget {
  const UserForm({
    super.key,
    this.initialData = const UserFormData(),
  });

  final UserFormData initialData;

  @override
  State<UserForm> createState() => _UserFormState();
}

class _UserFormState extends State<UserForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _usernameController;
  late final TextEditingController _locationController;
  late String _roleId;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController(text: widget.initialData.username);
    _locationController = TextEditingController(text: widget.initialData.location);
    _roleId = widget.initialData.roleId;
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final draft = widget.initialData.copyWith(
      username: _usernameController.text.trim(),
      location: _locationController.text.trim(),
      roleId: _roleId,
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
      Alert.showErrorSnackBar(context, result.errorMessage ?? 'User gagal disimpan.');
      return;
    }

    Alert.showSuccessSnackBar(context, 'User berhasil disimpan.');
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return AppPageScaffold(
      title: widget.initialData.isEditing ? 'Edit user' : 'Tambah user',
      subtitle: 'Form akun dibuat lebih ringkas, jelas, dan tanpa password default yang di-hardcode di UI.',
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            AppSurfaceCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TextFormField(
                    controller: _usernameController,
                    inputFormatters: <TextInputFormatter>[LowerCaseTextFormatter()],
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
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: _locationController,
                    inputFormatters: <TextInputFormatter>[UpperCaseTextFormatter()],
                    decoration: const InputDecoration(
                      labelText: 'Lokasi / Werks',
                      prefixIcon: Icon(Icons.location_on_outlined),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Lokasi wajib diisi.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 14),
                  DropdownButtonFormField<String>(
                    value: _roleId,
                    decoration: const InputDecoration(
                      labelText: 'Hak akses',
                      prefixIcon: Icon(Icons.shield_outlined),
                    ),
                    items: const <DropdownMenuItem<String>>[
                      DropdownMenuItem(value: '1', child: Text('Admin')),
                      DropdownMenuItem(value: '2', child: Text('Pimpinan')),
                      DropdownMenuItem(value: '3', child: Text('Kabag')),
                      DropdownMenuItem(value: '4', child: Text('Operator')),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => _roleId = value);
                      }
                    },
                  ),
                  const SizedBox(height: 18),
                  const AppStatusChip(
                    label: 'Password default mengikuti konfigurasi backend',
                    icon: Icons.info_outline_rounded,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _save,
                icon: const Icon(Icons.save_outlined),
                label: const Text('Simpan user'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
