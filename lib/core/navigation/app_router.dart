import 'package:finansale/shared/widgets/nav_guard.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/hub/presentation/hub_screen.dart';
import '../../features/hub/presentation/main_wrapper.dart';
import '../../features/rh/presentation/rh_dashboard_page.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/login',
    routes: [
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),

      // Protegemos el Hub para que no se salga de la app con un gesto
      GoRoute(
        path: '/hub',
        builder: (context, state) => const NavGuard(child: HubScreen()),
      ),

      ShellRoute(
        builder: (context, state, child) => MainWrapper(child: child),
        routes: [
          GoRoute(
            path: '/rh-dashboard',
            builder: (context, state) => const NavGuard(
              // Si estamos en RH y damos atrás, no cerramos la app
              child: RhDashboardPage(),
            ),
          ),
        ],
      ),
    ],
  );
}
