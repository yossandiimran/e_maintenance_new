import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;

import 'package:e_maintenance/core/config/app_environment.dart';
import 'package:e_maintenance/helper/preference.dart';

class AppApiClient {
  AppApiClient({
    required AppPreferences preferences,
    http.Client? client,
  })  : _preferences = preferences,
        _client = client ?? http.Client();

  final AppPreferences _preferences;
  final http.Client _client;

  String get activeHost {
    final override = _preferences.hostOverride;
    return override.isNotEmpty ? override : AppEnvironment.defaultApiHost;
  }

  Uri mainUri(String endpoint) {
    return Uri.parse('http://$activeHost${AppEnvironment.apiBasePath}api/$endpoint');
  }

  String photoUrl(String fileName) {
    return 'http://$activeHost${AppEnvironment.assetBasePath}$fileName';
  }

  Uri manualUri(String endpoint) {
    final baseUrl = _preferences.manualServiceBaseUrl;
    return Uri.parse('${_normalizeBaseUrl(baseUrl)}$endpoint');
  }

  Future<http.Response> getMain(String endpoint) {
    return _client.get(mainUri(endpoint));
  }

  Future<http.Response> postMain(
    String endpoint, {
    Map<String, String>? body,
    Map<String, String>? headers,
  }) {
    return _client.post(mainUri(endpoint), body: body, headers: headers);
  }

  Future<http.Response> postMainJson(
    String endpoint, {
    required String body,
    Map<String, String>? headers,
  }) {
    return _client.post(
      mainUri(endpoint),
      body: body,
      headers: headers,
    );
  }

  Future<http.Response> getManual(String endpoint) {
    return _client.get(manualUri(endpoint));
  }

  Future<http.Response> postManual(
    String endpoint, {
    Map<String, String>? body,
  }) {
    return _client.post(manualUri(endpoint), body: body);
  }

  Future<http.StreamedResponse> uploadMain(
    String endpoint, {
    required File file,
    Map<String, String>? fields,
  }) async {
    final request = http.MultipartRequest('POST', mainUri(endpoint));
    request.fields.addAll(fields ?? <String, String>{});
    request.files.add(await http.MultipartFile.fromPath('photo', file.path, filename: path.basename(file.path)));
    return request.send();
  }

  String _normalizeBaseUrl(String value) {
    if (value.endsWith('/')) {
      return value;
    }
    return '$value/';
  }
}
