import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/network/network_executor.dart';
import '../../../../core/utils/app_logger.dart';
import '../models/task_model.dart';

class TaskRepository {
  final NetworkExecutor executor;

  TaskRepository({required this.executor});

  Future<List<TaskModel>> getLocalTasks() async {
    logger.i("Repository: Checking local storage for tasks...");
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? savedData = prefs.getString('persistent_tasks');

    if (savedData != null) {
      logger.d("Repository: Local data found.");
      final List decodedList = jsonDecode(savedData);
      return decodedList.map((e) => TaskModel.fromJson(e)).toList();
    }
    logger.w("Repository: No local data found.");
    return [];
  }

  Future<void> saveTasksToLocal(List<TaskModel> tasks) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String encodedData = jsonEncode(tasks.map((t) => t.toJson()).toList());
    await prefs.setString('persistent_tasks', encodedData);
    logger.v("Repository: Tasks synchronized to local storage.");
  }

  Future<List<TaskModel>> fetchRemoteTasks() async {
    logger.i("Repository: Fetching tasks from remote API...");
    final data = await executor.execute(url: '/todos', method: 'GET');
    final List list = data['todos'];
    return list.map((e) => TaskModel.fromJson(e)).toList();
  }

  Future<TaskModel> createTask(String taskName) async {
    logger.i("Repository: Sending new task to API...");
    final data = await executor.execute(
      url: '/todos/add',
      method: 'POST',
      data: {'todo': taskName, 'completed': false, 'userId': 5},
    );
    return TaskModel.fromJson(data);
  }
}