class AppEnvironment {
  const AppEnvironment._();

  static const String appName = 'E-Maintenance';
  static const String appVersion = '2.1.0';

  static const String defaultApiHost = String.fromEnvironment(
    'EMAINTENANCE_API_HOST',
    defaultValue: '210.210.165.197',
  );

  static const String apiBasePath = String.fromEnvironment(
    'EMAINTENANCE_API_BASE_PATH',
    defaultValue: '/e_maintenance_v2/public/',
  );

  static const String assetBasePath = String.fromEnvironment(
    'EMAINTENANCE_ASSET_BASE_PATH',
    defaultValue: '/e_maintenance/public/',
  );

  static const String resetConnectionUrl = String.fromEnvironment(
    'EMAINTENANCE_RESET_URL',
    defaultValue: 'http://202.138.230.51:8080/eReset/ResetWar?APPNAME=emaintenance',
  );

  static const String launcherIconAsset = 'assets/icon_new.png';
}
