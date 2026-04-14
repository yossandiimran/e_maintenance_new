import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:e_maintenance/controllers/session_controller.dart';
import 'package:e_maintenance/helper/global.dart';
import 'package:e_maintenance/model/app_models.dart';
import 'package:e_maintenance/route.dart';
import 'package:e_maintenance/service/ReportService.dart';
import 'package:e_maintenance/widget/Alert.dart';
import 'package:e_maintenance/widget/CustomWidget.dart';
import 'package:e_maintenance/widget/TextStyling.dart';

class Laporan1 extends StatefulWidget {
  const Laporan1({super.key});

  @override
  State<Laporan1> createState() => _Laporan1State();
}

class _Laporan1State extends State<Laporan1> {
  final _startDateController = TextEditingController();
  final _endDateController = TextEditingController();

  InspectionKind _inspectionKind = InspectionKind.daily;
  VehicleType _vehicleType = VehicleType.car;
  List<StorageLocation> _locations = <StorageLocation>[];
  List<VehicleCatalogItem> _vehicles = <VehicleCatalogItem>[];
  StorageLocation? _selectedLocation;
  VehicleCatalogItem? _selectedVehicle;
  bool _loadingLocations = true;
  bool _loadingVehicles = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadLocations());
  }

  @override
  void dispose() {
    _startDateController.dispose();
    _endDateController.dispose();
    super.dispose();
  }

  Future<void> _loadLocations() async {
    final session = context.read<SessionController>().session;
    if (session == null) return;

    final result = await context.read<ReportService>().fetchStorageLocations(session);
    if (!mounted) return;

    if (!result.isSuccess || result.data == null) {
      setState(() => _loadingLocations = false);
      Alert.showErrorSnackBar(context, result.errorMessage ?? 'Lokasi aset gagal dimuat.');
      return;
    }

    setState(() {
      _locations = result.data!;
      _selectedLocation = _locations.isNotEmpty ? _locations.first : null;
      _loadingLocations = false;
    });

    if (_selectedLocation != null) await _loadVehicles(_selectedLocation!);
  }

  Future<void> _loadVehicles(StorageLocation location) async {
    final session = context.read<SessionController>().session;
    if (session == null) return;

    setState(() {
      _loadingVehicles = true;
      _selectedVehicle = null;
      _vehicles = <VehicleCatalogItem>[];
    });

    final result = await context.read<ReportService>().fetchVehicles(
          session: session,
          location: location.code,
        );

    if (!mounted) return;

    if (!result.isSuccess || result.data == null) {
      setState(() => _loadingVehicles = false);
      Alert.showErrorSnackBar(context, result.errorMessage ?? 'Daftar kendaraan gagal dimuat.');
      return;
    }

    setState(() {
      _vehicles = result.data!;
      _loadingVehicles = false;
    });
  }

  Future<void> _pickDate(TextEditingController controller) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2018),
      lastDate: DateTime(2101),
    );
    if (picked == null) return;
    controller.text = AppDateUtils.formatApi(picked);
  }

  void _openReport() {
    if (_selectedLocation == null) {
      Alert.showErrorSnackBar(context, 'Lokasi aset wajib dipilih.');
      return;
    }
    if (_startDateController.text.isEmpty || _endDateController.text.isEmpty) {
      Alert.showErrorSnackBar(context, 'Periode tanggal wajib diisi.');
      return;
    }

    final session = context.read<SessionController>().session;

    Navigator.of(context).push(
      AppRouter.transactionReportList(
        TransactionReportFilter(
          inspectionKind: _inspectionKind,
          vehicleType: _vehicleType,
          werks: session?.werks ?? '',
          storageLocation: _selectedLocation!.code,
          vehicleSerialNumber: _selectedVehicle == null ? '' : AppHelpers.serialForReport(_selectedVehicle!.serialNumber),
          startDate: _startDateController.text,
          endDate: _endDateController.text,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    return AppPageScaffold(
      title: 'Laporan transaksi',
      subtitle: 'Filter histori inspeksi kendaraan.',
      child: _loadingLocations
          ? const SizedBox(height: 320, child: AppLoadingView())
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                AppStaggeredItem(
                  index: 0,
                  child: AppSurfaceCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: tokens.brand.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(Icons.filter_alt_outlined, size: 18, color: tokens.brand),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text('Filter laporan', style: context.textTheme.titleMedium),
                                  Text(
                                    'Pilih parameter untuk menampilkan data.',
                                    style: context.textTheme.bodySmall?.copyWith(color: tokens.textMuted),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),

                        // Jenis pengecekan
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
                            if (value != null) setState(() => _inspectionKind = value);
                          },
                        ),
                        const SizedBox(height: 10),

                        // Jenis kendaraan
                        DropdownButtonFormField<VehicleType>(
                          value: _vehicleType,
                          isExpanded: true,
                          decoration: const InputDecoration(
                            labelText: 'Jenis kendaraan',
                            prefixIcon: Icon(Icons.directions_car_outlined),
                          ),
                          items: VehicleType.values
                              .map((item) => DropdownMenuItem<VehicleType>(value: item, child: Text(item.label)))
                              .toList(),
                          onChanged: (value) {
                            if (value != null) setState(() => _vehicleType = value);
                          },
                        ),
                        const SizedBox(height: 12),

                        // ── Lokasi & Kendaraan group ──
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: tokens.surfaceMuted.withValues(alpha: context.isDarkMode ? 0.3 : 0.45),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: tokens.borderSoft.withValues(alpha: 0.6)),
                          ),
                          child: Column(
                            children: <Widget>[
                              DropdownButtonFormField<StorageLocation>(
                                value: _selectedLocation,
                                isExpanded: true,
                                decoration: const InputDecoration(
                                  labelText: 'Lokasi aset',
                                  prefixIcon: Icon(Icons.location_on_outlined),
                                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                ),
                                selectedItemBuilder: (context) {
                                  return _locations.map((item) {
                                    return Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text('${item.code}  —  ${item.name}', overflow: TextOverflow.ellipsis),
                                    );
                                  }).toList();
                                },
                                items: _locations
                                    .map((item) => DropdownMenuItem<StorageLocation>(
                                          value: item,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 2),
                                            child: Row(
                                              children: <Widget>[
                                                Container(
                                                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                                                  decoration: BoxDecoration(
                                                    color: tokens.brand.withValues(alpha: 0.1),
                                                    borderRadius: BorderRadius.circular(6),
                                                  ),
                                                  child: Text(
                                                    item.code,
                                                    style: context.textTheme.labelMedium?.copyWith(
                                                      color: tokens.brand,
                                                      fontWeight: FontWeight.w700,
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 10),
                                                Expanded(child: Text(item.name, overflow: TextOverflow.ellipsis, style: context.textTheme.bodyMedium)),
                                              ],
                                            ),
                                          ),
                                        ))
                                    .toList(),
                                onChanged: (value) {
                                  if (value == null) return;
                                  setState(() => _selectedLocation = value);
                                  _loadVehicles(value);
                                },
                              ),
                              const SizedBox(height: 10),
                              DropdownButtonFormField<VehicleCatalogItem>(
                                value: _selectedVehicle,
                                isExpanded: true,
                                decoration: InputDecoration(
                                  labelText: 'Kendaraan spesifik',
                                  prefixIcon: const Icon(Icons.precision_manufacturing_outlined),
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                  helperText: _loadingVehicles ? 'Memuat…' : 'Boleh dikosongkan.',
                                  helperStyle: context.textTheme.bodySmall?.copyWith(color: tokens.textMuted),
                                ),
                                selectedItemBuilder: (context) {
                                  return _vehicles.map((item) {
                                    return Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(item.name, overflow: TextOverflow.ellipsis),
                                    );
                                  }).toList();
                                },
                                items: _vehicles
                                    .map((item) => DropdownMenuItem<VehicleCatalogItem>(
                                          value: item,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 2),
                                            child: Row(
                                              children: <Widget>[
                                                Container(
                                                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                                                  decoration: BoxDecoration(
                                                    color: tokens.accent.withValues(alpha: 0.1),
                                                    borderRadius: BorderRadius.circular(6),
                                                  ),
                                                  child: Text(
                                                    item.serialNumber,
                                                    style: context.textTheme.labelSmall?.copyWith(
                                                      color: tokens.accent,
                                                      fontWeight: FontWeight.w700,
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 10),
                                                Expanded(child: Text(item.name, overflow: TextOverflow.ellipsis, style: context.textTheme.bodyMedium)),
                                              ],
                                            ),
                                          ),
                                        ))
                                    .toList(),
                                onChanged: _loadingVehicles
                                    ? null
                                    : (value) => setState(() => _selectedVehicle = value),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Dates
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: TextFormField(
                                controller: _startDateController,
                                readOnly: true,
                                onTap: () => _pickDate(_startDateController),
                                decoration: const InputDecoration(
                                  labelText: 'Mulai',
                                  prefixIcon: Icon(Icons.date_range_outlined),
                                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: TextFormField(
                                controller: _endDateController,
                                readOnly: true,
                                onTap: () => _pickDate(_endDateController),
                                decoration: const InputDecoration(
                                  labelText: 'Sampai',
                                  prefixIcon: Icon(Icons.event_note_outlined),
                                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: FilledButton.icon(
                            onPressed: _openReport,
                            icon: const Icon(Icons.travel_explore_outlined, size: 18),
                            label: const Text('Lihat laporan'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
