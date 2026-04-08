import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainWrapper extends StatelessWidget {
  final Widget child;
  const MainWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: Container(
        height: 90,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _navBtn(context, Icons.home_rounded, "Inicio", "/rh-dashboard"),
            _navBtn(
              context,
              Icons.assignment_outlined,
              "Solicitudes",
              "/solicitudes",
            ),
            _navBtn(context, Icons.history, "Historial", "/historial"),
            _navBtn(context, Icons.person_outline, "Perfil", "/perfil"),
          ],
        ),
      ),
    );
  }

  Widget _navBtn(
    BuildContext context,
    IconData icon,
    String label,
    String route,
  ) {
    bool isSel = GoRouterState.of(context).uri.path == route;
    return InkWell(
      onTap: () => context.go(route),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: isSel ? const Color(0xFF3E77BC) : Colors.grey),
          Text(
            label,
            style: TextStyle(
              color: isSel ? const Color(0xFF3E77BC) : Colors.grey,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}
