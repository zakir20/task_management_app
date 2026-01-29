import 'package:dio/dio.dart';
import '../models/task_model.dart';

class TaskRepository {
  final Dio dio;
  TaskRepository({required this.dio});

  Future<List<TaskModel>> fetchTasks() async {
    try {
      final response = await dio.get('https://dummyjson.com/todos');
      final List data = response.data['todos'];
      return data.map((e) => TaskModel.fromJson(e)).toList();
    } catch (e) {
      throw Exception("Failed to load tasks");
    }
  }

  Future<TaskModel> createTask(String taskName) async {
    try {
      final response = await dio.post(
        'https://dummyjson.com/todos/add',
        data: {'todo': taskName, 'completed': false, 'userId': 5},
      );
      return TaskModel.fromJson(response.data);
    } catch (e) {
      throw Exception("Failed to add task");
    }
  }
}