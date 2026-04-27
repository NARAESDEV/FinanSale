import 'package:finansale/core/network/dio_client.dart';
import 'package:finansale/shared/services/storage_service.dart';
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

    _controller.addStatusListener((status) async {
      if (status == AnimationStatus.completed) {
        try {
          final savedUrl = await StorageService.instance.getWorkspace();

          if (!mounted) return;

          // Si hay URL, pre-configuramos Dio para que esté listo
          if (savedUrl != null) {
            DioClient.setBaseUrl(savedUrl);
          }

          // Tanto si hay URL como si no, el nuevo destino unificado es el Login
          context.go('/login');
        } catch (e) {
          debugPrint("Error crítico en DB durante Splash: $e");
          if (mounted) {
            context.go('/login'); // Fallback seguro
          }
        }
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FCFF),
      body: Center(
        child: Lottie.asset(
          'assets/animations/NARAESV1.json',
          controller: _controller,
          repeat: false,
          onLoaded: (composition) {
            _controller.duration = composition.duration;
            _controller.forward();
          },
        ),
      ),
    );
  }
}
