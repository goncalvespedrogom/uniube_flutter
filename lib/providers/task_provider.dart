import 'package:flutter/material.dart';
import '../models/task.dart';

class TaskProvider extends ChangeNotifier {
  List<Task> _tasks = [];

  List<Task> get tasks => _tasks;

  void addTask(String title, DateTime date) {
    _tasks.add(Task(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      date: date,
    ));
    notifyListeners();
  }

  void toggleTask(String id) {
    final task = _tasks.firstWhere((t) => t.id == id);
    task.isDone = !task.isDone;
    notifyListeners();
  }

  void removeTask(String id) {
    _tasks.removeWhere((t) => t.id == id);
    notifyListeners();
  }

  void editTask(String id, String newTitle, DateTime newDate) {
    final task = _tasks.firstWhere((t) => t.id == id);
    task.title = newTitle;
    task.date = newDate;
    notifyListeners();
  }

  void pinTask(String id) {
    final index = _tasks.indexWhere((t) => t.id == id);
    if (index != -1) {
      final task = _tasks.removeAt(index);
      _tasks.insert(0, task);
      notifyListeners();
    }
  }

  void moveTaskUp(String id) {
    final index = _tasks.indexWhere((t) => t.id == id);
    if (index > 0) {
      final task = _tasks.removeAt(index);
      _tasks.insert(index - 1, task);
      notifyListeners();
    }
  }

  void moveTaskDown(String id) {
    final index = _tasks.indexWhere((t) => t.id == id);
    if (index != -1 && index < _tasks.length - 1) {
      final task = _tasks.removeAt(index);
      _tasks.insert(index + 1, task);
      notifyListeners();
    }
  }

  List<Task> getTasksForDate(DateTime date) {
    return _tasks.where((t) =>
      t.date.year == date.year &&
      t.date.month == date.month &&
      t.date.day == date.day
    ).toList();
  }
}
