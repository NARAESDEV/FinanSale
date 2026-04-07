import 'package:finansale/features/auth/presentation/forgot_password_screen.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/login_screen.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/login',
    routes: [
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(
        path: '/forgot-password',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
    ],
  );
}
