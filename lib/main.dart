import 'package:finansale/core/auth/session_manager.dart';
import 'package:finansale/core/theme/app_theme.dart';
import 'package:finansale/core/theme/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'core/navigation/app_router.dart';
import 'features/auth/data/datasources/auth_remote_datasource.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/presentation/cubit/auth_cubit.dart';

import 'package:finansale/features/rh/presentation/cubit/rh_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  final authDataSource = AuthRemoteDataSource();
  final authRepository = AuthRepository(authDataSource);

  runApp(
    MultiBlocProvider(
      providers: [
        // Store de Tema
        BlocProvider(create: (context) => ThemeCubit()),
        // Store de Autenticación
        BlocProvider(create: (context) => AuthCubit(authRepository)),
        // Store de Recursos Humanos
        BlocProvider(create: (context) => RhCubit()),
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, themeMode) {
        return MaterialApp.router(
          // showPerformanceOverlay: true,
          debugShowCheckedModeBanner: false,
          title: 'Naraes App',
          theme: NaraesTheme.lightTheme,
          darkTheme: NaraesTheme.darkTheme,
          themeMode: themeMode,
          routerConfig: AppRouter.router,
          builder: (context, child) {
            // El SessionManager envuelve a toda la navegación
            return SessionManager(child: child!);
          },
        );
      },
    );
  }
}
