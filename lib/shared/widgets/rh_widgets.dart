import 'package:finansale/features/rh/data/models/rh_dashboard_model.dart';
import 'package:flutter/material.dart';

// 1. Círculos de Resumen (Goce, Plan, Ley)
class CircularStat extends StatelessWidget {
  final String value, label;
  final Color color;

  const CircularStat({
    super.key,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 75,
          height: 75,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: color.withOpacity(0.4), width: 4),
          ),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w900,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// 2. Stepper de Estado DINÁMICO
class StatusStepper extends StatelessWidget {
  final List<EstadoDetalle> estados;

  const StatusStepper({super.key, required this.estados});

  @override
  Widget build(BuildContext context) {
    if (estados.isEmpty) return const SizedBox();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        child: Row(
          children: estados.asMap().entries.map((entry) {
            int idx = entry.key;
            EstadoDetalle e = entry.value;
            bool isLast = idx == estados.length - 1;

            return Row(
              children: [
                _buildStep(e),
                if (!isLast) _buildLine(e.pasado || e.actual),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildStep(EstadoDetalle e) {
    Color color = e.actual
        ? const Color(0xFF3E77BC)
        : (e.pasado ? Colors.green : Colors.grey.shade300);
    IconData icon = e.pasado
        ? Icons.check_circle
        : (e.actual ? Icons.access_time_filled : Icons.radio_button_unchecked);

    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 4),
        Text(
          e.nombre,
          style: TextStyle(
            fontSize: 9,
            color: color,
            fontWeight: e.actual ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _buildLine(bool active) {
    return Container(
      width: 30,
      height: 2,
      color: active ? Colors.green : Colors.grey.shade200,
      margin: const EdgeInsets.only(bottom: 15),
    );
  }
}
