import 'package:finansale/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:finansale/features/auth/presentation/cubit/auth_state.dart';
import 'package:finansale/features/hub/presentation/cubit/perfil_cubit.dart';
import 'package:finansale/features/hub/presentation/perfil_page.dart';
import 'package:finansale/features/rh/data/datasources/rh_remote_data_source.dart';
import 'package:finansale/features/rh/domain/repositories/rh_repository_impl.dart';
import 'package:finansale/features/rh/presentation/cubit/aprobaciones_cubit.dart';
import 'package:finansale/features/rh/presentation/cubit/solicitudes_cubit.dart';
import 'package:finansale/features/rh/presentation/cubit/subtipos/subtipos_cubit.dart';
import 'package:finansale/features/rh/presentation/cubit/tipos/tipos_cubit.dart';
import 'package:finansale/features/rh/presentation/cubit/usuarios_sustitucion/usuarios_sustitucion_cubit.dart';
import 'package:finansale/features/rh/presentation/pages/historial_page.dart';
import 'package:finansale/features/rh/presentation/pages/aprobaciones_pendientes_page.dart';
import 'package:finansale/features/rh/presentation/pages/estado_solicitudes_page.dart';
import 'package:finansale/features/rh/presentation/pages/nueva_solicitud_page.dart';
import 'package:finansale/features/rh/presentation/pages/solicitudes_page.dart';
import 'package:finansale/features/splash/presentation/splash_page.dart';
import 'package:finansale/features/workspace/cubit/workspace_cubit.dart';
import 'package:finansale/features/workspace/presentation/workspace_page.dart';
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
    initialLocation: '/splash',
    // initialLocation: '/login',
    routes: [
      GoRoute(path: '/splash', builder: (context, state) => const SplashPage()),
      GoRoute(
        path: '/workspace',
        builder: (context, state) => BlocProvider(
          create: (context) => WorkspaceCubit(),
          child: const WorkspacePage(),
        ),
      ),
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),

      // Protegemos el Hub para que no se salga de la app con un gesto
      GoRoute(
        path: '/hub',
        builder: (context, state) => const NavGuard(child: HubScreen()),
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
      GoRoute(
        path: '/estado-solicitudes',
        builder: (context, state) => BlocProvider(
          create: (context) {
            final user =
                (context.read<AuthCubit>().state as AuthAuthenticated).user;
            return SolicitudesCubit()..getMisSolicitudes(user);
          },
          child: const EstadoSolicitudesPage(),
        ),
      ),
      ShellRoute(
        builder: (context, state, child) => MainWrapper(child: child),
        routes: [
          GoRoute(
            path: '/rh-dashboard',

            builder: (context, state) => const RhDashboardPage(),
          ),

          GoRoute(
            path: '/solicitudes',
            pageBuilder: (context, state) => NoTransitionPage(
              child: MultiBlocProvider(
                providers: [
                  // 1. Cubit para Enviar el Formulario (Evita tu error rojo)
                  BlocProvider<SolicitudesCubit>(
                    create: (context) => SolicitudesCubit(),
                  ),
                  // 2. Cubit para traer los Tipos (Lo disparamos al abrir la pantalla)
                  BlocProvider<TiposCubit>(
                    create: (context) {
                      final authState = context.read<AuthCubit>().state;
                      final cubit = TiposCubit(
                        RhRepositoryImpl(RhRemoteDataSource()),
                      );
                      if (authState is AuthAuthenticated) {
                        cubit.fetchTipos(authState.user);
                      }
                      return cubit;
                    },
                  ),
                  // 3. Cubit de Subtipos (Nace pausado, se dispara al elegir el Tipo)
                  BlocProvider<SubtiposCubit>(
                    create: (context) =>
                        SubtiposCubit(RhRepositoryImpl(RhRemoteDataSource())),
                  ),
                  BlocProvider<UsuariosSustitucionCubit>(
                    create: (context) => UsuariosSustitucionCubit(
                      RhRepositoryImpl(RhRemoteDataSource()),
                    ),
                  ),
                ],
                child: const NuevaSolicitudPage(),
              ),
            ),
          ),
          GoRoute(
            path: '/historial',
            pageBuilder: (context, state) => NoTransitionPage(
              child: BlocProvider<SolicitudesCubit>(
                create: (context) {
                  final authState = context.read<AuthCubit>().state;

                  // Validación segura para evitar crash si el estado de Auth parpadea
                  if (authState is AuthAuthenticated) {
                    return SolicitudesCubit()
                      ..getMisSolicitudes(authState.user);
                  }

                  // Fallback por seguridad
                  return SolicitudesCubit();
                },
                child: const HistorialPage(),
              ),
            ),
          ),
          GoRoute(
            path: '/perfil',
            pageBuilder: (context, state) => NoTransitionPage(
              // Inyección del Cubit
              child: BlocProvider<PerfilCubit>(
                create: (context) {
                  final authState = context.read<AuthCubit>().state;
                  if (authState is AuthAuthenticated) {
                    return PerfilCubit()..getPerfilUsuario(authState.user);
                  }
                  return PerfilCubit();
                },
                child: const PerfilPage(),
              ),
            ),
          ),
        ],
      ),
    ],
  );
}
