import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/widgets/naraes_header.dart';
import '../../../shared/widgets/personalizado_card.dart';

class HubScreen extends StatelessWidget {
  const HubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FCFF),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 1. HEADER REUTILIZABLE
            const NaraesHeader(
              title: "Josue Israel",
              subtitle: "Ssr. Frontend Engineer",
              isCompact: false,
            ),

            // 2. CONTENIDO FLOTANTE
            Transform.translate(
              offset: const Offset(0, -10),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --- SECCIÓN: BALANCE ---
                    const SizedBox(height: 45),

                    // --- SECCIÓN: MÓDULOS DE GESTIÓN (RH, Finanzas, etc.) ---
                    const Text(
                      "MÓDULOS DISPONIBLES",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF64748B),
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 15),
                    _buildModulesGrid(context),

                    const SizedBox(height: 25),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- WIDGET: GRID DE MÓDULOS (RH, Finanzas, Ticket NS) ---
  Widget _buildModulesGrid(BuildContext context) {
    // Definimos los módulos dinámicamente para que sea fácil agregar más
    final modules = [
      {
        'title': 'RH',
        'icon': Icons.groups_outlined,
        'color': Color(0xFF3E77BC),
      },
      {
        'title': 'Finanzas',
        'icon': Icons.account_balance_wallet_outlined,
        'color': Color(0xFF10B981),
      },
      {
        'title': 'Ticket NS',
        'icon': Icons.confirmation_number_outlined,
        'color': Color(0xFFF59E0B),
      },
      {
        'title': 'Mi Perfil',
        'icon': Icons.person_outline,
        'color': Color(0xFF8B5CF6),
      },
    ];

    return Wrap(
      spacing: 15,
      runSpacing: 15,
      children: modules.map((m) {
        return SizedBox(
          width:
              (MediaQuery.of(context).size.width / 2) -
              28, // Ajuste para 2 columnas
          child: PersonalizadoCard(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
            child: InkWell(
              onTap: () => print("Navegando a ${m['title']}"),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: (m['color'] as Color).withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      m['icon'] as IconData,
                      color: m['color'] as Color,
                      size: 28,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    m['title'] as String,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
