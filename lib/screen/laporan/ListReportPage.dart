import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

class _ListReportPageState extends State<ListReportPage> {
  bool _loading = true;
  List<TransactionReportItem> _items = <TransactionReportItem>[];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadData());
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
        return AlertDialog(
          title: Text(item.title),
          content: ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Image.network(url, fit: BoxFit.cover),
          ),
          actions: <Widget>[
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Tutup'),
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

    return AppPageScaffold(
      title: 'Detail laporan',
      subtitle: 'Data checklist disusun per tanggal dan serial kendaraan agar lebih mudah dipindai.',
      actions: <Widget>[
        IconButton(
          onPressed: _items.isEmpty ? null : _export,
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
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: grouped.entries.map((dateEntry) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: AppSurfaceCard(
                        child: Theme(
                          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                          child: ExpansionTile(
                            tilePadding: EdgeInsets.zero,
                            childrenPadding: EdgeInsets.zero,
                            initiallyExpanded: true,
                            title: Text(
                              AppDateUtils.formatDisplay(dateEntry.key),
                              style: context.textTheme.titleLarge,
                            ),
                            subtitle: Text(
                              '${dateEntry.value.length} kendaraan tercatat',
                              style: context.textTheme.bodyMedium?.copyWith(color: tokens.textMuted),
                            ),
                            children: dateEntry.value.entries.map((vehicleEntry) {
                              final first = vehicleEntry.value.first;
                              return Padding(
                                padding: const EdgeInsets.only(top: 12),
                                child: AppSurfaceCard(
                                  color: tokens.surfaceElevated.withValues(alpha: context.isDarkMode ? 0.72 : 0.94),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(first.vehicleName, style: context.textTheme.titleLarge),
                                      const SizedBox(height: 6),
                                      Text(
                                        'SN: ${first.serialNumber}  •  PIC: ${first.userName}  •  Lokasi: ${first.location}',
                                        style: context.textTheme.bodyMedium?.copyWith(color: tokens.textMuted),
                                      ),
                                      const SizedBox(height: 14),
                                      ...vehicleEntry.value.map((item) {
                                        return Padding(
                                          padding: const EdgeInsets.only(bottom: 10),
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Icon(
                                                item.isDone ? Icons.check_circle_rounded : Icons.cancel_outlined,
                                                color: item.isDone ? tokens.success : tokens.danger,
                                              ),
                                              const SizedBox(width: 12),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Text(item.title, style: context.textTheme.titleMedium),
                                                    const SizedBox(height: 4),
                                                    Text(
                                                      item.isDone ? 'Checklist dilakukan.' : 'Checklist belum dilakukan.',
                                                      style: context.textTheme.bodyMedium?.copyWith(color: tokens.textMuted),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              IconButton(
                                                onPressed: () => _showImage(item),
                                                icon: Icon(
                                                  item.photoFileName.isNotEmpty && item.photoFileName != 'null'
                                                      ? Icons.image_outlined
                                                      : Icons.broken_image_outlined,
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      }),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
    );
  }
}
