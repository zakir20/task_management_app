import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repository/task_repository.dart';
import '../../data/models/task_model.dart';
import 'task_state.dart';

class TaskCubit extends Cubit<TaskState> {
  final TaskRepository taskRepository;
  TaskCubit({required this.taskRepository}) : super(TaskInitial());

  static const List<String> categories = ["All", "To do", "In Progress", "Completed"];

  List<TaskModel> _allTasks = [];
  String currentFilter = "All";

  Future<void> getTasks() async {
    emit(TaskLoading());
    try {
      _allTasks = await taskRepository.getLocalTasks();

      if (_allTasks.isEmpty) {
        _allTasks = await taskRepository.fetchRemoteTasks();
        await taskRepository.saveTasksToLocal(_allTasks);
      }

      filterTasks(currentFilter);
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  void filterTasks(String category) {
    currentFilter = category;
    List<TaskModel> filteredList = [];

    if (category == "All") {
      filteredList = _allTasks;
    } else if (category == "To do") {
      filteredList = _allTasks.where((task) => !task.completed).toList();
    } else if (category == "In Progress") {
      filteredList = _allTasks.where((task) => !task.completed && task.id % 2 == 0).toList();
    } else if (category == "Completed") {
      filteredList = _allTasks.where((task) => task.completed).toList();
    }

    emit(TaskLoaded(tasks: List.from(filteredList), selectedCategory: category));
  }

  Future<void> addNewTask(String taskName) async {
    try {
      final newTask = await taskRepository.createTask(taskName);
      _allTasks.insert(0, newTask);
      await taskRepository.saveTasksToLocal(_allTasks);
      filterTasks(currentFilter);
    } catch (e) {
      emit(const TaskError("Failed to add task"));
    }
  }
}