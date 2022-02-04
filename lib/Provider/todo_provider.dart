import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider_tutorial/Model/todo.dart';

class TodoProvider extends ChangeNotifier {
  List<Todo> _todos = [];
  List<Todo> get todos => _todos;

  Future loadTodos() async {
    const storageInstance = FlutterSecureStorage();
    final todoJsonString = await storageInstance.read(key: "todo");
    if (todoJsonString != null) {
      final List todoJsonList = json.decode(todoJsonString);
      final todoList = todoJsonList.map((todo) => Todo.fromJson(todo)).toList();
      _todos = todoList;
      notifyListeners();
    } else {}
  }

  Future updateStorage() async {
    const storageInstance = FlutterSecureStorage();
    final List<Map<String, dynamic>> jsonList =
        _todos.map((todo) => todo.toJson(todo)).toList();
    await storageInstance.write(
      key: "todo",
      value: json.encode(jsonList),
    );
  }

  Future<int> add(Todo todoToAdd) async {
    final idx = _todos.length + 1;
    _todos.add(todoToAdd);
    await updateStorage();
    notifyListeners();
    return idx;
  }

  Future remove(int idx) async {
    _todos.removeAt(idx);
    await updateStorage();
    notifyListeners();
  }

  toggleDone(int idx) {
    _todos[idx].isDone = !_todos[idx].isDone;
    updateStorage();
    notifyListeners();
  }
}
