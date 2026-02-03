import 'package:equatable/equatable.dart';
import '../../data/models/task_model.dart';

abstract class TaskState extends Equatable {
  const TaskState();
  @override
  List<Object?> get props => [];
}

class TaskInitial extends TaskState {}
class TaskLoading extends TaskState {}

class TaskLoaded extends TaskState {
  final List<TaskModel> tasks;
  final String selectedCategory; // Track highlight via Cubit

  const TaskLoaded({
    required this.tasks, 
    this.selectedCategory = "All",
  });

  @override
  List<Object?> get props => [tasks, selectedCategory];
}

class TaskError extends TaskState {
  final String message;
  const TaskError(this.message);
  @override
  List<Object?> get props => [message];
}