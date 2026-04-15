import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);

    // Listener de alto rendimiento: Escucha el estado de la animación
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        // En el milisegundo que termina, redirige al Login (o al Dashboard si ya hay sesión)
        if (mounted) {
          context.go('/login');
        }
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose(); // Evita fugas de memoria (Memory Leaks)
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FCFF), // Tu color de fondo corporativo
      body: Center(
        child: Lottie.asset(
          'assets/animations/NARAESV1.json', // COLOCA AQUÍ LA RUTA DE TU LOTTIE
          controller: _controller,
          onLoaded: (composition) {
            // Ajusta la duración del controller a la duración real del Lottie
            _controller.duration = composition.duration;
            // Inicia la animación
            _controller.forward();
          },
        ),
      ),
    );
  }
}
