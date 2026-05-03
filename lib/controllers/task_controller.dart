import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/task.dart';

class TaskController extends ChangeNotifier {
  List<Task> _tasks = [];
  bool _isLoading = true;
  TaskCategory? _selectedFilter; // null означает "Все"

  bool get isLoading => _isLoading;
  int get completedCount => _tasks.where((t) => t.isDone).length;
  int get totalCount => _tasks.length;
  TaskCategory? get selectedFilter => _selectedFilter;

  // Геттер с умной сортировкой и фильтрацией
  List<Task> get filteredTasks {
    var list = _selectedFilter == null 
        ? List<Task>.from(_tasks) 
        : _tasks.where((t) => t.category == _selectedFilter).toList();
    
    // Сортировка: активные сверху, выполненные снизу
    list.sort((a, b) {
      if (a.isDone == b.isDone) return 0;
      return a.isDone ? 1 : -1;
    });
    
    return list;
  }

  TaskController() {
    _loadTasks();
  }

  void setFilter(TaskCategory? category) {
    _selectedFilter = category;
    notifyListeners();
  }

  Future<void> _loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final tasksJson = prefs.getStringList('tasks') ?? [];
    _tasks = tasksJson.map((t) => Task.fromJson(t)).toList();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> _saveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final tasksJson = _tasks.map((t) => t.toJson()).toList();
    await prefs.setStringList('tasks', tasksJson);
  }

  void addTask(String title, TaskCategory category) {
    if (title.trim().isEmpty) return;
    _tasks.insert(0, Task(id: DateTime.now().toString(), title: title.trim(), category: category));
    _saveTasks();
    notifyListeners();
  }

  void toggleTask(Task task) {
    final index = _tasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      _tasks[index] = task.copyWith(isDone: !task.isDone);
      _saveTasks();
      notifyListeners(); // UI сам перерисует список и задача "улетит" вниз
    }
  }

  // Мягкое удаление (сохраняем индекс для точного возврата)
  void deleteTask(Task task) {
    _tasks.removeWhere((t) => t.id == task.id);
    _saveTasks();
    notifyListeners();
  }

  void restoreTask(Task task) {
    _tasks.insert(0, task); // Возвращаем наверх
    _saveTasks();
    notifyListeners();
  }
}