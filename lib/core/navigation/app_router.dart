import 'package:finansale/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:finansale/features/auth/presentation/cubit/auth_state.dart';
import 'package:finansale/features/rh/presentation/cubit/aprobaciones_cubit.dart';
import 'package:finansale/features/rh/presentation/pages/aprobaciones_pendientes_page.dart';
import 'package:finansale/shared/widgets/nav_guard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/hub/presentation/hub_screen.dart';
import '../../features/hub/presentation/main_wrapper.dart';
import '../../features/rh/presentation/rh_dashboard_page.dart';

class AppRouter {
  static final GlobalKey<NavigatorState> rootNavigatorKey =
      GlobalKey<NavigatorState>();
  static final router = GoRouter(
    navigatorKey: rootNavigatorKey,
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
              // El NavGuard se queda para proteger el botón de atrás
              child:
                  RhDashboardPage(), // Ya no marca error porque ya no pide 'estado'
            ),
          ),
          GoRoute(
            path: '/lista-aprobaciones',
            builder: (context, state) => BlocProvider(
              create: (context) {
                // Obtenemos el usuario y disparamos la petición al abrir la ruta
                final user =
                    (context.read<AuthCubit>().state as AuthAuthenticated).user;
                return AprobacionesCubit()..getListaAprobaciones(user);
              },
              child: AprobacionesPendientesPage(),
            ),
          ),
        ],
      ),
    ],
  );
}
