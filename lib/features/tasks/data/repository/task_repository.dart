import '../../../../core/network/network_executor.dart';
import '../models/task_model.dart';

class TaskRepository {
  final NetworkExecutor executor;

  TaskRepository({required this.executor});

  Future<List<TaskModel>> fetchTasks() async {
    final data = await executor.execute(
      url: '/todos',
      method: 'GET',
    );
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