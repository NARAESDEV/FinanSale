import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/asistencia_header_widget.dart';
import '../widgets/child_status_card.dart';
import '../widgets/asistencia_stats_row.dart';
import '../widgets/asistencia_navbar.dart';
import '../state/asistencia_state.dart';
import 'soluciones_page.dart';

class AsistenciaDashboardPage extends StatefulWidget {
  const AsistenciaDashboardPage({super.key});

  @override
  State<AsistenciaDashboardPage> createState() =>
      _AsistenciaDashboardPageState();
}

class _AsistenciaDashboardPageState extends State<AsistenciaDashboardPage> {
  int _selectedIndex = 0;
  bool _solucionesVisited = false;

  void _onDestinationSelected(int index) {
    if (_selectedIndex == index) return;
    setState(() {
      _selectedIndex = index;
      if (index == 1) {
        _solucionesVisited = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Usamos un fondo claro y estático para evitar sobrecargas de repintado
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Vista 0: Inicio (siempre construida desde el inicio, conservando su estado y scroll)
          Offstage(
            offstage: _selectedIndex != 0,
            child: TickerMode(
              enabled: _selectedIndex == 0,
              child: const _AsistenciaInicioView(),
            ),
          ),

          // Vista 1: Soluciones (creación lazy la primera vez que el usuario la visita)
          if (_solucionesVisited)
            Offstage(
              offstage: _selectedIndex != 1,
              child: TickerMode(
                enabled: _selectedIndex == 1,
                child: const SolucionesPage(),
              ),
            ),
        ],
      ),
      bottomNavigationBar: AsistenciaNavbar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onDestinationSelected,
      ),
    );
  }
}

/// Vista del Home actual conservada EXACTAMENTE en su diseño, lógica, widgets y comportamiento.
/// Colocada como widget independiente para prevenir reconstrucciones innecesarias dentro del shell de navegación.
class _AsistenciaInicioView extends StatelessWidget {
  const _AsistenciaInicioView();

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
        Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 24.0, 20.0, 16.0),
          child: AsistenciaHeaderWidget(
            tutorName: 'Antonio Cornelio',
            avatarUrl: 'https://i.pravatar.cc/150?img=47',
            onProfileTap: () => context.push('/asistencia/ajustes'),
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

                  // 3. Tarjetas de Hijos (Dinámicas con AsistenciaState)
                  AnimatedBuilder(
                    animation: AsistenciaState.instance,
                    builder: (context, _) {
                      final list = AsistenciaState.instance.hijosConfirmados;
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.zero,
                        itemCount: list.length,
                        itemBuilder: (context, idx) {
                          final kid = list[idx];
                          return ChildStatusCard(
                            key: ValueKey(kid['childName']),
                            avatarUrl: kid['avatarUrl'] ?? '',
                            childName: kid['childName'] ?? '',
                            grade: kid['grade'] ?? '',
                            group: kid['group'] ?? '',
                            isInSchool: kid['isInSchool'] ?? false,
                            statusLabel: kid['statusLabel'] ?? '',
                            lastUpdateLabel: kid['lastUpdateLabel'] ?? '',
                            time: kid['time'] ?? '',
                            statusMessage: kid['statusMessage'] ?? '',
                          );
                        },
                      );
                    },
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
    Widget rootWidget = SafeArea(child: bodyContent);

    if (isIOS) {
      rootWidget = Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: rootWidget,
        ),
      );
    }

    return MediaQuery(data: adjustedMediaQueryData, child: rootWidget);
  }
}
