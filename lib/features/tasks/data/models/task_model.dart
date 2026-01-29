class TaskModel {
  final int id;
  final String todo;
  final bool completed;
  final int userId;

  TaskModel({
    required this.id,
    required this.todo,
    required this.completed,
    required this.userId,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'],
      todo: json['todo'],
      completed: json['completed'],
      userId: json['userId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'todo': todo,
      'completed': completed,
      'userId': userId,
    };
  }
}