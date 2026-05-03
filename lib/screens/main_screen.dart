import 'package:flutter/material.dart';
import '../controllers/task_controller.dart';
import 'todo_screen.dart';
import 'stats_screen.dart';

// Глобальный экземпляр для простоты (в идеале использовать Provider или Riverpod)
final taskController = TaskController();

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          TodoScreen(controller: taskController),
          StatsScreen(controller: taskController),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) => setState(() => _currentIndex = index),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.list), label: 'Задачи'),
          NavigationDestination(icon: Icon(Icons.bar_chart), label: 'Статистика'),
        ],
      ),
    );
  }
}