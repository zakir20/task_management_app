import 'dart:convert'; 
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart'; 
import '../../../../core/utils/app_logger.dart'; 
import '../../data/repository/task_repository.dart';
import '../../data/models/task_model.dart';
import 'task_state.dart';

class TaskCubit extends Cubit<TaskState> {
  final TaskRepository taskRepository;

  TaskCubit({required this.taskRepository}) : super(TaskInitial());

  List<TaskModel> _allTasks = [];
  String currentFilter = "All"; 

  Future<void> getTasks() async {
    emit(TaskLoading());
    try {
      logger.i("Attempting to load tasks...");

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? savedData = prefs.getString('persistent_tasks');

      if (savedData != null) {
        logger.d("Local data found. Loading tasks from phone memory.");
        final List decodedList = jsonDecode(savedData);
        _allTasks = decodedList.map((e) => TaskModel.fromJson(e)).toList();
      } else {
        logger.i("No local data found. Fetching from API...");
        _allTasks = await taskRepository.fetchTasks();
        
        await _saveTasksToLocal(); 
      }

      filterTasks(currentFilter);
    } catch (e) {
      logger.e("Error in getTasks: $e");
      emit(TaskError(e.toString()));
    }
  }

  Future<void> _saveTasksToLocal() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String encodedData = jsonEncode(_allTasks.map((t) => t.toJson()).toList());
      await prefs.setString('persistent_tasks', encodedData);
      logger.v("Tasks successfully saved to local storage.");
    } catch (e) {
      logger.e("Failed to save tasks locally: $e");
    }
  }

  void filterTasks(String category) {
    logger.i("Filter changed to: $category");
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

    emit(TaskLoaded(List.from(filteredList)));
  }

  Future<void> addNewTask(String taskName) async {
    try {
      logger.i("Adding new task: $taskName");
      final newTask = await taskRepository.createTask(taskName);
      
      _allTasks.insert(0, newTask);
      
      await _saveTasksToLocal();

      filterTasks(currentFilter);
    } catch (e) {
      logger.e("Critical error adding task: $e");
      emit(const TaskError("Failed to add task"));
    }
  }
}