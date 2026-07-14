import 'package:flutter/material.dart';

class AsistenciaStatsRow extends StatelessWidget {
  const AsistenciaStatsRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            icon: Icons.monetization_on_outlined,
            iconColor: const Color(0xFF3E77BC),
            title: 'PAGOS PENDIENTES`',
            value: '11',
            valueColor: const Color(0xFF0F172A),
            backgroundColor: const Color(0xFFF1F5F9), // Gris azulado muy claro
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _StatCard(
            icon: Icons.campaign_outlined, // Icono de megáfono para comunicados
            iconColor: const Color(0xFF8B5CF6), // Morado
            title: 'PROGRAMACION DE',
            value: 'Juntas ',
            valueColor: const Color(0xFF8B5CF6),
            backgroundColor: const Color(0xFFF5F3FF), // Morado muy claro
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String value;
  final Color valueColor;
  final Color backgroundColor;

  const _StatCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.value,
    required this.valueColor,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.black.withValues(alpha: 0.03),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor, size: 28),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: Color(0xFF64748B),
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: valueColor,
              height: 1.1,
            ),
          ),
        ],
      ),
    );
  }
}
