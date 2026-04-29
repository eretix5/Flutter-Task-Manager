import 'package:flutter/material.dart';
import '../models/task.dart';
import '../widgets/task_item.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  TodoScreenState createState() => TodoScreenState();
}

class TodoScreenState extends State<TodoScreen> {
  final List<Task> _tasks = [];
  final _textController = TextEditingController();

  // Создание (Add)
  void _addTask() {
    if (_textController.text.isEmpty) return;
    setState(() {
      _tasks.add(Task(id: DateTime.now().toString(), title: _textController.text));
      _textController.clear();
    });
  }

  // Удаление (Delete)
  void _deleteTask(String id) {
    setState(() => _tasks.removeWhere((t) => t.id == id));
  }

  // Обновление статуса
  void _toggleTask(Task task) {
    setState(() => task.isDone = !task.isDone);
  }

  // Редактирование (Edit) через диалог
  void _editTask(Task task) {
    _textController.text = task.title;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Редактировать задачу"),
        content: TextField(controller: _textController),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text("Отмена")),
          TextButton(
            onPressed: () {
              setState(() => task.title = _textController.text);
              _textController.clear();
              Navigator.pop(ctx);
            },
            child: Text("Сохранить"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Smart Task Manager")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: InputDecoration(labelText: "Что нужно сделать?"),
                  ),
                ),
                IconButton(icon: Icon(Icons.add, size: 32, color: Colors.green), onPressed: _addTask),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _tasks.length,
              itemBuilder: (ctx, i) => TaskItem(
                task: _tasks[i],
                onToggle: _toggleTask,
                onDelete: _deleteTask,
                onEdit: _editTask,
              ),
            ),
          ),
        ],
      ),
    );
  }
}