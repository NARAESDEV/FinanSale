import 'package:finansale/shared/widgets/anuncio_card.dart';
import 'package:finansale/shared/widgets/naraes_header.dart';
import 'package:finansale/shared/widgets/personalizado_card.dart';
import 'package:finansale/shared/widgets/rh_widgets.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RhDashboardPage extends StatelessWidget {
  const RhDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. EL GUARDIÁN DE NAVEGACIÓN (PopScope)
    return PopScope(
      canPop: false, // Bloqueamos la salida nativa para que no cierre la app
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;

        // Al usar .go('/hub'), reseteamos la pila hacia el selector de módulos
        // Esto evita que el usuario se quede "atrapado" o salga de la app
        context.go('/hub');
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF9FCFF),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              // 2. HEADER: Información de usuario y barra de progreso (61%)
              _buildHeader(),

              // 3. CUERPO: Contenido que "muerde" el header
              Transform.translate(
                offset: const Offset(0, -40),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      // WIDGET: Resumen estadístico (Círculos Goce, Plan, Ley)
                      _buildResumenPeriodo(),

                      const SizedBox(height: 20),

                      // WIDGET: Estado de última solicitud (Stepper de pasos)
                      const PersonalizadoCard(child: StatusStepper()),

                      const SizedBox(height: 25),

                      // SECCIÓN: Aprobaciones Pendientes
                      const _SectionHeader(title: "Aprobaciones Pendientes"),
                      const SizedBox(height: 10),
                      _buildAprobacionBrenda(),

                      const SizedBox(height: 25),

                      // WIDGET: Card de Anuncios (Comunicados)
                      const _SectionHeader(title: "ANUNCIOS"),
                      const SizedBox(height: 10),
                      const AnuncioCard(
                        title: "¡Felicidades a los cumpleañeros!",
                        description:
                            "Revisa quién cumple años este mes en tu equipo y envíales un saludo.",
                        imageUrl:
                            "https://images.unsplash.com/photo-1513151233558-d860c5398176?q=80&w=1000&auto=format&fit=crop",
                        category: "CUMPLEAÑOS",
                        icon: Icons.cake_rounded,
                        iconColor: Colors.pinkAccent,
                      ),

                      // Espacio para evitar que el Navbar tape el contenido final
                      const SizedBox(height: 120),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- MÉTODOS DE APOYO (HELPERS) ---

  // Construye el encabezado azul
  Widget _buildHeader() {
    return NaraesHeader(
      title: "Josue Israel",
      bottomWidget: Column(
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Progreso de Días",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "61%",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const LinearProgressIndicator(
            value: 0.61,
            backgroundColor: Colors.white24,
            color: Colors.white,
            minHeight: 8,
          ),
        ],
      ),
    );
  }

  // Construye la card de círculos (Gráfica)
  Widget _buildResumenPeriodo() {
    return PersonalizadoCard(
      child: Column(
        children: [
          const Text(
            "RESUMEN DEL PERIODO 2025-2026",
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w900,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 20),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              CircularStat(value: "14", label: "GOCE", color: Colors.green),
              CircularStat(value: "10", label: "PLAN", color: Colors.orange),
              CircularStat(value: "24", label: "LEY", color: Color(0xFF3E77BC)),
            ],
          ),
        ],
      ),
    );
  }

  // Construye la fila de aprobación
  Widget _buildAprobacionBrenda() {
    return const PersonalizadoCard(
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: CircleAvatar(
          backgroundColor: Color(0xFF3E77BC),
          child: Icon(Icons.person, color: Colors.white),
        ),
        title: Text(
          "Brenda González",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text("Vacaciones Anuales • 6 días"),
        trailing: Icon(Icons.chevron_right),
      ),
    );
  }
}

// Widget auxiliar para los títulos de sección
class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const Text(
          "Ver todas",
          style: TextStyle(
            color: Color(0xFF3E77BC),
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
