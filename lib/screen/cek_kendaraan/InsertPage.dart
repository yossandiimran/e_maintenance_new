import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import 'package:e_maintenance/app/app_theme.dart';
import 'package:e_maintenance/controllers/session_controller.dart';
import 'package:e_maintenance/helper/global.dart';
import 'package:e_maintenance/model/app_models.dart';
import 'package:e_maintenance/service/InputService.dart';
import 'package:e_maintenance/widget/Alert.dart';
import 'package:e_maintenance/widget/CustomWidget.dart';
import 'package:e_maintenance/widget/TextStyling.dart';

class InsertPage extends StatefulWidget {
  const InsertPage({super.key, required this.barcode});
  final String barcode;

  @override
  State<InsertPage> createState() => _InsertPageState();
}

class _InsertPageState extends State<InsertPage> {
  final ImagePicker _imagePicker = ImagePicker();

  VehicleInfo? _vehicleInfo;
  InspectionKind _selectedKind = InspectionKind.daily;
  List<ChecklistItem> _items = <ChecklistItem>[];
  bool _loadingVehicle = true;
  bool _loadingChecklist = false;
  bool _hideCompleted = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadVehicleInfo());
  }

  // ── Business logic (unchanged) ──
  Future<void> _loadVehicleInfo() async {
    final session = context.read<SessionController>().session;
    if (session == null) return;

    final result = await Alert.runWithLoading(
      context: context,
      message: 'Mengambil data kendaraan…',
      task: () => context.read<InputService>().fetchVehicleInfo(
            barcode: widget.barcode,
            session: session,
          ),
    );

    if (!mounted) return;

    if (!result.isSuccess || result.data == null) {
      await Alert.showMessage(
        context: context,
        title: 'Data kendaraan tidak tersedia',
        message: result.errorMessage ?? 'Kendaraan tidak berhasil ditemukan di backend.',
        isError: true,
      );
      if (mounted) Navigator.of(context).pop();
      return;
    }

    final vehicleInfo = result.data!;
    setState(() {
      _vehicleInfo = vehicleInfo;
      _loadingVehicle = false;
    });

    if (!mounted) return;
    final assetWerks = vehicleInfo.werks.trim();
    final userWerks = session.werks.trim();

    if (assetWerks.isNotEmpty && userWerks.isNotEmpty && assetWerks != userWerks) {
      await Alert.showMessage(
        context: context,
        title: 'Lokasi tidak sesuai',
        message:
            'Lokasi aset (WERKS: $assetWerks) tidak sesuai dengan lokasi user Anda ($userWerks). '
            'Harap pastikan kendaraan ini sesuai dengan penugasan Anda sebelum melanjutkan.',
        isError: true,
      );
    }

    if (mounted) _selectInspectionKind(_selectedKind);
  }

  Future<void> _selectInspectionKind(InspectionKind kind) async {
    if (_vehicleInfo == null) return;

    setState(() {
      _selectedKind = kind;
      _loadingChecklist = true;
    });

    final result = await context.read<InputService>().fetchChecklist(
          inspectionKind: kind,
          isForklift: _vehicleInfo!.isForklift,
        );

    if (!mounted) return;

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
      preferredCameraDevice: CameraDevice.rear,
      maxWidth: 1392,
      maxHeight: 1856,
      imageQuality: 30,
    );

    if (image == null || !mounted) return;

    final file = File(image.path);
    final note = await _askForNote(file, _items[index].note);
    if (note == null || note.trim().isEmpty || !mounted) return;

    final uploadResult = await Alert.runWithLoading(
      context: context,
      message: 'Mengunggah foto inspeksi…',
      task: () => context.read<InputService>().uploadPhoto(file),
    );

    if (!mounted) return;

    if (!uploadResult.isSuccess || uploadResult.data == null) {
      Alert.showErrorSnackBar(context, uploadResult.errorMessage ?? 'Foto gagal diunggah.');
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
                      borderRadius: BorderRadius.circular(16),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxHeight: 180),
                        child: Image.file(imageFile, width: 300, fit: BoxFit.cover),
                      ),
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: controller,
                      minLines: 3,
                      maxLines: 4,
                      decoration: InputDecoration(
                        labelText: 'Keterangan',
                        hintText: 'Contoh: Kondisi baik, baut aman.',
                        errorText: errorText,
                      ),
                    ),
                  ],
                ),
              ),
              actionsAlignment: MainAxisAlignment.center,
              actions: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(dialogContext).pop(),
                        child: const Text('Batal'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: FilledButton(
                        onPressed: () {
                          if (controller.text.trim().isEmpty) {
                            setStateDialog(() => errorText = 'Keterangan wajib diisi.');
                            return;
                          }
                          Navigator.of(dialogContext).pop(controller.text.trim());
                        },
                        child: const Text('Simpan'),
                      ),
                    ),
                  ],
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
    if (session == null || _vehicleInfo == null) return;

    if (_items.isEmpty) {
      Alert.showErrorSnackBar(context, 'Checklist inspeksi belum tersedia.');
      return;
    }

    final result = await Alert.runWithLoading(
      context: context,
      message: 'Menyimpan checklist inspeksi…',
      task: () => context.read<InputService>().submitInspection(
            items: _items,
            inspectionKind: _selectedKind,
            barcode: widget.barcode,
            vehicleName: _vehicleInfo!.materialDescription,
            userName: session.name,
            location: session.werks,
            inspectionDate: DateTime.now(),
          ),
    );

    if (!mounted) return;

    if (!result.isSuccess) {
      Alert.showErrorSnackBar(context, result.errorMessage ?? 'Checklist inspeksi gagal disimpan.');
      return;
    }

    Alert.showSuccessSnackBar(context, result.data ?? 'Checklist inspeksi berhasil disimpan.');
    Navigator.of(context).pop();
  }

  // ── UI ──
  @override
  Widget build(BuildContext context) {
    final session = context.watch<SessionController>().session;
    final tokens = context.tokens;
    final doneCount = _items.where((i) => i.isDone).length;
    final totalCount = _items.length;
    final progress = totalCount > 0 ? doneCount / totalCount : 0.0;
    final allDone = doneCount == totalCount && totalCount > 0;

    return AppPageScaffold(
      title: 'Pengecekan',
      subtitle: 'Input data kendaraan dan bukti lapangan.',
      actions: <Widget>[
        if (_items.isNotEmpty)
          IconButton(
            onPressed: allDone ? _submitInspection : null,
            icon: Icon(Icons.cloud_upload_rounded, color: allDone ? tokens.brand : tokens.textMuted),
          ),
      ],
      child: _loadingVehicle || session == null
          ? const SizedBox(height: 320, child: AppLoadingView())
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // ── Vehicle info ──
                AppStaggeredItem(
                  index: 0,
                  child: AppSurfaceCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: tokens.brand.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                _vehicleInfo!.isForklift
                                    ? Icons.local_shipping_rounded
                                    : Icons.directions_car_filled_rounded,
                                color: tokens.brand,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    _vehicleInfo!.materialDescription,
                                    style: context.textTheme.titleMedium,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    widget.barcode,
                                    style: context.textTheme.bodySmall?.copyWith(
                                      color: tokens.textMuted,
                                      fontFamily: 'monospace',
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            AppStatusChip(
                              label: _vehicleInfo!.isForklift ? 'Forklift' : 'Mobil',
                              icon: _vehicleInfo!.isForklift
                                  ? Icons.local_shipping_rounded
                                  : Icons.directions_car_filled_rounded,
                              color: tokens.accent,
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Divider(height: 1, color: tokens.borderSoft),
                        ),
                        Row(
                          children: <Widget>[
                            _InfoTile(icon: Icons.person_outline_rounded, label: 'PIC', value: session.name, tokens: tokens),
                            const SizedBox(width: 14),
                            _InfoTile(icon: Icons.location_on_outlined, label: 'Lokasi', value: session.werks, tokens: tokens),
                            const SizedBox(width: 14),
                            _InfoTile(
                              icon: Icons.calendar_today_outlined,
                              label: 'Tanggal',
                              value: AppDateUtils.formatDisplay(AppDateUtils.todayApiString()),
                              tokens: tokens,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // ── Inspection kind ──
                AppStaggeredItem(
                  index: 1,
                  child: DropdownButtonFormField<InspectionKind>(
                    value: _selectedKind,
                    decoration: InputDecoration(
                      labelText: 'Jenis pengecekan',
                      prefixIcon: Icon(Icons.fact_check_outlined, size: 20, color: tokens.brand),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    ),
                    items: InspectionKind.values
                        .map((kind) => DropdownMenuItem<InspectionKind>(value: kind, child: Text(kind.label)))
                        .toList(),
                    onChanged: (kind) {
                      if (kind != null && kind != _selectedKind) _selectInspectionKind(kind);
                    },
                  ),
                ),
                const SizedBox(height: 10),

                // ── Progress bar ──
                if (_items.isNotEmpty)
                  AppStaggeredItem(
                    index: 2,
                    child: _ProgressCard(
                      doneCount: doneCount,
                      totalCount: totalCount,
                      progress: progress,
                      allDone: allDone,
                      tokens: tokens,
                    ),
                  ),
                if (_items.isNotEmpty) const SizedBox(height: 12),

                // ── Checklist ──
                if (_loadingChecklist)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 40),
                    child: AppLoadingView(),
                  )
                else if (_items.isEmpty)
                  const AppEmptyState(
                    title: 'Checklist kosong',
                    message: 'Belum ada item inspeksi untuk jenis pengecekan ini.',
                    icon: Icons.rule_folder_outlined,
                  )
                else ...[
                  // ── Hide-completed toggle ──
                  if (doneCount > 0)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        children: <Widget>[
                          Icon(
                            _hideCompleted ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                            size: 15,
                            color: tokens.textMuted,
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              _hideCompleted
                                  ? '$doneCount item selesai disembunyikan'
                                  : 'Menampilkan semua item',
                              style: context.textTheme.bodySmall?.copyWith(color: tokens.textMuted),
                            ),
                          ),
                          SizedBox(
                            height: 30,
                            child: TextButton(
                              onPressed: () => setState(() => _hideCompleted = !_hideCompleted),
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                visualDensity: VisualDensity.compact,
                              ),
                              child: Text(
                                _hideCompleted ? 'Tampilkan' : 'Sembunyikan',
                                style: context.textTheme.labelSmall?.copyWith(
                                  color: tokens.brand,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                  // ── Checklist items (filter by _hideCompleted) ──
                  ..._items.asMap().entries
                      .where((entry) => !_hideCompleted || !entry.value.isDone)
                      .map((entry) {
                    final index = entry.key;
                    final item = entry.value;
                    return AppStaggeredItem(
                      index: 3 + index,
                      child: _ChecklistItemCard(
                        index: index,
                        item: item,
                        tokens: tokens,
                        onAttach: () => _attachEvidence(index),
                        onReset: () {
                          setState(() {
                            _items[index] = item.copyWith(isDone: false, note: '', photoFileName: '');
                          });
                        },
                      ),
                    );
                  }),
                ],

                // ── Submit ──
                if (_items.isNotEmpty) ...<Widget>[
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: FilledButton.icon(
                      onPressed: allDone ? _submitInspection : null,
                      icon: Icon(allDone ? Icons.cloud_upload_outlined : Icons.lock_outline_rounded, size: 18),
                      label: Text(allDone ? 'Simpan checklist' : 'Lengkapi semua item'),
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ],
            ),
    );
  }
}

// ── Progress card ──
class _ProgressCard extends StatelessWidget {
  const _ProgressCard({
    required this.doneCount,
    required this.totalCount,
    required this.progress,
    required this.allDone,
    required this.tokens,
  });

  final int doneCount;
  final int totalCount;
  final double progress;
  final bool allDone;
  final AppTokens tokens;

  @override
  Widget build(BuildContext context) {
    final color = allDone ? tokens.success : tokens.brand;
    return AppSurfaceCard(
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
      child: Row(
        children: <Widget>[
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              allDone ? Icons.check_circle_rounded : Icons.assignment_turned_in_outlined,
              size: 16,
              color: color,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Progres inspeksi',
                      style: context.textTheme.labelLarge?.copyWith(color: tokens.textSecondary),
                    ),
                    Text(
                      '$doneCount / $totalCount',
                      style: context.textTheme.labelMedium?.copyWith(
                        color: color,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: TweenAnimationBuilder<double>(
                    tween: Tween<double>(begin: 0, end: progress),
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeOutCubic,
                    builder: (context, value, _) => LinearProgressIndicator(
                      value: value,
                      minHeight: 5,
                      backgroundColor: tokens.borderSoft,
                      valueColor: AlwaysStoppedAnimation<Color>(color),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Info tile ──
class _InfoTile extends StatelessWidget {
  const _InfoTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.tokens,
  });

  final IconData icon;
  final String label;
  final String value;
  final AppTokens tokens;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        children: <Widget>[
          Icon(icon, size: 13, color: tokens.textMuted),
          const SizedBox(width: 5),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(label, style: context.textTheme.labelSmall?.copyWith(color: tokens.textMuted)),
                Text(
                  value,
                  style: context.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600, fontSize: 12),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Checklist item card ──
class _ChecklistItemCard extends StatelessWidget {
  const _ChecklistItemCard({
    required this.index,
    required this.item,
    required this.tokens,
    required this.onAttach,
    required this.onReset,
  });

  final int index;
  final ChecklistItem item;
  final AppTokens tokens;
  final VoidCallback onAttach;
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    final isDone = item.isDone;
    final accentColor = isDone ? tokens.success : tokens.brand;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: AppSurfaceCard(
        padding: EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Accent bar
            Container(
              height: 3,
              decoration: BoxDecoration(
                color: accentColor.withValues(alpha: isDone ? 0.65 : 0.2),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 10, 14, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // Title row
                  Row(
                    children: <Widget>[
                      Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: accentColor.withValues(alpha: context.isDarkMode ? 0.18 : 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        alignment: Alignment.center,
                        child: isDone
                            ? Icon(Icons.check_rounded, size: 15, color: accentColor)
                            : Text(
                                '${index + 1}',
                                style: context.textTheme.labelMedium?.copyWith(
                                  color: accentColor,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          item.title,
                          style: context.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            decoration: isDone ? TextDecoration.lineThrough : null,
                            color: isDone ? tokens.textMuted : null,
                          ),
                        ),
                      ),
                      if (isDone)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: tokens.success.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            '✓ Selesai',
                            style: context.textTheme.labelSmall?.copyWith(
                              color: tokens.success,
                              fontWeight: FontWeight.w700,
                              fontSize: 10,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Note / status
                  if (isDone)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: tokens.success.withValues(alpha: context.isDarkMode ? 0.06 : 0.04),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: tokens.success.withValues(alpha: 0.1)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Icon(Icons.notes_rounded, size: 13, color: tokens.textMuted),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  item.note,
                                  style: context.textTheme.bodySmall?.copyWith(color: tokens.textSecondary),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 3),
                          Row(
                            children: <Widget>[
                              Icon(Icons.image_outlined, size: 13, color: tokens.textMuted),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  item.photoFileName,
                                  style: context.textTheme.bodySmall?.copyWith(
                                    color: tokens.textMuted,
                                    fontFamily: 'monospace',
                                    fontSize: 10,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  else
                    Row(
                      children: <Widget>[
                        Icon(Icons.info_outline_rounded, size: 13, color: tokens.textMuted),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            'Belum ada bukti inspeksi.',
                            style: context.textTheme.bodySmall?.copyWith(color: tokens.textMuted),
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(height: 10),

                  // Actions
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: SizedBox(
                          height: 34,
                          child: isDone
                              ? OutlinedButton.icon(
                                  onPressed: onAttach,
                                  icon: const Icon(Icons.camera_alt_outlined, size: 14),
                                  style: OutlinedButton.styleFrom(
                                    textStyle: context.textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w700),
                                    padding: const EdgeInsets.symmetric(horizontal: 10),
                                  ),
                                  label: const Text('Ubah bukti'),
                                )
                              : FilledButton.icon(
                                  onPressed: onAttach,
                                  icon: const Icon(Icons.add_a_photo_outlined, size: 14),
                                  style: FilledButton.styleFrom(
                                    textStyle: context.textTheme.labelSmall?.copyWith(
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                    padding: const EdgeInsets.symmetric(horizontal: 10),
                                  ),
                                  label: const Text('Tambah bukti'),
                                ),
                        ),
                      ),
                      if (isDone) ...<Widget>[
                        const SizedBox(width: 8),
                        SizedBox(
                          height: 34,
                          child: TextButton(
                            onPressed: onReset,
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                            ),
                            child: Text(
                              'Reset',
                              style: context.textTheme.labelSmall?.copyWith(
                                color: tokens.danger,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
