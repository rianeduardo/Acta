import 'package:shared_preferences/shared_preferences.dart';
import 'package:actav1/models/tarefa_model.dart';

class StorageService {
  static const String _tasksKey = 'user_tasks';

  // Salva a lista completa de tarefas
  static Future<void> saveTasks(List<TaskModel> tasks) async {
    final prefs = await SharedPreferences.getInstance();
    final String encodedData = TaskModel.encode(tasks);
    await prefs.setString(_tasksKey, encodedData);
  }

  // Busca a lista de tarefas
  static Future<List<TaskModel>> getTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final String? tasksString = prefs.getString(_tasksKey);
    if (tasksString == null) return [];
    return TaskModel.decode(tasksString);
  }

  static const String _nameKey = 'user_name';

// 1. Grava o nome do usuário
  static Future<void> saveName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_nameKey, name);
  }

// 2. Lê o nome do usuário
  static Future<String?> getName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_nameKey);
  }
}

