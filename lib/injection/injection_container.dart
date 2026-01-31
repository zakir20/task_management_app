import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../features/tasks/data/repository/task_repository.dart';

final sl = GetIt.instance;

Future<void> init() async {
  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton(() => TaskRepository(dio: sl()));
}
