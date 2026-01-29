import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import '../features/tasks/data/repository/task_repository.dart';
import '../features/tasks/presentation/bloc/task_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // External
  sl.registerLazySingleton(() => Dio());

  // Repository
  sl.registerLazySingleton(() => TaskRepository(dio: sl()));

  // Bloc/Cubit
  sl.registerFactory(() => TaskCubit(taskRepository: sl()));
}