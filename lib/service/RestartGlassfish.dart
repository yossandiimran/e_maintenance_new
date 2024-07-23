// ignore_for_file: file_names, prefer_typing_uninitialized_variables, avoid_print, prefer_interpolation_to_compose_strings, curly_braces_in_flow_control_structures
part of '../header.dart';

class RestartGlassfish {
  final context, obj;
  RestartGlassfish({required BuildContext this.context, required var this.obj});

  Future<void> restartConnection() async {
    // var url = await global.getMainServiceUrl('server/restart');
    var data;
    try {
      await http.get(Uri.parse("http://202.138.230.51:8080/eReset/ResetWar?APPNAME=emaintenance")).then((res) {
        var rawData = json.decode(res.body);
        if (res.statusCode == 200) {
          bool hasError = rawData.containsKey("ERROR");
          if (hasError) if (rawData["ERROR"] != "Unregister Destination Failed!") {
            return global.errorResponsePop(context, rawData["ERROR"]);
          }
          var error = rawData["ERROR"];
          var success = rawData["SUCCESS_RESET"];
          data = {"ERROR": error.toString(), "SUCCESS": success.toString()};
          print(data);
          global.successResponseNoPop(context, "Koneksi Berhasil Di Reset !");
        } else if (res.statusCode == 400) {
          global.errorResponseNoPop(context, data["message"]);
        } else if (res.statusCode == 401) {
          global.errorResponseNoPop(context, "Sesi Anda Habis, Silahkan Login Ulang !");
        }
      }).catchError((err1) {
        print(err1);
        global.errorResponseNoPop(context, "Gagal Saat Restart Koneksi !");
      });
    } catch (err2) {
      print(err2);
      global.errorResponsePop(context, err2.toString());
    }
  }
}
