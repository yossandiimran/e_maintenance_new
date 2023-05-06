// ignore_for_file: file_names, use_build_context_synchronously, prefer_typing_uninitialized_variables, prefer_interpolation_to_compose_strings, avoid_print

part of "../header.dart";

class AuthService {
  final BuildContext context;
  final objParam;
  AuthService({required this.context, this.objParam});

  Future login() async {
    alert.loadingAlert(context: context, text: "Mohon Tunggu .. ", isPop: false);

    try {
      var url = global.getMainServiceUrl('login');
      var dvc = await FirebaseMessaging.instance.getToken();
      var obj = {"username": objParam["username"], "password": objParam["password"], "device_token": dvc};
      await http.post(url, body: obj).then((res) async {
        var data = json.decode(res.body);
        print(data);
        if (res.statusCode == 200) {
          if (data["success"] == false) {
            return global.errorResponse(context, data["message"]);
          } else {
            var checkPreference = await setUserPreference(data["for_session"], objParam["password"]);
            if (checkPreference == 200) {
              return global.successResponseNavigate(context, "Berhasil Login", '/home');
            } else {
              return global.errorResponse(context, 'Tidak dapat Login !');
            }
          }
        } else {
          return global.errorResponse(context, data["message"]);
        }
      }).timeout(const Duration(seconds: 10), onTimeout: () {
        return global.errorResponsePop(context, "Koneksi Timeout ...");
      });
    } catch (e) {
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
      return 200;
    } catch (err) {
      print(err);
      return 201;
    }
  }
}
