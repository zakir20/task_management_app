import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart'; 
import 'package:task_management_app/core/network/dio_client.dart';
import 'package:task_management_app/core/network/network_executor.dart';
import 'package:task_management_app/features/tasks/data/repository/task_repository.dart';
import 'package:task_management_app/features/tasks/presentation/bloc/task_cubit.dart';
import 'package:task_management_app/features/tasks/data/repository/onboard_repository.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // External
  sl.registerLazySingleton(() => Dio());

  sl.registerLazySingletonAsync<SharedPreferences>(() => SharedPreferences.getInstance());
  await sl.isReady<SharedPreferences>();

  //  Core Network
  sl.registerLazySingleton(() => DioClient(sl()));
  sl.registerLazySingleton(() => NetworkExecutor(sl<DioClient>().dio));

  //  Repository 
  sl.registerLazySingleton(() => TaskRepository(
    executor: sl(),
    sharedPreferences: sl(), 
  ));

  // Cubit
  sl.registerFactory(() => TaskCubit(taskRepository: sl()));
  
  // Onboard Repository
  sl.registerLazySingleton(() => OnboardRepository());
}