import 'package:flutter/material.dart';
import '../widgets/asistencia_header_widget.dart';
import '../widgets/child_status_card.dart';
import '../widgets/asistencia_stats_row.dart';

class AsistenciaDashboardPage extends StatelessWidget {
  const AsistenciaDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final mediaQueryData = MediaQuery.of(context);
    final isIOS = Theme.of(context).platform == TargetPlatform.iOS;
    
    // Evitamos jank visual y distorsiones del texto en iOS (especialmente Pro Max con accesibilidad/Dynamic Type)
    // limitando el factor de escala a un rango controlado y seguro.
    final adjustedMediaQueryData = isIOS
        ? mediaQueryData.copyWith(
            textScaleFactor: mediaQueryData.textScaleFactor.clamp(1.0, 1.15),
          )
        : mediaQueryData;

    Widget bodyContent = Column(
      children: [
        // 1. Header estático en la parte superior
        const Padding(
          padding: EdgeInsets.fromLTRB(20.0, 24.0, 20.0, 16.0),
          child: AsistenciaHeaderWidget(
            tutorName: 'Antonio Cornelio',
            avatarUrl: 'https://i.pravatar.cc/150?img=47',
          ),
        ),

        // Contenido escroleable
        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  // 2. Título de sección "Mis Hijos" y Fecha
                  const Text(
                    'Lunes, 24 de Oct',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF64748B),
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Mis Hijos',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF0F172A),
                      letterSpacing: -0.5,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // 3. Tarjetas de Hijos
                  const ChildStatusCard(
                    avatarUrl: 'https://i.pravatar.cc/150?img=11',
                    childName: 'Josue Israel Vasquez',
                    grade: 'Grado 3',
                    group: 'Grupo A',
                    isInSchool: true,
                    statusLabel: 'En la escuela',
                    lastUpdateLabel: 'Última actualización',
                    time: '08:15 AM',
                    statusMessage: 'Entrada a las instalaciones escolares',
                  ),

                  const ChildStatusCard(
                    avatarUrl: 'https://i.pravatar.cc/150?img=5',
                    childName: 'Mia ',
                    grade: 'Grado 1',
                    group: 'Grupo C',
                    isInSchool: false,
                    statusLabel: 'Ya salió',
                    lastUpdateLabel: 'Salida registrada',
                    time: '03:45 PM',
                    statusMessage: 'Salida de las instalaciones escolares',
                  ),

                  const SizedBox(height: 8),

                  // 4. Resumen / Estadísticas Inferiores
                  const AsistenciaStatsRow(),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
      ],
    );

    // Si es iOS y pantalla ancha (ej. Pro Max), centramos el layout con un MaxWidth 
    // para evitar que los elementos y los textos se estiren o ensanchen de manera desproporcionada.
    Widget rootWidget = SafeArea(
      child: bodyContent,
    );

    if (isIOS) {
      rootWidget = Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: rootWidget,
        ),
      );
    }

    return MediaQuery(
      data: adjustedMediaQueryData,
      child: Scaffold(
        // Usamos un fondo claro y estático para evitar sobrecargas de repintado
        backgroundColor: Colors.white,
        body: rootWidget,
      ),
    );
  }
}
