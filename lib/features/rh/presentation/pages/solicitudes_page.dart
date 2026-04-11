import 'package:flutter/material.dart';

class SolicitudesPage extends StatelessWidget {
  const SolicitudesPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Scaffold 100% const: Costo de renderizado = 0
    return const Scaffold(
      backgroundColor: Color(0xFFF9FCFF), // Fondo institucional
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.assignment_outlined, size: 80, color: Color(0xFFC0C8D4)),
            SizedBox(height: 16),
            Text(
              "Módulo de Solicitudes",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1F2937),
              ),
            ),
            SizedBox(height: 8),
            Text(
              "Pantalla en construcción para la próxima fase.",
              style: TextStyle(fontSize: 14, color: Color(0xFF64748B)),
            ),
          ],
        ),
      ),
    );
  }
}
