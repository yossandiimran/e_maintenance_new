// ignore_for_file: file_names, use_build_context_synchronously, prefer_typing_uninitialized_variables, prefer_interpolation_to_compose_strings, avoid_print, non_constant_identifier_names, unused_local_variable

part of "../header.dart";

class ReportService {
  final BuildContext context;
  final objParam;
  ReportService({required this.context, this.objParam});

  Future<String> getSloc({obj}) async {
    var ret;
    var url = await global.getBapiManualServiceUrl("getsloc");
    await http.post(url, body: obj).then((res) {
      var data = jsonEncode(res.body);
      if (res.statusCode == 200) {
        ret = data;
      } else {
        ret = "err";
      }
    });
    return ret;
  }

  Future<String> getDataKendaraan() async {
    var ret;
    var url = await global.getBapiManualServiceUrl("getkend");
    print(url);
    print("++++++++++++++++++++++++++++++++++++++++++++++++++++++++");
    print(objParam);
    print("++++++++++++++++++++++++++++++++++++++++++++++++++++++++");
    await http.post(url, body: objParam).then((response) {
      final content = json.decode(response.body);
      print(content);
      var MAKTX = content['MAKTX'];
      if (MAKTX == "") {
        global.errorResponsePop(context, content["MSG"]);
      }
      ret = jsonEncode(content);
    });

    return ret;
  }

  Future<List> getUserReport() async {
    List ret = [];
    alert.loadingAlert(context: context, text: "Mengambil data ...", isPop: false);
    var url = await global.getMainServiceUrl("getUserReport");
    try {
      await http.post(url, body: objParam).then((response) {
        final content = json.decode(response.body);
        if (content["success"] == true) {
          Navigator.pop(context);
          ret = content["data"];
        } else {
          global.errorResponsePop(context, "Terjadi kesalahan Service");
          ret = [];
        }
      });
    } catch (e) {
      ret = [];
      global.errorResponsePop(context, "Terjadi kesalahan Aplikasi");
    }
    return ret;
  }
}
