import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/tasks/task_routes.dart';

class AppRouter {
  AppRouter._();

  static final navigatorKey = GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: TaskRoutes.welcome,
    routes: [
      ...TaskRoutes.routes,
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(child: Text('No route defined for ${state.uri}')),
    ),
  );

  static Future<T?> push<T extends Object?>(
    BuildContext context,
    String path, {
    Object? extra,
  }) {
    return context.push<T>(path, extra: extra);
  }
}