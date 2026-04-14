import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:e_maintenance/controllers/session_controller.dart';
import 'package:e_maintenance/helper/global.dart';
import 'package:e_maintenance/model/app_models.dart';
import 'package:e_maintenance/screen/laporan/excel/ExcelReportUse.dart';
import 'package:e_maintenance/service/ReportService.dart';
import 'package:e_maintenance/widget/Alert.dart';
import 'package:e_maintenance/widget/CustomWidget.dart';
import 'package:e_maintenance/widget/TextStyling.dart';

class Laporan2 extends StatefulWidget {
  const Laporan2({super.key});

  @override
  State<Laporan2> createState() => _Laporan2State();
}

class _Laporan2State extends State<Laporan2> {
  final _locationController = TextEditingController();
  final _startDateController = TextEditingController();
  final _endDateController = TextEditingController();

  InspectionKind _inspectionKind = InspectionKind.daily;
  List<UserReportEntry> _items = <UserReportEntry>[];
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final currentSession = context.read<SessionController>().session;
      _locationController.text = currentSession?.werks ?? '';
      setState(() {});
    });
  }

  @override
  void dispose() {
    _locationController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    super.dispose();
  }

  Future<void> _pickDate(TextEditingController controller) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2018),
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      controller.text = AppDateUtils.formatApi(picked);
    }
  }

  Future<void> _search() async {
    if (_locationController.text.trim().isEmpty ||
        _startDateController.text.isEmpty ||
        _endDateController.text.isEmpty) {
      Alert.showErrorSnackBar(context, 'Lokasi dan periode tanggal wajib diisi.');
      return;
    }

    setState(() => _loading = true);
    final result = await context.read<ReportService>().fetchUserReport(
          UserReportQuery(
            location: _locationController.text.trim(),
            inspectionKind: _inspectionKind,
            startDate: _startDateController.text,
            endDate: _endDateController.text,
          ),
        );

    if (!mounted) {
      return;
    }

    if (!result.isSuccess || result.data == null) {
      setState(() => _loading = false);
      Alert.showErrorSnackBar(context, result.errorMessage ?? 'Laporan user gagal dimuat.');
      return;
    }

    setState(() {
      _items = result.data!..sort((a, b) => a.name.compareTo(b.name));
      _loading = false;
    });
  }

  Future<void> _export() async {
    if (_items.isEmpty) {
      Alert.showErrorSnackBar(context, 'Tidak ada data user untuk diekspor.');
      return;
    }

    final result = await Alert.runWithLoading(
      context: context,
      message: 'Membuat file Excel...',
      task: () => ExcelReportUser().exportUserReport(
        data: _items,
        query: UserReportQuery(
          location: _locationController.text.trim(),
          inspectionKind: _inspectionKind,
          startDate: _startDateController.text,
          endDate: _endDateController.text,
        ),
      ),
    );

    if (!mounted) {
      return;
    }

    if (!result.isSuccess) {
      Alert.showErrorSnackBar(context, result.errorMessage ?? 'Ekspor Excel gagal.');
      return;
    }

    Alert.showSuccessSnackBar(context, 'File tersimpan di ${result.data}');
  }

  @override
  Widget build(BuildContext context) {
    return AppPageScaffold(
      title: 'Laporan user',
      subtitle: 'Pantau aktivitas user lapangan dan cek tanggal mana yang belum dijalankan.',
      actions: <Widget>[
        IconButton(
          onPressed: _items.isEmpty ? null : _export,
          icon: const Icon(Icons.download_rounded),
        ),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          AppSurfaceCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Filter laporan', style: context.textTheme.titleLarge),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _locationController,
                  textCapitalization: TextCapitalization.characters,
                  decoration: const InputDecoration(
                    labelText: 'Lokasi',
                    prefixIcon: Icon(Icons.location_on_outlined),
                  ),
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<InspectionKind>(
                  value: _inspectionKind,
                  isExpanded: true,
                  decoration: const InputDecoration(
                    labelText: 'Jenis pengecekan',
                    prefixIcon: Icon(Icons.fact_check_outlined),
                  ),
                  items: InspectionKind.values
                      .map((item) => DropdownMenuItem<InspectionKind>(value: item, child: Text(item.label)))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _inspectionKind = value);
                    }
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _startDateController,
                  readOnly: true,
                  onTap: () => _pickDate(_startDateController),
                  decoration: const InputDecoration(
                    labelText: 'Tanggal awal',
                    prefixIcon: Icon(Icons.date_range_outlined),
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _endDateController,
                  readOnly: true,
                  onTap: () => _pickDate(_endDateController),
                  decoration: const InputDecoration(
                    labelText: 'Tanggal akhir',
                    prefixIcon: Icon(Icons.event_note_outlined),
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: _search,
                        icon: const Icon(Icons.search_rounded),
                        label: const Text('Cari data'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    OutlinedButton.icon(
                      onPressed: _export,
                      icon: const Icon(Icons.file_download_outlined),
                      label: const Text('Excel'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          if (_loading)
            const SizedBox(height: 220, child: AppLoadingView())
          else if (_items.isEmpty)
            const AppEmptyState(
              title: 'Belum ada data',
              message: 'Jalankan pencarian untuk melihat siapa saja yang sudah atau belum melakukan pengecekan.',
              icon: Icons.group_outlined,
            )
          else
            Column(
              children: _items.map((entry) {
                final allDates = AppDateUtils.buildDateRange(_startDateController.text, _endDateController.text);
                final missingDates = allDates.where((date) => !entry.performedDates.contains(date)).toList();

                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: AppSurfaceCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(entry.name, style: context.textTheme.titleLarge),
                        const SizedBox(height: 6),
                        Text(
                          'Lokasi ${entry.location}  •  Dilakukan ${entry.performedDates.length} kali',
                          style: context.textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 14),
                        if (missingDates.isEmpty)
                          const AppStatusChip(
                            label: 'Semua tanggal terisi',
                            icon: Icons.check_circle_outline_rounded,
                          )
                        else
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: missingDates
                                .map(
                                  (date) => AppStatusChip(
                                    label: AppDateUtils.formatDisplay(date),
                                    icon: Icons.event_busy_outlined,
                                  ),
                                )
                                .toList(),
                          ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }
}
