// ignore_for_file: prefer_typing_uninitialized_variables, file_names

class Todo {
  final id;
  final title;
  final description;
  final isDone;
  final dueDate;
  final jp;

  Todo({this.isDone, this.id, this.title, this.description, this.dueDate, this.jp});

  Todo.fromJson(Map json)
      : id = json['id'],
        title = json['title'],
        description = json['description'],
        isDone = json['_is_done'] == 1,
        dueDate = json['tanggal'],
        jp = json['jp'];

  static formatData(String date) {
    date = date.substring(6, date.length - 2);
    var dates = date.split("-");
    return "${dates[2]}/${dates[1]}/${dates[0]}";
  }
}
