enum InspectionKind {
  daily('1', 'Harian'),
  weekly('2', 'Mingguan'),
  monthly('3', 'Bulanan'),
  shutdown('4', 'Tutup Pabrik');

  const InspectionKind(this.id, this.label);

  final String id;
  final String label;

  static InspectionKind fromId(String? id) {
    return InspectionKind.values.firstWhere(
      (value) => value.id == id,
      orElse: () => InspectionKind.daily,
    );
  }
}

enum VehicleType {
  car('1', 'Mobil'),
  forklift('2', 'Forklip');

  const VehicleType(this.id, this.label);

  final String id;
  final String label;

  static VehicleType fromId(String? id) {
    return VehicleType.values.firstWhere(
      (value) => value.id == id,
      orElse: () => VehicleType.car,
    );
  }
}

class UserSession {
  const UserSession({
    required this.id,
    required this.username,
    required this.name,
    required this.usap,
    required this.psap,
    required this.werks,
    required this.roleId,
    this.loginTimestamp,
  });

  final int id;
  final String username;
  final String name;
  final String usap;
  final String psap;
  final String werks;
  final String roleId;
  final int? loginTimestamp;

  static const int sessionDurationMs = 6 * 60 * 60 * 1000; // 6 hours

  bool get isSessionExpired {
    if (loginTimestamp == null) return true;
    return DateTime.now().millisecondsSinceEpoch - loginTimestamp! > sessionDurationMs;
  }

  bool get isRestrictedOperator => roleId == '4';

  factory UserSession.fromLoginPayload(Map<String, dynamic> json) {
    return UserSession(
      id: int.tryParse('${json['id'] ?? 0}') ?? 0,
      username: '${json['username'] ?? ''}',
      name: '${json['nama'] ?? ''}',
      usap: '${json['usap'] ?? ''}',
      psap: '${json['psap'] ?? ''}',
      werks: '${json['werks'] ?? ''}',
      roleId: '${json['id_jenis_user'] ?? ''}',
      loginTimestamp: DateTime.now().millisecondsSinceEpoch,
    );
  }

  Map<String, dynamic> toPreferencesMap() {
    return <String, dynamic>{
      'id': id,
      'username': username,
      'nama': name,
      'usap': usap,
      'psap': psap,
      'werks': werks,
      'id_jenis_user': roleId,
      'login_timestamp': loginTimestamp ?? DateTime.now().millisecondsSinceEpoch,
    };
  }
}

class AppUser {
  const AppUser({
    required this.id,
    required this.username,
    required this.name,
    required this.location,
    required this.roleId,
  });

  final String id;
  final String username;
  final String name;
  final String location;
  final String roleId;

  String get roleLabel {
    switch (roleId) {
      case '1':
        return 'Admin';
      case '2':
        return 'Pimpinan';
      case '3':
        return 'Kabag';
      case '4':
        return 'Operator';
      default:
        return 'Tidak diketahui';
    }
  }

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      id: '${json['id'] ?? ''}',
      username: '${json['username'] ?? json['name'] ?? ''}',
      name: '${json['name'] ?? json['username'] ?? ''}',
      location: '${json['werks'] ?? ''}',
      roleId: '${json['id_jenis_user'] ?? ''}',
    );
  }
}

class StorageLocation {
  const StorageLocation({
    required this.code,
    required this.name,
  });

  final String code;
  final String name;

  factory StorageLocation.fromJson(Map<String, dynamic> json) {
    return StorageLocation(
      code: '${json['LGORT'] ?? ''}',
      name: '${json['LGOBE'] ?? ''}',
    );
  }
}

class VehicleCatalogItem {
  const VehicleCatalogItem({
    required this.serialNumber,
    required this.name,
  });

  final String serialNumber;
  final String name;

  factory VehicleCatalogItem.fromJson(Map<String, dynamic> json) {
    return VehicleCatalogItem(
      serialNumber: '${json['SERNR'] ?? ''}',
      name: '${json['MAKTX'] ?? ''}',
    );
  }
}

class VehicleInfo {
  const VehicleInfo({
    required this.materialDescription,
    required this.flag,
    required this.materialNumber,
    required this.message,
    this.werks = '',
  });

  final String materialDescription;
  final String flag;
  final String materialNumber;
  final String message;
  final String werks;

  bool get isForklift => flag == 'X';

  bool get hasError => message.toUpperCase().contains('DATA TIDAK DITEMUKAN') || message.toUpperCase().contains('RFC_LOGON_FAILURE');

  factory VehicleInfo.fromJson(Map<String, dynamic> json) {
    return VehicleInfo(
      materialDescription: '${json['MAKTX'] ?? ''}',
      flag: '${json['FLAG'] ?? ''}',
      materialNumber: '${json['MATNR'] ?? ''}',
      message: '${json['MSG'] ?? ''}'.trim(),
      werks: '${json['WERKS'] ?? json['werks'] ?? ''}',
    );
  }
}

class ChecklistItem {
  const ChecklistItem({
    required this.title,
    required this.vehicleCategory,
    this.isDone = false,
    this.note = '',
    this.photoFileName = '',
  });

  final String title;
  final String vehicleCategory;
  final bool isDone;
  final String note;
  final String photoFileName;

  ChecklistItem copyWith({
    bool? isDone,
    String? note,
    String? photoFileName,
  }) {
    return ChecklistItem(
      title: title,
      vehicleCategory: vehicleCategory,
      isDone: isDone ?? this.isDone,
      note: note ?? this.note,
      photoFileName: photoFileName ?? this.photoFileName,
    );
  }

  factory ChecklistItem.fromJson(Map<String, dynamic> json) {
    return ChecklistItem(
      title: '${json['title'] ?? ''}',
      vehicleCategory: '${json['jenis_kendaraan'] ?? ''}',
      isDone: json['_is_done'] == true || json['_is_done'] == 1,
      note: '${json['keterangan'] ?? ''}',
      photoFileName: '${json['photo'] ?? ''}',
    );
  }
}

class TransactionReportFilter {
  const TransactionReportFilter({
    required this.inspectionKind,
    required this.vehicleType,
    required this.storageLocation,
    required this.vehicleSerialNumber,
    required this.startDate,
    required this.endDate,
  });

  final InspectionKind inspectionKind;
  final VehicleType vehicleType;
  final String storageLocation;
  final String vehicleSerialNumber;
  final String startDate;
  final String endDate;
}

class TransactionReportItem {
  const TransactionReportItem({
    required this.date,
    required this.userName,
    required this.location,
    required this.vehicleName,
    required this.serialNumber,
    required this.title,
    required this.isDone,
    required this.photoFileName,
  });

  final String date;
  final String userName;
  final String location;
  final String vehicleName;
  final String serialNumber;
  final String title;
  final bool isDone;
  final String photoFileName;

  factory TransactionReportItem.fromJson(Map<String, dynamic> json) {
    return TransactionReportItem(
      date: '${json['tanggal'] ?? ''}',
      userName: '${json['nama'] ?? ''}',
      location: '${json['werks'] ?? ''}',
      vehicleName: '${json['kendaraan'] ?? '-'}',
      serialNumber: '${json['sn_kendaraan'] ?? ''}',
      title: '${json['title'] ?? ''}',
      isDone: json['_is_done'] == true || json['_is_done'] == 1 || '${json['_is_done']}'.toLowerCase() == 'true',
      photoFileName: '${json['photo'] ?? ''}',
    );
  }
}

class UserReportQuery {
  const UserReportQuery({
    required this.location,
    required this.inspectionKind,
    required this.startDate,
    required this.endDate,
  });

  final String location;
  final InspectionKind inspectionKind;
  final String startDate;
  final String endDate;
}

class UserReportEntry {
  const UserReportEntry({
    required this.name,
    required this.location,
    required this.performedDates,
  });

  final String name;
  final String location;
  final List<String> performedDates;

  factory UserReportEntry.fromJson(Map<String, dynamic> json) {
    final todos = (json['todo'] as List<dynamic>? ?? <dynamic>[])
        .map((item) => '${(item as Map<String, dynamic>)['tanggal'] ?? ''}')
        .where((value) => value.isNotEmpty)
        .toList();

    return UserReportEntry(
      name: '${json['name'] ?? ''}',
      location: '${json['werks'] ?? ''}',
      performedDates: todos,
    );
  }
}

class UserFormData {
  const UserFormData({
    this.id,
    this.username = '',
    this.location = '',
    this.roleId = '4',
  });

  final String? id;
  final String username;
  final String location;
  final String roleId;

  bool get isEditing => id != null && id!.isNotEmpty;

  UserFormData copyWith({
    String? id,
    String? username,
    String? location,
    String? roleId,
  }) {
    return UserFormData(
      id: id ?? this.id,
      username: username ?? this.username,
      location: location ?? this.location,
      roleId: roleId ?? this.roleId,
    );
  }

  factory UserFormData.fromUser(AppUser user) {
    return UserFormData(
      id: user.id,
      username: user.username,
      location: user.location,
      roleId: user.roleId,
    );
  }
}
