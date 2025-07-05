import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:myapp/ui/auth/login_screen.dart';
import 'package:myapp/ui/auth/signup_screen.dart';
import 'package:myapp/ui/tasks/create_task_screen.dart';
import 'package:myapp/ui/tasks/tasklist_screen.dart';
import 'package:myapp/theme/app_theme.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = GoRouter(
      initialLocation: '/login',
      routes: [
        GoRoute(
          path: '/login',
          pageBuilder: (ctx, state) => CustomTransitionPage(
            key: state.pageKey,
            child: const LoginScreen(),
            transitionsBuilder: _fadeTransition,
          ),
        ),
        GoRoute(
          path: '/signup',
          pageBuilder: (ctx, state) => CustomTransitionPage(
            key: state.pageKey,
            child: const SignupScreen(),
            transitionsBuilder: _fadeTransition,
          ),
        ),
        GoRoute(
          path: '/tasks',
          pageBuilder: (ctx, state) => CustomTransitionPage(
            key: state.pageKey,
            child: const TaskListScreen(),
            transitionsBuilder: _slideFromRightTransition,
          ),
        ),
        GoRoute(
          path: '/create',
          pageBuilder: (ctx, state) => CustomTransitionPage(
            key: state.pageKey,
            child: const CreateTaskScreen(),
            transitionsBuilder: _slideFromBottomTransition,
          ),
        ),
      ],
      errorPageBuilder: (ctx, state) => MaterialPage(
        key: state.pageKey,
        child: Scaffold(
          body: Center(child: Text('Route error: ${state.error}')),
        ),
      ),
    );

    return MaterialApp.router(
      title: 'Todo App',
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: ThemeMode.system,
      routerConfig: router,
    );
  }

  static Widget _fadeTransition(
      BuildContext _, Animation<double> a, Animation<double> __, Widget child) {
    return FadeTransition(opacity: a, child: child);
  }

  static Widget _slideFromRightTransition(
      BuildContext _, Animation<double> a, Animation<double> __, Widget child) {
    final tween = Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero)
        .chain(CurveTween(curve: Curves.easeOut));
    return SlideTransition(position: a.drive(tween), child: child);
  }

  static Widget _slideFromBottomTransition(
      BuildContext _, Animation<double> a, Animation<double> __, Widget child) {
    final tween = Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
        .chain(CurveTween(curve: Curves.easeOut));
    return SlideTransition(position: a.drive(tween), child: child);
  }
}
