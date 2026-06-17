import 'package:finansale/features/auth/presentation/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:finansale/features/splash/presentation/splash_page.dart';

class AppRouter {
  static final GlobalKey<NavigatorState> rootNavigatorKey =
      GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: '/splash',
    routes: [
      GoRoute(path: '/splash', builder: (context, state) => const SplashPage()),
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),

      GoRoute(
        path: '/hub',
        builder: (context, state) => const Scaffold(
          body: Center(child: Text('Hub Principal (Conexión Exitosa)')),
        ),
      ),
    ],
  );
}
