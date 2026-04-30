import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/cubit/auth_cubit.dart';
import '../../shared/widgets/personalizado_card.dart'; // Tu widget
import '../../core/navigation/app_router.dart';

class SessionManager extends StatefulWidget {
  final Widget child;
  const SessionManager({super.key, required this.child});

  @override
  State<SessionManager> createState() => _SessionManagerState();
}

class _SessionManagerState extends State<SessionManager>
    with WidgetsBindingObserver {
  Timer? _inactivityTimer;
  // Tiempos para pruebas
  static const _inactivityDuration = Duration(seconds: 1500);
  static const _graceDuration = Duration(seconds: 300);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _startTimer();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _inactivityTimer?.cancel();
    super.dispose();
  }

  DateTime? _pausedTime;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      // Guardamos la hora en que la app se fue a 2do plano (ej: abrir cámara)
      _pausedTime = DateTime.now();
    } else if (state == AppLifecycleState.resumed) {
      if (_pausedTime != null) {
        final diff = DateTime.now().difference(_pausedTime!);
        // Si estuvo en 2do plano más de 5 minutos, forzamos cierre de sesión
        if (diff.inMinutes >= 5) {
          _forceLogout();
        }
        _pausedTime = null;
      }
    }
  }

  void _startTimer() {
    _inactivityTimer?.cancel();
    _inactivityTimer = Timer(_inactivityDuration, _showWarningDialog);
  }

  void _forceLogout() {
    _inactivityTimer?.cancel();
    _isDialogShowing = false;
    // Usamos el Cubit para limpiar estado
    // context.read<AuthCubit>().logout();
    // // Redirigimos al Login
    // context.go('/login');
    AppRouter.rootNavigatorKey.currentContext?.go('/login');
  }

  bool _isDialogShowing = false;
  void _showWarningDialog() {
    if (_isDialogShowing) return; // Si ya está abierta, no hagas nada
    _isDialogShowing = true;
    final navContext = AppRouter.rootNavigatorKey.currentContext;
    if (navContext == null) return;

    _inactivityTimer?.cancel();

    showDialog(
      context: navContext,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: PersonalizadoCard(
          // REUTILIZANDO TU WIDGET
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.timer_outlined,
                size: 50,
                color: Color(0xFF3E77BC),
              ),
              const SizedBox(height: 15),
              SizedBox(
                width: double.infinity,
                child: Text(
                  "Tu sesión se cerrará pronto por inactividad.\n¿Sigues ahí?",
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 14),
                ),
              ),
              const SizedBox(height: 10),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3E77BC),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    _isDialogShowing = false;
                    Navigator.pop(context);
                    _startTimer(); // Reinicia el tiempo normal
                  },
                  child: const Text(
                    "CONTINUAR TRABAJANDO",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );

    // Iniciar tiempo de gracia
    _inactivityTimer = Timer(_graceDuration, () {
      if (_isDialogShowing) {
        _isDialogShowing = false;
        // Cerrar modal si sigue abierta
        if (Navigator.of(navContext).canPop()) {
          Navigator.of(navContext).pop();
        }
        _forceLogout();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      behavior: HitTestBehavior.translucent,
      onPointerDown: (_) => _startTimer(),
      child: widget.child,
    );
  }
}
