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
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Naraes App',
      routerConfig: AppRouter.router,
    );
  }
}
