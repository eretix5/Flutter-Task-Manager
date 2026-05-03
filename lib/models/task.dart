import 'dart:convert';
import 'package:flutter/material.dart';

enum TaskCategory {
  work('Работа', Icons.work, Colors.blue),
  personal('Личное', Icons.person, Colors.purple),
  shopping('Покупки', Icons.shopping_cart, Colors.orange);

  final String label;
  final IconData icon;
  final Color color;

  const TaskCategory(this.label, this.icon, this.color);
}

class Task {
  final String id;
  final String title;
  final bool isDone;
  final TaskCategory category;

  const Task({
    required this.id,
    required this.title,
    this.isDone = false,
    this.category = TaskCategory.personal, // По умолчанию
  });

  Task copyWith({String? id, String? title, bool? isDone, TaskCategory? category}) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      isDone: isDone ?? this.isDone,
      category: category ?? this.category,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'isDone': isDone,
      'category': category.name,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      isDone: map['isDone'] ?? false,
      category: TaskCategory.values.firstWhere(
        (e) => e.name == map['category'],
        orElse: () => TaskCategory.personal,
      ),
    );
  }

  String toJson() => json.encode(toMap());
  factory Task.fromJson(String source) => Task.fromMap(json.decode(source));
}