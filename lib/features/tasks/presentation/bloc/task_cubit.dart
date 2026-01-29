import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repository/task_repository.dart';
import '../../data/models/task_model.dart';
import 'task_state.dart';

class TaskCubit extends Cubit<TaskState> {
  final TaskRepository taskRepository;

  TaskCubit({required this.taskRepository}) : super(TaskInitial());

  List<TaskModel> _allTasks = [];

  Future<void> getTasks() async {
    emit(TaskLoading());
    try {
      _allTasks = await taskRepository.fetchTasks();
      emit(TaskLoaded(List.from(_allTasks)));
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  Future<void> addNewTask(String taskName) async {
    try {
      final newTask = await taskRepository.createTask(taskName);
      
      _allTasks.insert(0, newTask);
      
      emit(TaskLoaded(List.from(_allTasks)));
    } catch (e) {
      emit(TaskError("Failed to add task"));
    }
  }
}