// ignore_for_file: file_names, use_build_context_synchronously, prefer_typing_uninitialized_variables, prefer_interpolation_to_compose_strings, avoid_print, non_constant_identifier_names, unused_local_variable

part of "../header.dart";

class ReportService {
  final BuildContext context;
  final objParam;
  ReportService({required this.context, this.objParam});

  Future<Map> getSloc({obj}) async {
    var ret;
    var url = await global.getBapiManualServiceUrl("getsloc");
    print(url);
    print(obj);
    await http.post(url, body: obj).then((res) {
      var data = json.decode(res.body);
      if (res.statusCode == 200) {
        ret = data;
      } else {
        ret = {
          "T_RET": ["Err"]
        };
      }
    });
    return ret;
  }

  Future<Map> getLkend({obj}) async {
    var ret;
    var url = await global.getBapiManualServiceUrl("getlkend");
    print(url);
    print(obj);
    await http.post(url, body: obj).then((res) {
      var data = json.decode(res.body);
      if (res.statusCode == 200) {
        ret = data;
      } else {
        ret = {
          "T_RET": ["Err"]
        };
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
    var url = await await global.getMainServiceUrl("getUserReport");
    try {
      await http.post(url, body: objParam).then((response) {
        final content = json.decode(response.body);
        print(content);
        if (content["success"] == true) {
          Navigator.pop(context);
          if (content["data"] != null) {
            ret = content["data"];
          }
        } else {
          global.errorResponsePop(context, "Terjadi kesalahan Service");
          ret = [];
        }
      });
    } catch (e) {
      ret = [];
      print(e);
      global.errorResponse(context, "Terjadi kesalahan Aplikasi");
    }
    return ret;
  }

  Future<Map> getTransaksiReport() async {
    Map ret = {};
    var url = await await global.getMainServiceUrl("getReportCekKendaraan");
    print(url.toString());
    print(objParam);
    try {
      await http.post(url, body: objParam).then((res) {
        var content = json.decode(res.body);
        print(content);
        if (content['hasil'] is String) {
          ret = {};
          global.errorResponse(context, content['hasil']);
        } else {
          ret = content;
        }
      });
    } catch (e) {
      ret = {};
      global.errorResponse(context, "Terjadi kesalahan Aplikasi");
    }
    return ret;
  }

  Future<Map> getTransaksiReportNew() async {
    Map ret = {};
    var url = await await global.getMainServiceUrl("getNewReport");
    print(url.toString());
    print(objParam);
    try {
      await http.post(url, body: objParam).then((res) {
        var content = json.decode(res.body);
        if (content['hasil'] is String) {
          ret = {};
          global.errorResponse(context, content['hasil']);
        } else {
          ret = content;
        }
      });
    } catch (e) {
      ret = {};
      global.errorResponse(context, "Terjadi kesalahan Aplikasi");
    }
    return ret;
  }
}
