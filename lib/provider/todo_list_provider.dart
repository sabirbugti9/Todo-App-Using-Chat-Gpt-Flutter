import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/model/todo.dart';

class TodoListProvider extends ChangeNotifier {
  static const String _todoKey = 'todoList';
  List<Todo> _todos = [];

  List<Todo> get todos => _todos;

  TodoListProvider() {
    _loadTodos();
  }

 void _loadTodos() async {
  final prefs = await SharedPreferences.getInstance();
  final jsonString = prefs.getString(_todoKey);
  if (jsonString != null) {
    try {
      final jsonList = json.decode(jsonString) as List;
      _todos = jsonList.map((json) => Todo.fromJson(json)).toList();
    } catch (e) {
      print('Error loading todos: $e');
    }
  }
  notifyListeners();
}

  void _saveTodos() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = json.encode(_todos.map((todo) => todo.toJson()).toList());

     await prefs.setString(_todoKey, jsonString);

  }

  void add(Todo todo) {
    _todos.add(todo);
    _saveTodos();
    notifyListeners();
  }

  void remove(Todo todo) {
    _todos.remove(todo);
    _saveTodos();
    notifyListeners();
  }

  void toggleCompleted(Todo todo) {
    todo.completed = !todo.completed;
    _saveTodos();
    notifyListeners();
  }

  void edit(Todo oldTodo, Todo newTodo) {
    final index = _todos.indexOf(oldTodo);
    if (index >= 0) {
      _todos[index] = newTodo;
      _saveTodos();
      notifyListeners();
    }
  }
}
