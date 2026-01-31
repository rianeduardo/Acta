import 'dart:convert';

class TaskModel {
  String id;
  String title;
  String description;
  String priority;
  DateTime createdAt;
  bool isDone;
  bool isDeleted;

  TaskModel({
    required this.id,
    required this.title,
    required this.description,
    required this.priority,
    required this.createdAt,
    this.isDone = false,
    this.isDeleted = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'priority': priority,
      'createdAt': createdAt.toIso8601String(),
      'isDone': isDone,
      'isDeleted': isDeleted,
    };
  }

  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      priority: map['priority'],
      createdAt: DateTime.parse(map['createdAt']),
      isDone: map['isDone'] ?? false,
      isDeleted: map['isDeleted'] ?? false,
    );
  }

  static String encode(List<TaskModel> tasks) => json.encode(
    tasks.map<Map<String, dynamic>>((task) => task.toMap()).toList(),
  );

  static List<TaskModel> decode(String tasks) =>
      (json.decode(tasks) as List<dynamic>)
          .map<TaskModel>((item) => TaskModel.fromMap(item))
          .toList();
}