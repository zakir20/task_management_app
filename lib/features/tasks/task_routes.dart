import 'package:go_router/go_router.dart';
import 'presentation/screens/welcome_screen.dart';
import 'presentation/screens/dashboard_screen.dart';
import 'presentation/screens/add_task_screen.dart';

class TaskRoutes {
  static const String welcome = '/';
  static const String dashboard = '/dashboard';
  static const String addTask = '/add-task';

  static List<GoRoute> routes = [
    GoRoute(
      path: welcome,
      name: welcome,
      builder: (context, state) => const WelcomeScreen(),
    ),
    GoRoute(
      path: dashboard,
      name: dashboard,
      builder: (context, state) => const DashboardScreen(),
    ),
    GoRoute(
      path: addTask,
      name: addTask,
      builder: (context, state) => const AddTaskScreen(),
    ),
  ];
}