// ignore_for_file: file_names, use_build_context_synchronously, prefer_typing_uninitialized_variables, prefer_interpolation_to_compose_strings, avoid_print

part of "../header.dart";

class AuthService {
  final BuildContext context;
  final objParam;
  AuthService({required this.context, this.objParam});

  Future login() async {
    alert.loadingAlert(context: context, text: "Mohon Tunggu .. ", isPop: false);

    try {
      var url = await global.getMainServiceUrl('login');
      print(url);
      var dvc = await FirebaseMessaging.instance.getToken();
      var obj = {
        "username": objParam["username"],
        "password": objParam["password"],
        "device_token": dvc,
        "app_version": appVersion,
      };
      await http.post(url, body: obj).then((res) async {
        var data = json.decode(res.body);
        print(data);
        if (res.statusCode == 200) {
          if (data["success"] == false) {
            return global.errorResponse(context, data["message"]);
          } else {
            if (data["for_session"]["app_version"] == appVersion) {
              var checkPreference = await setUserPreference(data["for_session"], objParam["password"]);
              if (checkPreference == 200) {
                return global.successResponseNavigate(context, "Berhasil Login", '/home');
              } else {
                return global.errorResponse(context, 'Tidak dapat Login !');
              }
            } else {
              print("okey2");
              return global.errorResponse(
                context,
                'Tidak dapat login, silahkan update app ke versi terbaru, hubungi team EDP!',
              );
            }
          }
        } else {
          print("okey");
          return global.errorResponse(
            context,
            'Username atau password salah',
          );
        }
      }).timeout(const Duration(seconds: 10), onTimeout: () {
        return global.errorResponsePop(context, "Koneksi Timeout ...");
      });
    } catch (e) {
      print(e);
      return global.errorResponsePop(context, "Terjadi Kesalahan !");
    }
  }

  Future setUserPreference(data, pass) async {
    try {
      await preference.setInt("id", (data["id"] ?? ""));
      await preference.setString("username", (data["username"] ?? ""));
      await preference.setString("nama", (data["nama"] ?? ""));
      await preference.setString("usap", (data["usap"] ?? ""));
      await preference.setString("psap", (data["psap"] ?? ""));
      await preference.setString("werks", (data["werks"] ?? ""));
      await preference.setString("id_jenis_user", (data["id_jenis_user"] ?? ""));
      return 200;
    } catch (err) {
      print(err);
      return 201;
    }
  }

  Future getSetting() async {
    try {
      final response = await http.get(await global.getMainServiceUrl("getSetting"));
      final data = jsonDecode(response.body);
      if (data.length > 0) {
        for (var i = 0; i < data.length; i++) {
          preference.setString(data[i]["name_setting"], (data[i]["value"] ?? ""));
        }
      }
    } on SocketException {
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Info'),
            content: SingleChildScrollView(
              child: ListBody(
                children: const <Widget>[
                  Text('Koneksi ke server gagal!'),
                ],
              ),
            ),
          );
        },
      );
      print('No Internet connection');
    }
  }
}
