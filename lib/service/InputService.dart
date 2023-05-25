// ignore_for_file: file_names, use_build_context_synchronously, prefer_typing_uninitialized_variables, prefer_interpolation_to_compose_strings, avoid_print, non_constant_identifier_names, unused_local_variable

part of "../header.dart";

class InputService {
  final BuildContext context;
  final objParam;
  InputService({required this.context, this.objParam});

  Future<String> getTodoList({String? urls}) async {
    String jeniscek = objParam["jenisCek"];
    var url = global.getMainServiceUrl("$urls/$jeniscek");
    final response = await http.get(url);

    var data = json.decode(response.body);
    return jsonEncode(data);
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

  Future uploadFoto({File? image}) async {
    alert.loadingAlert(context: context, text: "Uploading ... ", isPop: false);
    var ret = "success";
    var request = http.MultipartRequest('POST', global.getMainServiceUrl("upload"));
    request.fields['kode_customer'] = "";
    request.files.add(await http.MultipartFile.fromPath('photo', image!.path));
    await request.send().then((val) async {
      var responseString = await val.stream.bytesToString();
      final decodedMap = json.decode(responseString);
      print(decodedMap);
      if (decodedMap["hasil"] == "Gagal") {
        global.errorResponsePop(context, "Kesalahan Service !");
      } else {
        global.successResponsePop(context, "Foto berhasil di upload");
      }
    }).catchError((err) {
      print(err);
      global.errorResponsePop(context, "Error");
    });
    return ret;
  }
}

class TodoRepository {
  final DataBase dataBase = DataBase();

  Future getAllTodos() => dataBase.getTodos();
  Future addTodo(BuildContext context, List title, String desc, String date, String jp, String sn, String kendaraan,
          String nama, String werks) =>
      dataBase.addTodo(context, title, desc, date, jp, sn, kendaraan, nama, werks);
  Future deleteTodo(int id) => dataBase.deleteTodo(id);
  Future updateTodo(int id) => dataBase.updateTodo(id);
}

class TodoBloc {
  final _repository = TodoRepository();

  final StreamController<List<Todo>> _controller = StreamController<List<Todo>>.broadcast();

  get todos => _controller.stream;

  TodoBloc() {
    getTodos();
  }

  getTodos() async {
    _controller.sink.add(await _repository.getAllTodos());
  }

  addTodo(BuildContext context, List title, String desc, String date, String jp, String sn, String kendaraan,
      String nama, String werks) async {
    _controller.sink.add(await _repository.addTodo(context, title, desc, date, jp, sn, kendaraan, nama, werks));
    getTodos();
  }

  deleteTodo(int id) async {
    _controller.sink.add(await _repository.deleteTodo(id));
    getTodos();
  }

  updateTodo(int id) async {
    _controller.sink.add(await _repository.updateTodo(id));
    getTodos();
  }
}

class DataBase {
  final client = http.Client();

  addTodo(BuildContext context, List title, String desc, String date, String jp, String sn, String kendaraan,
      String nama, String werks) async {
    var url = global.getMainServiceUrl("addCekKendaraan");
    bool status = false;
    var t_status = "";

    for (int i = 0; i < title.length; i++) {
      Map<String, dynamic> jsonMap = {
        "title": title[i]['title'].toString(),
        "tanggal": date,
        "jenis_cek": jp,
        "jenis_kendaraan": title[i]['jenis_kendaraan'].toString(),
        "nama": nama,
        "sn_kendaraan": sn,
        "kendaraan": kendaraan,
        "is_done": title[i]['_is_done'].toString(),
        "werks": werks,
        "keterangan": title[i]['keterangan'].toString(),
        "photo": title[i]['photo'].toString()
      };

      await client
          .post(
        url,
        headers: {'Content-type': 'application/json'},
        body: jsonEncode(jsonMap),
      )
          .then((http.Response r) {
        var data = jsonDecode(r.body);
        return t_status = data[0];
      }).onError((error, stackTrace) async {
        status = false;
        return "err";
      }).whenComplete(() {
        status = true;
        print("add completed");
      });
    }
    final snackBar = SnackBar(
      content: Text(t_status),
      behavior: SnackBarBehavior.floating,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    Navigator.pop(context);
  }

  deleteTodo(int id) async {
    var url = global.getMainServiceUrl("todo/$id");
    await client.delete(url).then((http.Response r) => r.body).whenComplete(() => print("delete completed"));
  }

  updateTodo(int id) async {
    var url = global.getMainServiceUrl("todo/$id");
    await client.put(url).then((http.Response r) => r.body).whenComplete(() => print("update completed"));
  }

  getTodos() async {
    var url = global.getMainServiceUrl("todo");
    final response = await client.get(url);
    var list = (json.decode(response.body) as List).map((data) => Todo.fromJson(data)).toList();
    return list;
  }
}
