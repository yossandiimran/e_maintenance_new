import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import 'package:e_maintenance/controllers/session_controller.dart';
import 'package:e_maintenance/helper/global.dart';
import 'package:e_maintenance/model/app_models.dart';
import 'package:e_maintenance/service/InputService.dart';
import 'package:e_maintenance/widget/Alert.dart';
import 'package:e_maintenance/widget/CustomWidget.dart';
import 'package:e_maintenance/widget/TextStyling.dart';

class InsertPage extends StatefulWidget {
  const InsertPage({
    super.key,
    required this.barcode,
  });

  final String barcode;

  @override
  State<InsertPage> createState() => _InsertPageState();
}

class _InsertPageState extends State<InsertPage> {
  final ImagePicker _imagePicker = ImagePicker();

  VehicleInfo? _vehicleInfo;
  InspectionKind? _selectedKind;
  List<ChecklistItem> _items = <ChecklistItem>[];
  bool _loadingVehicle = true;
  bool _loadingChecklist = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadVehicleInfo());
  }

  Future<void> _loadVehicleInfo() async {
    final session = context.read<SessionController>().session;
    if (session == null) {
      return;
    }

    final result = await Alert.runWithLoading(
      context: context,
      message: 'Mengambil data kendaraan...',
      task: () => context.read<InputService>().fetchVehicleInfo(
            barcode: widget.barcode,
            session: session,
          ),
    );

    if (!mounted) {
      return;
    }

    if (!result.isSuccess || result.data == null) {
      await Alert.showMessage(
        context: context,
        title: 'Data kendaraan tidak tersedia',
        message: result.errorMessage ?? 'Kendaraan tidak berhasil ditemukan di backend.',
        isError: true,
      );
      if (mounted) {
        Navigator.of(context).pop();
      }
      return;
    }

    setState(() {
      _vehicleInfo = result.data;
      _loadingVehicle = false;
    });

    // Validate plant/werks match between user session and asset
    final currentSession = context.read<SessionController>().session;
    if (currentSession != null && result.data!.werks.isNotEmpty && currentSession.werks.isNotEmpty) {
      if (result.data!.werks != currentSession.werks) {
        if (mounted) {
          Alert.showMessage(
            context: context,
            title: 'Lokasi tidak sesuai',
            message:
                'Lokasi aset (${result.data!.werks}) tidak sesuai dengan lokasi user Anda (${currentSession.werks}). '
                'Anda tetap bisa melanjutkan inspeksi, tetapi harap pastikan kendaraan ini sesuai penugasan.',
            isError: true,
          );
        }
      }
    }
  }

  Future<void> _selectInspectionKind(InspectionKind kind) async {
    if (_vehicleInfo == null) {
      return;
    }

    setState(() {
      _selectedKind = kind;
      _loadingChecklist = true;
    });

    final result = await context.read<InputService>().fetchChecklist(
          inspectionKind: kind,
          isForklift: _vehicleInfo!.isForklift,
        );

    if (!mounted) {
      return;
    }

    if (!result.isSuccess || result.data == null) {
      setState(() => _loadingChecklist = false);
      Alert.showErrorSnackBar(context, result.errorMessage ?? 'Checklist tidak berhasil dimuat.');
      return;
    }

    setState(() {
      _items = result.data!;
      _loadingChecklist = false;
    });
  }

  Future<void> _attachEvidence(int index) async {
    final image = await _imagePicker.pickImage(
      source: ImageSource.camera,
      maxWidth: 1392,
      maxHeight: 1856,
      imageQuality: 30,
    );

    if (image == null || !mounted) {
      return;
    }

    final file = File(image.path);
    final note = await _askForNote(file, _items[index].note);
    if (note == null || note.trim().isEmpty || !mounted) {
      return;
    }

    final uploadResult = await Alert.runWithLoading(
      context: context,
      message: 'Mengunggah foto inspeksi...',
      task: () => context.read<InputService>().uploadPhoto(file),
    );

    if (!mounted) {
      return;
    }

    if (!uploadResult.isSuccess || uploadResult.data == null) {
      Alert.showErrorSnackBar(context, uploadResult.errorMessage ?? 'Foto inspeksi gagal diunggah.');
      return;
    }

    setState(() {
      _items[index] = _items[index].copyWith(
        isDone: true,
        note: note.trim(),
        photoFileName: uploadResult.data!,
      );
    });

    Alert.showSuccessSnackBar(context, 'Bukti inspeksi tersimpan.');
  }

  Future<String?> _askForNote(File imageFile, String currentValue) {
    final controller = TextEditingController(text: currentValue);
    String? errorText;

    return showDialog<String>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: const Text('Catatan inspeksi'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(18),
                      child: Image.file(imageFile, height: 180, width: double.infinity, fit: BoxFit.cover),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: controller,
                      minLines: 3,
                      maxLines: 4,
                      decoration: InputDecoration(
                        labelText: 'Keterangan',
                        hintText: 'Contoh: Kondisi baik, baut aman, tidak ada kebocoran.',
                        errorText: errorText,
                      ),
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                OutlinedButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: const Text('Batal'),
                ),
                FilledButton(
                  onPressed: () {
                    if (controller.text.trim().isEmpty) {
                      setStateDialog(() => errorText = 'Keterangan wajib diisi.');
                      return;
                    }
                    Navigator.of(dialogContext).pop(controller.text.trim());
                  },
                  child: const Text('Simpan'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _submitInspection() async {
    final session = context.read<SessionController>().session;
    if (session == null || _vehicleInfo == null || _selectedKind == null) {
      return;
    }

    if (_items.isEmpty) {
      Alert.showErrorSnackBar(context, 'Checklist inspeksi belum tersedia.');
      return;
    }

    final result = await Alert.runWithLoading(
      context: context,
      message: 'Menyimpan checklist inspeksi...',
      task: () => context.read<InputService>().submitInspection(
            items: _items,
            inspectionKind: _selectedKind!,
            barcode: widget.barcode,
            vehicleName: _vehicleInfo!.materialDescription,
            userName: session.name,
            location: session.werks,
            inspectionDate: DateTime.now(),
          ),
    );

    if (!mounted) {
      return;
    }

    if (!result.isSuccess) {
      Alert.showErrorSnackBar(context, result.errorMessage ?? 'Checklist inspeksi gagal disimpan.');
      return;
    }

    Alert.showSuccessSnackBar(context, result.data ?? 'Checklist inspeksi berhasil disimpan.');
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final session = context.watch<SessionController>().session;
    final tokens = context.tokens;

    return AppPageScaffold(
      title: 'Tambah pengecekan',
      subtitle: 'Data kendaraan, jenis inspeksi, dan bukti lapangan disusun dalam satu alur yang lebih aman.',
      actions: <Widget>[
        IconButton(
          onPressed: _items.isEmpty ? null : _submitInspection,
          icon: const Icon(Icons.save_rounded),
        ),
      ],
      child: _loadingVehicle || session == null
          ? const SizedBox(height: 320, child: AppLoadingView())
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                AppSurfaceCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: <Widget>[
                          AppStatusChip(
                            label: _vehicleInfo!.isForklift ? 'Forklip' : 'Mobil',
                            icon: _vehicleInfo!.isForklift
                                ? Icons.local_shipping_rounded
                                : Icons.directions_car_filled_rounded,
                            color: tokens.accent,
                          ),
                          AppStatusChip(
                            label: AppDateUtils.formatDisplay(AppDateUtils.todayApiString()),
                            icon: Icons.calendar_today_outlined,
                            color: tokens.brand,
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 14,
                        runSpacing: 14,
                        children: <Widget>[
                          AppSummaryItem(label: 'PIC', value: session.name),
                          AppSummaryItem(label: 'Lokasi', value: session.werks),
                          AppSummaryItem(label: 'Kendaraan', value: _vehicleInfo!.materialDescription),
                          AppSummaryItem(label: 'Serial', value: widget.barcode),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                AppSurfaceCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('Jenis pengecekan', style: context.textTheme.titleLarge),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: InspectionKind.values.map((kind) {
                          final selected = _selectedKind == kind;
                          return ChoiceChip(
                            selected: selected,
                            label: Text(kind.label),
                            onSelected: (_) => _selectInspectionKind(kind),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                if (_loadingChecklist)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 40),
                    child: AppLoadingView(),
                  )
                else if (_selectedKind == null)
                  const AppEmptyState(
                    title: 'Pilih jenis pengecekan',
                    message: 'Checklist akan dimuat setelah Anda menentukan jenis inspeksi yang sedang dikerjakan.',
                    icon: Icons.fact_check_outlined,
                  )
                else if (_items.isEmpty)
                  const AppEmptyState(
                    title: 'Checklist kosong',
                    message: 'Belum ada item inspeksi yang tersedia untuk jenis pengecekan ini.',
                    icon: Icons.rule_folder_outlined,
                  )
                else
                  Column(
                    children: _items.asMap().entries.map((entry) {
                      final index = entry.key;
                      final item = entry.value;
                      final accentColor = item.isDone ? tokens.success : tokens.brand;

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: AppSurfaceCard(
                          color: accentColor.withValues(alpha: context.isDarkMode ? 0.14 : 0.08),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Icon(
                                    item.isDone ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
                                    color: accentColor,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(item.title, style: context.textTheme.titleMedium),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Text(
                                item.isDone
                                    ? 'Catatan: ${item.note}\nFoto: ${item.photoFileName}'
                                    : 'Belum ada bukti inspeksi yang diunggah untuk item ini.',
                                style: context.textTheme.bodyMedium?.copyWith(color: tokens.textMuted),
                              ),
                              const SizedBox(height: 14),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    child: FilledButton.icon(
                                      onPressed: () => _attachEvidence(index),
                                      icon: Icon(item.isDone ? Icons.camera_alt_outlined : Icons.add_a_photo_outlined),
                                      label: Text(item.isDone ? 'Ubah bukti' : 'Tambah bukti'),
                                    ),
                                  ),
                                  if (item.isDone) ...<Widget>[
                                    const SizedBox(width: 12),
                                    OutlinedButton(
                                      onPressed: () {
                                        setState(() {
                                          _items[index] = item.copyWith(
                                            isDone: false,
                                            note: '',
                                            photoFileName: '',
                                          );
                                        });
                                      },
                                      child: const Text('Reset'),
                                    ),
                                  ],
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                if (_items.isNotEmpty) ...<Widget>[
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: _submitInspection,
                      icon: const Icon(Icons.save_rounded),
                      label: const Text('Simpan checklist'),
                    ),
                  ),
                ],
              ],
            ),
    );
  }
}
