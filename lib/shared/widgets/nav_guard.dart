import 'package:flutter/material.dart';

class NavGuard extends StatelessWidget {
  final Widget child;
  final bool canPop;
  final VoidCallback? onPopInvoked;

  const NavGuard({
    super.key,
    required this.child,
    this.canPop = false, // Por defecto no dejamos que el gesto cierre la app
    this.onPopInvoked,
  });

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: canPop,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        // Si el usuario intentó salir, aquí podemos ejecutar lógica
        // como mostrar un Toast de "Presiona de nuevo para salir"
        if (onPopInvoked != null) onPopInvoked!();
      },
      child: child,
    );
  }
}
