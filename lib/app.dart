import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'injection/injection_container.dart';
import 'features/tasks/presentation/bloc/task_cubit.dart';
import 'core/navigation/app_router.dart';
import 'core/theme/app_colors.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => sl<TaskCubit>(),
        ),
      ],
      child: MaterialApp.router(
        title: 'Task Management App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: AppColors.scaffoldBg,
          useMaterial3: true,
          primaryColor: AppColors.primary,
        ),
        routerConfig: AppRouter.router, 
      ),
    );
  }
}