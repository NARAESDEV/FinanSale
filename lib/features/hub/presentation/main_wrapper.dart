import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainWrapper extends StatelessWidget {
  final Widget child;
  const MainWrapper({super.key, required this.child});

  // Mapeamos las rutas a un índice para saber dónde posicionar la curva
  int _getSelectedIndex(String path) {
    if (path.startsWith('/rh-dashboard')) return 0;
    if (path.startsWith('/solicitudes')) return 1;
    if (path.startsWith('/historial')) return 2;
    if (path.startsWith('/perfil')) return 3;
    return 0; // Por defecto
  }

  @override
  Widget build(BuildContext context) {
    final currentPath = GoRouterState.of(context).uri.path;
    final selectedIndex = _getSelectedIndex(currentPath);

    // Calculamos el centro exacto del ícono seleccionado (va de 0.0 a 1.0)
    // Al tener 4 ítems, los centros están en 1/8, 3/8, 5/8 y 7/8.
    final loc = (selectedIndex + 0.5) / 4.0;

    return Scaffold(
      // IMPORTANTE: Permite que el fondo de la app se dibuje por debajo del área del menú
      extendBody: true,
      body: child,
      bottomNavigationBar: Container(
        height: 90,
        color: Colors.transparent, // Debe ser transparente para ver la curva
        child: TweenAnimationBuilder<double>(
          tween: Tween<double>(
            begin: loc,
            end: loc,
          ), // Crea la animación de deslizamiento
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
          builder: (context, animatedLoc, _) {
            return CustomPaint(
              painter: CurvedNavPainter(animatedLoc),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _navBtn(
                    context,
                    Icons.home_rounded,
                    "Inicio",
                    "/rh-dashboard",
                    currentPath,
                  ),
                  _navBtn(
                    context,
                    Icons.assignment_outlined,
                    "Solicitudes",
                    "/solicitudes",
                    currentPath,
                  ),
                  _navBtn(
                    context,
                    Icons.history,
                    "Historial",
                    "/historial",
                    currentPath,
                  ),
                  _navBtn(
                    context,
                    Icons.person_outline,
                    "Perfil",
                    "/perfil",
                    currentPath,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _navBtn(
    BuildContext context,
    IconData icon,
    String label,
    String route,
    String currentPath,
  ) {
    bool isSel = currentPath.startsWith(route);
    return Expanded(
      child: InkWell(
        onTap: () => context.go(route),
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Empuja el ícono hacia abajo cuando está seleccionado para encajar en el hueco
            SizedBox(height: isSel ? 12 : 0),
            Icon(
              icon,
              color: isSel ? const Color(0xFF3E77BC) : Colors.grey,
              size: 26,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSel ? const Color(0xFF3E77BC) : Colors.grey,
                fontSize: 11,
                fontWeight: isSel ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- EL "PINTOR" QUE DIBUJA LA BARRA, EL HUECO Y EL PUNTITO ---
class CurvedNavPainter extends CustomPainter {
  final double loc;
  CurvedNavPainter(this.loc);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color.fromARGB(255, 255, 255, 255)
      ..style = PaintingStyle.fill;

    final path = Path();
    const double cornerRadius = 30.0; // Bordes redondeados como en tu imagen

    // 1. Iniciar en la esquina superior izquierda
    path.moveTo(0, cornerRadius);
    path.quadraticBezierTo(0, 0, cornerRadius, 0);

    // 2. Calcular la posición del hueco (Notch) animado
    final center = loc * size.width;
    const curveWidth = 80.0; // Ancho del hueco
    const curveDepth = 25.0; // Profundidad del hueco

    // 3. Dibujar las curvas del hueco
    path.lineTo(center - curveWidth / 2, 0);
    path.cubicTo(
      center - curveWidth / 3,
      0,
      center - curveWidth / 4,
      curveDepth,
      center,
      curveDepth,
    );
    path.cubicTo(
      center + curveWidth / 4,
      curveDepth,
      center + curveWidth / 3,
      0,
      center + curveWidth / 2,
      0,
    );

    // 4. Continuar a la esquina superior derecha
    path.lineTo(size.width - cornerRadius, 0);
    path.quadraticBezierTo(size.width, 0, size.width, cornerRadius);

    // 5. Cerrar el trazo inferior
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    // 6. Aplicar la sombra y dibujar el fondo
    canvas.drawShadow(path, Colors.black12, 10, false);
    canvas.drawPath(path, paint);

    // 7. Dibujar el puntito blanco flotante encima del hueco
    canvas.drawCircle(Offset(center, curveDepth / 2 - 8), 5, paint);
  }

  @override
  bool shouldRepaint(covariant CurvedNavPainter oldDelegate) {
    return oldDelegate.loc != loc; // Solo redibujar si cambia de pestaña
  }
}
