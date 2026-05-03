import 'package:flutter/material.dart';
import '../controllers/task_controller.dart';
import '../models/task.dart';

class TodoScreen extends StatefulWidget {
  final TaskController controller;
  const TodoScreen({super.key, required this.controller});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  final _textController = TextEditingController();
  TaskCategory _newCategory = TaskCategory.personal; // Категория для новой задачи

  void _addTask() {
    widget.controller.addTask(_textController.text, _newCategory);
    _textController.clear();
  }

  void _handleDelete(Task task) {
    widget.controller.deleteTask(task);
    
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Задача удалена'),
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'ОТМЕНИТЬ',
          onPressed: () => widget.controller.restoreTask(task),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Smart Task Manager")),
      body: Column(
        children: [
          // Блок добавления задачи
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _textController,
                        decoration: InputDecoration(
                          labelText: "Что нужно сделать?",
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onSubmitted: (_) => _addTask(),
                      ),
                    ),
                    const SizedBox(width: 12),
                    FloatingActionButton(
                      onPressed: _addTask,
                      elevation: 0,
                      child: const Icon(Icons.add),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Выбор категории для новой задачи
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: TaskCategory.values.map((cat) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: ChoiceChip(
                          label: Text(cat.label),
                          selected: _newCategory == cat,
                          onSelected: (_) => setState(() => _newCategory = cat),
                          avatar: Icon(cat.icon, size: 18, color: _newCategory == cat ? Colors.white : cat.color),
                          selectedColor: cat.color,
                          labelStyle: TextStyle(color: _newCategory == cat ? Colors.white : Colors.black),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
          
          // Фильтры категорий
          ListenableBuilder(
            listenable: widget.controller,
            builder: (context, _) {
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    FilterChip(
                      label: const Text('Все'),
                      selected: widget.controller.selectedFilter == null,
                      onSelected: (_) => widget.controller.setFilter(null),
                    ),
                    const SizedBox(width: 8),
                    ...TaskCategory.values.map((cat) => Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: FilterChip(
                        label: Text(cat.label),
                        selected: widget.controller.selectedFilter == cat,
                        onSelected: (_) => widget.controller.setFilter(cat),
                        backgroundColor: cat.color.withOpacity(0.1),
                      ),
                    )),
                  ],
                ),
              );
            }
          ),
          
          const SizedBox(height: 8),

          // Список задач
          Expanded(
            child: ListenableBuilder(
              listenable: widget.controller,
              builder: (context, _) {
                if (widget.controller.isLoading) return const Center(child: CircularProgressIndicator());
                
                final tasks = widget.controller.filteredTasks;
                if (tasks.isEmpty) return const Center(child: Text("Нет задач."));
                
                return ListView.builder(
                  itemCount: tasks.length,
                  itemBuilder: (ctx, i) {
                    final task = tasks[i];
                    return Dismissible(
                      key: ValueKey(task.id),
                      background: Container(
                        color: Colors.red.shade400,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      direction: DismissDirection.endToStart,
                      onDismissed: (_) => _handleDelete(task),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                        decoration: BoxDecoration(
                          color: task.isDone ? Colors.grey.shade100 : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: task.isDone ? Colors.transparent : task.category.color.withOpacity(0.5),
                          ),
                          boxShadow: task.isDone ? [] : [
                            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2))
                          ],
                        ),
                        child: ListTile(
                          leading: Checkbox(
                            value: task.isDone,
                            activeColor: task.category.color,
                            onChanged: (_) => widget.controller.toggleTask(task),
                          ),
                          title: Text(
                            task.title,
                            style: TextStyle(
                              decoration: task.isDone ? TextDecoration.lineThrough : null,
                              color: task.isDone ? Colors.grey : Colors.black87,
                              fontWeight: task.isDone ? FontWeight.normal : FontWeight.w500,
                            ),
                          ),
                          trailing: Icon(task.category.icon, color: task.category.color.withOpacity(0.5)),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}