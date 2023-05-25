// ignore_for_file: file_names, use_build_context_synchronously, prefer_typing_uninitialized_variables, prefer_interpolation_to_compose_strings, avoid_print, non_constant_identifier_names, unused_local_variable

part of "../header.dart";

class UserService {
  final BuildContext context;
  final objParam;
  UserService({required this.context, this.objParam});

  Future<List> getUserList() async {
    List ret = [];
    Uri url = await global.getMainServiceUrl("userList");
    await http.post(url, body: objParam).then((response) {
      final content = json.decode(response.body);
      if (content["success"] == true) {
        ret = content["data"];
      } else {
        ret = [];
      }
    });

    return ret;
  }

  Future<String> deleteUserList() async {
    String ret = "";
    print(objParam);
    Uri url = await global.getMainServiceUrl("userDelete");
    await http.post(url, body: objParam).then((response) {
      final content = json.decode(response.body);
      if (content["success"] == true) {
        ret = "Sukses";
      } else {
        ret = "Gagal";
      }
    });

    return ret;
  }

  Future<String> addUserList() async {
    String ret = "";
    String uri = "userAdd";
    print(objParam);
    Uri url = await global.getMainServiceUrl(uri);
    await http.post(url, body: objParam).then((response) {
      final content = json.decode(response.body);
      if (content["success"] == true) {
        ret = "Sukses";
      } else {
        ret = content["message"];
      }
    });
    return ret;
  }
}
