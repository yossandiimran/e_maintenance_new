import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:e_maintenance/app/app_theme.dart';
import 'package:e_maintenance/core/network/app_api_client.dart';
import 'package:e_maintenance/helper/global.dart';
import 'package:e_maintenance/model/app_models.dart';
import 'package:e_maintenance/screen/laporan/excel/ExcelReportTransaksi.dart';
import 'package:e_maintenance/service/ReportService.dart';
import 'package:e_maintenance/widget/Alert.dart';
import 'package:e_maintenance/widget/CustomWidget.dart';
import 'package:e_maintenance/widget/TextStyling.dart';

class ListReportPage extends StatefulWidget {
  const ListReportPage({
    super.key,
    required this.filter,
  });

  final TransactionReportFilter filter;

  @override
  State<ListReportPage> createState() => _ListReportPageState();
}

class _ListReportPageState extends State<ListReportPage>
    with SingleTickerProviderStateMixin {
  bool _loading = true;
  List<TransactionReportItem> _items = <TransactionReportItem>[];

  late final AnimationController _animCtrl;
  late final Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(vsync: this, duration: AppMotion.slow);
    _fadeAnim = CurvedAnimation(parent: _animCtrl, curve: AppMotion.standard);
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadData());
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    final result = await context.read<ReportService>().fetchTransactionReport(widget.filter);
    if (!mounted) {
      return;
    }

    if (!result.isSuccess || result.data == null) {
      setState(() => _loading = false);
      Alert.showErrorSnackBar(context, result.errorMessage ?? 'Laporan transaksi gagal dimuat.');
      return;
    }

    setState(() {
      _items = result.data!;
      _loading = false;
    });
    _animCtrl.forward();
  }

  Future<void> _export() async {
    if (_items.isEmpty) {
      Alert.showErrorSnackBar(context, 'Tidak ada data untuk diekspor.');
      return;
    }

    final result = await Alert.runWithLoading(
      context: context,
      message: 'Membuat file Excel...',
      task: () => ExcelReportTransaksi().exportTransaksiReport(
        data: _items,
        filter: widget.filter,
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

  Future<void> _showImage(TransactionReportItem item) async {
    if (item.photoFileName.isEmpty || item.photoFileName == 'null') {
      Alert.showErrorSnackBar(context, 'Foto checklist tidak tersedia untuk item ini.');
      return;
    }

    final url = context.read<AppApiClient>().photoUrl('photo/${item.photoFileName}');
    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        final tokens = dialogContext.tokens;
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
          titlePadding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
          contentPadding: const EdgeInsets.fromLTRB(20, 0, 20, 4),
          actionsPadding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
          title: Row(
            children: <Widget>[
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: tokens.brand.withValues(alpha: dialogContext.isDarkMode ? 0.22 : 0.10),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.photo_library_rounded, color: tokens.brand, size: 18),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  item.title,
                  style: dialogContext.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          content: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.network(url, fit: BoxFit.cover),
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: <Widget>[
            FilledButton.icon(
              onPressed: () => Navigator.of(dialogContext).pop(),
              icon: const Icon(Icons.close_rounded, size: 18),
              label: const Text('Tutup'),
            ),
          ],
        );
      },
    );
  }

  Map<String, Map<String, List<TransactionReportItem>>> _groupedItems() {
    final grouped = <String, Map<String, List<TransactionReportItem>>>{};

    for (final item in _items) {
      grouped.putIfAbsent(item.date, () => <String, List<TransactionReportItem>>{});
      grouped[item.date]!.putIfAbsent(item.serialNumber, () => <TransactionReportItem>[]);
      grouped[item.date]![item.serialNumber]!.add(item);
    }

    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final grouped = _groupedItems();
    final totalVehicles = grouped.values.fold<int>(0, (sum, v) => sum + v.length);

    return AppPageScaffold(
      title: 'Detail laporan',
      subtitle: 'Data checklist disusun per tanggal dan serial kendaraan.',
      actions: <Widget>[
        IconButton(
          onPressed: _items.isEmpty ? null : _export,
          tooltip: 'Ekspor Excel',
          icon: const Icon(Icons.download_rounded),
        ),
      ],
      child: _loading
          ? const SizedBox(height: 320, child: AppLoadingView())
          : _items.isEmpty
              ? const AppEmptyState(
                  title: 'Laporan kosong',
                  message: 'Tidak ada data transaksi inspeksi pada filter yang dipilih.',
                  icon: Icons.description_outlined,
                )
              : FadeTransition(
                  opacity: _fadeAnim,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      // ── summary bar ──
                      AppStaggeredItem(
                        index: 0,
                        child: Row(
                          children: <Widget>[
                            _SummaryChip(
                              icon: Icons.calendar_today_rounded,
                              label: '${grouped.length} tanggal',
                              color: tokens.brand,
                              tokens: tokens,
                              isDark: context.isDarkMode,
                            ),
                            const SizedBox(width: 8),
                            _SummaryChip(
                              icon: Icons.directions_car_rounded,
                              label: '$totalVehicles kendaraan',
                              color: tokens.accent,
                              tokens: tokens,
                              isDark: context.isDarkMode,
                            ),
                            const SizedBox(width: 8),
                            _SummaryChip(
                              icon: Icons.checklist_rounded,
                              label: '${_items.length} item',
                              color: tokens.success,
                              tokens: tokens,
                              isDark: context.isDarkMode,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),

                      // ── grouped list ──
                      ...grouped.entries.toList().asMap().entries.map((mapEntry) {
                        final groupIndex = mapEntry.key;
                        final dateEntry = mapEntry.value;
                        final dateKey = dateEntry.key;
                        final vehicles = dateEntry.value;

                      return AppStaggeredItem(
                        index: groupIndex + 1,
                        child: Padding(
                        padding: const EdgeInsets.only(bottom: 14),
                        child: AppSurfaceCard(
                          padding: const EdgeInsets.all(0),
                          child: Theme(
                            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                            child: ExpansionTile(
                              tilePadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                              childrenPadding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
                              initiallyExpanded: grouped.keys.first == dateKey,
                              leading: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: tokens.brand.withValues(alpha: context.isDarkMode ? 0.22 : 0.10),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(Icons.event_note_rounded, color: tokens.brand, size: 20),
                              ),
                              title: Text(
                                AppDateUtils.formatDisplay(dateKey),
                                style: context.textTheme.titleLarge,
                              ),
                              subtitle: Text(
                                '${vehicles.length} kendaraan  •  ${vehicles.values.fold<int>(0, (s, v) => s + v.length)} checklist',
                                style: context.textTheme.bodySmall?.copyWith(color: tokens.textMuted),
                              ),
                              children: vehicles.entries.map((vehicleEntry) {
                                final first = vehicleEntry.value.first;
                                final doneCount = vehicleEntry.value.where((i) => i.isDone).length;
                                final total = vehicleEntry.value.length;
                                final allDone = doneCount == total;

                                return Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: tokens.surfaceElevated.withValues(alpha: context.isDarkMode ? 0.65 : 0.92),
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(color: tokens.borderSoft),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        // ── vehicle header ──
                                        Container(
                                          padding: const EdgeInsets.fromLTRB(12, 10, 12, 8),
                                          decoration: BoxDecoration(
                                            color: (allDone ? tokens.success : tokens.warning).withValues(alpha: context.isDarkMode ? 0.12 : 0.06),
                                            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                                          ),
                                          child: Row(
                                            children: <Widget>[
                                              Container(
                                                width: 36,
                                                height: 36,
                                                decoration: BoxDecoration(
                                                  color: (allDone ? tokens.success : tokens.warning).withValues(alpha: 0.16),
                                                  borderRadius: BorderRadius.circular(10),
                                                ),
                                                child: Icon(
                                                  allDone ? Icons.verified_rounded : Icons.pending_rounded,
                                                  size: 18,
                                                  color: allDone ? tokens.success : tokens.warning,
                                                ),
                                              ),
                                              const SizedBox(width: 10),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Text(
                                                      first.vehicleName,
                                                      style: context.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                    const SizedBox(height: 2),
                                                    Text(
                                                      '${first.userName}  •  ${first.location}',
                                                      style: context.textTheme.bodySmall?.copyWith(color: tokens.textMuted),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              // ── progress badge ──
                                              Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                                decoration: BoxDecoration(
                                                  color: (allDone ? tokens.success : tokens.warning).withValues(alpha: 0.14),
                                                  borderRadius: BorderRadius.circular(8),
                                                ),
                                                child: Text(
                                                  '$doneCount/$total',
                                                  style: context.textTheme.labelSmall?.copyWith(
                                                    color: allDone ? tokens.success : tokens.warning,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),

                                        // ── progress bar ──
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 12),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(4),
                                            child: LinearProgressIndicator(
                                              value: total > 0 ? doneCount / total : 0,
                                              minHeight: 3,
                                              backgroundColor: tokens.borderSoft,
                                              valueColor: AlwaysStoppedAnimation<Color>(
                                                allDone ? tokens.success : tokens.warning,
                                              ),
                                            ),
                                          ),
                                        ),

                                        // ── checklist items ──
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(6, 6, 6, 6),
                                          child: Column(
                                            children: vehicleEntry.value.map((item) {
                                              final hasPhoto = item.photoFileName.isNotEmpty && item.photoFileName != 'null';
                                              return InkWell(
                                                onTap: hasPhoto ? () => _showImage(item) : null,
                                                borderRadius: BorderRadius.circular(10),
                                                child: Padding(
                                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 7),
                                                  child: Row(
                                                    children: <Widget>[
                                                      Container(
                                                        width: 28,
                                                        height: 28,
                                                        decoration: BoxDecoration(
                                                          color: (item.isDone ? tokens.success : tokens.danger).withValues(alpha: 0.12),
                                                          borderRadius: BorderRadius.circular(8),
                                                        ),
                                                        child: Icon(
                                                          item.isDone ? Icons.check_rounded : Icons.close_rounded,
                                                          size: 16,
                                                          color: item.isDone ? tokens.success : tokens.danger,
                                                        ),
                                                      ),
                                                      const SizedBox(width: 10),
                                                      Expanded(
                                                        child: Text(
                                                          item.title,
                                                          style: context.textTheme.bodyMedium?.copyWith(
                                                            decoration: item.isDone ? null : TextDecoration.lineThrough,
                                                            color: item.isDone ? tokens.textPrimary : tokens.textMuted,
                                                          ),
                                                        ),
                                                      ),
                                                      if (hasPhoto)
                                                        Icon(Icons.photo_library_outlined, size: 16, color: tokens.textMuted),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            }).toList(),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                        ),
                      );
                    }),
                  ],
                  ),
                ),
    );
  }
}

// ── small summary chip for the top bar ──
class _SummaryChip extends StatelessWidget {
  const _SummaryChip({
    required this.icon,
    required this.label,
    required this.color,
    required this.tokens,
    required this.isDark,
  });

  final IconData icon;
  final String label;
  final Color color;
  final AppTokens tokens;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: 0.92, end: 1.0),
        duration: AppMotion.normal,
        curve: AppMotion.enter,
        builder: (context, scale, child) => Transform.scale(scale: scale, child: child),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: color.withValues(alpha: isDark ? 0.16 : 0.08),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withValues(alpha: 0.18)),
          ),
          child: Column(
            children: <Widget>[
              Icon(icon, size: 18, color: color),
              const SizedBox(height: 4),
              Text(
                label,
                style: context.textTheme.labelSmall?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
