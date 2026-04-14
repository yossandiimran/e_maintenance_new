import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:e_maintenance/app/app_theme.dart';
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

  Widget _buildResultTable(BuildContext context) {
    final tokens = context.tokens;
    final allDates = AppDateUtils.buildDateRange(_startDateController.text, _endDateController.text);

    return AppSurfaceCard(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
                const SizedBox(width: 34),
                Expanded(
                  flex: 4,
                  child: Text(
                    'Nama',
                    style: context.textTheme.labelMedium?.copyWith(
                      color: tokens.textMuted,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'Cek',
                    textAlign: TextAlign.center,
                    style: context.textTheme.labelMedium?.copyWith(
                      color: tokens.textMuted,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'Bolos',
                    textAlign: TextAlign.center,
                    style: context.textTheme.labelMedium?.copyWith(
                      color: tokens.textMuted,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(width: 28),
              ],
            ),
          ),
          Divider(height: 1, color: tokens.borderSoft),

          // ── rows ──
          ...List.generate(_items.length, (index) {
            final entry = _items[index];
            final missingDates = allDates.where((d) => !entry.performedDates.contains(d)).toList();
            final isComplete = missingDates.isEmpty;
            final doneCount = entry.performedDates.length;
            final missCount = missingDates.length;

            return Column(
              children: <Widget>[
                _UserReportRow(
                  index: index,
                  entry: entry,
                  doneCount: doneCount,
                  missCount: missCount,
                  isComplete: isComplete,
                  missingDates: missingDates,
                  tokens: tokens,
                ),
                if (index < _items.length - 1) Divider(height: 1, indent: 14, endIndent: 14, color: tokens.borderSoft),
              ],
            );
          }),
        ],
      ),
    );
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
            _buildResultTable(context),
        ],
      ),
    );
  }
}

// ── Expandable row widget for user report table ──
class _UserReportRow extends StatefulWidget {
  const _UserReportRow({
    required this.index,
    required this.entry,
    required this.doneCount,
    required this.missCount,
    required this.isComplete,
    required this.missingDates,
    required this.tokens,
  });

  final int index;
  final UserReportEntry entry;
  final int doneCount;
  final int missCount;
  final bool isComplete;
  final List<String> missingDates;
  final AppTokens tokens;

  @override
  State<_UserReportRow> createState() => _UserReportRowState();
}

class _UserReportRowState extends State<_UserReportRow> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final tokens = widget.tokens;
    final entry = widget.entry;

    return Column(
      children: <Widget>[
        InkWell(
          onTap: widget.missingDates.isNotEmpty ? () => setState(() => _expanded = !_expanded) : null,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Row(
              children: <Widget>[
                // ── number badge ──
                Container(
                  width: 26,
                  height: 26,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: (widget.isComplete ? tokens.success : tokens.warning).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${widget.index + 1}',
                    style: context.textTheme.labelSmall?.copyWith(
                      color: widget.isComplete ? tokens.success : tokens.warning,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(width: 8),

                // ── name + location ──
                Expanded(
                  flex: 4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        entry.name,
                        style: context.textTheme.titleMedium,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        entry.location,
                        style: context.textTheme.labelSmall?.copyWith(color: tokens.textMuted),
                      ),
                    ],
                  ),
                ),

                // ── done count ──
                Expanded(
                  flex: 2,
                  child: Text(
                    '${widget.doneCount}',
                    textAlign: TextAlign.center,
                    style: context.textTheme.titleMedium?.copyWith(
                      color: tokens.success,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),

                // ── miss count ──
                Expanded(
                  flex: 2,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: widget.missCount > 0
                        ? BoxDecoration(
                            color: tokens.danger.withValues(alpha: 0.10),
                            borderRadius: BorderRadius.circular(6),
                          )
                        : null,
                    child: Text(
                      widget.missCount > 0 ? '${widget.missCount}' : '—',
                      textAlign: TextAlign.center,
                      style: context.textTheme.titleMedium?.copyWith(
                        color: widget.missCount > 0 ? tokens.danger : tokens.textMuted,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),

                // ── expand chevron ──
                SizedBox(
                  width: 28,
                  child: widget.missingDates.isNotEmpty
                      ? Icon(
                          _expanded ? Icons.expand_less_rounded : Icons.expand_more_rounded,
                          size: 18,
                          color: tokens.textMuted,
                        )
                      : Icon(Icons.check_rounded, size: 16, color: tokens.success),
                ),
              ],
            ),
          ),
        ),

        // ── expanded missing dates ──
        if (_expanded && widget.missingDates.isNotEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(48, 0, 14, 10),
            child: Wrap(
              spacing: 6,
              runSpacing: 6,
              children: widget.missingDates
                  .map(
                    (date) => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: tokens.danger.withValues(alpha: context.isDarkMode ? 0.18 : 0.08),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: tokens.danger.withValues(alpha: 0.15)),
                      ),
                      child: Text(
                        AppDateUtils.formatDisplay(date),
                        style: context.textTheme.labelSmall?.copyWith(
                          color: tokens.danger,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
      ],
    );
  }
}
