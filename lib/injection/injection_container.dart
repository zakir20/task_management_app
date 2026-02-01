import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:task_management_app/core/network/dio_client.dart';
import 'package:task_management_app/core/network/network_executor.dart';
import 'package:task_management_app/features/tasks/data/repository/task_repository.dart';
import 'package:task_management_app/features/tasks/presentation/bloc/task_cubit.dart';
import 'package:task_management_app/features/tasks/data/repository/onboard_repository.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // 1. External
  sl.registerLazySingleton(() => Dio());

  // 2. Core Network
  sl.registerLazySingleton(() => DioClient(sl()));
  sl.registerLazySingleton(() => NetworkExecutor(sl<DioClient>().dio));

  // 3. Repository
  sl.registerLazySingleton(() => TaskRepository(executor: sl()));

  // 4. Cubit
  sl.registerFactory(() => TaskCubit(taskRepository: sl()));
  
   // Onboard Repository
  sl.registerLazySingleton(() => OnboardRepository());
}