import 'package:finansale/core/navigation/app_router.dart';
import 'package:finansale/core/theme/app_theme.dart';
import 'package:finansale/features/auth/presentation/login_screen.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: AppRouter.router,
      theme: NaraesTheme.lightTheme,
      title: 'Material App',
    );
  }
}
