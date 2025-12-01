import 'dart:async';
import 'package:flutter/material.dart';
import '../model/todo_model.dart';
import '../service/database_helper.dart';
import '../service/notification_service.dart';

enum SortType { status, remainingTime }

class TodoProvider extends ChangeNotifier {
  List<TodoModel> todos = [];
  List<TodoModel> filteredTodos = [];
  Timer? _timer;
  SortType currentSort = SortType.status;
  String searchQuery = "";

  TodoProvider() {
    NotificationService().init();
    loadTodos();
    startGlobalTimer();
  }

  // ---------------- LOAD TODOS ----------------
  Future loadTodos() async {
    todos = await DBHelper.instance.getTodos();
    applyFilters();
  }

  // ---------------- FILTER & SORT ----------------
  void applyFilters() {
    // Filter by search
    filteredTodos = todos.where((t) {
      final query = searchQuery.toLowerCase();
      return t.title.toLowerCase().contains(query) ||
          t.description.toLowerCase().contains(query);
    }).toList();

    notifyListeners();
  }

  void setSearchQuery(String query) {
    searchQuery = query;
    applyFilters();
  }

  void setSort(SortType type) {
    currentSort = type;
    applyFilters();
  }

  // ---------------- CRUD ----------------
  Future addTodo(TodoModel model) async {
    await DBHelper.instance.insertTodo(model);
    await loadTodos();
  }

  Future updateTodo(TodoModel model) async {
    await DBHelper.instance.updateTodo(model);
    await loadTodos();
  }

  Future deleteTodo(int id) async {
    await DBHelper.instance.deleteTodo(id);
    await loadTodos();
  }

  // ---------------- TIMER CONTROL ----------------
  void startTimer(TodoModel todo) {
    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;

    // ✅ Continue from paused time
    if (todo.status == "paused" || todo.remainingSeconds < todo.totalSeconds) {
      todo.startTimestamp = now - (todo.totalSeconds - todo.remainingSeconds);
    } else {
      todo.startTimestamp = now;
      todo.remainingSeconds = todo.totalSeconds;
    }

    todo.status = "in-progress";

    updateTodo(todo);
  }

  void pauseTimer(TodoModel todo) {
    todo.remainingSeconds = todo.calculatedRemainingSeconds;
    todo.status = "paused";
    todo.startTimestamp = null;

    updateTodo(todo);
  }

  void stopTimer(TodoModel todo) {
    todo.remainingSeconds = todo.totalSeconds;
    todo.startTimestamp = null;
    todo.status = "todo";

    updateTodo(todo);
  }

  // ---------------- GLOBAL TIMER ----------------
  void startGlobalTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) async {
      bool changed = false;

      for (var todo in todos) {
        if (todo.isRunning) {
          final remain = todo.calculatedRemainingSeconds;

          if (remain <= 0) {
            todo.status = "done";
            todo.remainingSeconds = 0;
            todo.startTimestamp = null;

            // ✅ Show notification
            await NotificationService().showNotification(
              todo.id ?? 0,
              "Todo Completed",
              todo.title,
            );
          } else {
            todo.remainingSeconds = remain;
          }

          await DBHelper.instance.updateTodo(todo);
          changed = true;
        }
      }

      if (changed) applyFilters();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
