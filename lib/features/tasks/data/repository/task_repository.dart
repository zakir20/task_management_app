import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/network/network_executor.dart';
import '../models/task_model.dart';

class TaskRepository {
  final NetworkExecutor executor;
  final SharedPreferences sharedPreferences; 

  TaskRepository({
    required this.executor,
    required this.sharedPreferences, 
  });

  Future<List<TaskModel>> getLocalTasks() async {
    final String? savedData = sharedPreferences.getString('persistent_tasks');

    if (savedData != null) {
      final List decodedList = jsonDecode(savedData);
      return decodedList.map((e) => TaskModel.fromJson(e)).toList();
    }
    return [];
  }

  Future<void> saveTasksToLocal(List<TaskModel> tasks) async {
    final String encodedData = jsonEncode(tasks.map((t) => t.toJson()).toList());
    await sharedPreferences.setString('persistent_tasks', encodedData);
  }

  Future<List<TaskModel>> fetchRemoteTasks() async {
    final data = await executor.execute(url: '/todos', method: 'GET');
    final List list = data['todos'];
    return list.map((e) => TaskModel.fromJson(e)).toList();
  }

  Future<TaskModel> createTask(String taskName) async {
    final data = await executor.execute(
      url: '/todos/add',
      method: 'POST',
      data: {'todo': taskName, 'completed': false, 'userId': 5},
    );
    return TaskModel.fromJson(data);
  }
}