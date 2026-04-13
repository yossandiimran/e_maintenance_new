import 'package:flutter_test/flutter_test.dart';
import 'package:e_maintenance/model/TodoModels.dart';

void main() {
  test('Todo.fromJson maps API payload into model fields', () {
    final todo = Todo.fromJson({
      'id': 7,
      'title': 'Periksa rem',
      'description': 'Cek kondisi kampas rem',
      '_is_done': 1,
      'tanggal': '2026-04-13',
      'jp': 'Harian',
    });

    expect(todo.id, 7);
    expect(todo.title, 'Periksa rem');
    expect(todo.description, 'Cek kondisi kampas rem');
    expect(todo.isDone, isTrue);
    expect(todo.dueDate, '2026-04-13');
    expect(todo.jp, 'Harian');
  });

  test('Todo.fromJson keeps unfinished item as false', () {
    final todo = Todo.fromJson({
      'id': 8,
      'title': 'Periksa oli',
      'description': 'Pastikan level oli aman',
      '_is_done': 0,
      'tanggal': '2026-04-14',
      'jp': 'Mingguan',
    });

    expect(todo.isDone, isFalse);
    expect(todo.dueDate, '2026-04-14');
  });
}
