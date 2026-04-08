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

// 2. Stepper de Estado
class StatusStepper extends StatelessWidget {
  const StatusStepper({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _step(Icons.check_circle, "Enviada", true),
        _line(true),
        _step(Icons.access_time_filled, "Pendiente", true, isCurrent: true),
        _line(false),
        _step(Icons.radio_button_unchecked, "Aprobada", false),
      ],
    );
  }

  Widget _step(
    IconData icon,
    String label,
    bool active, {
    bool isCurrent = false,
  }) {
    Color color = active
        ? (isCurrent ? const Color(0xFF3E77BC) : Colors.green)
        : Colors.grey.shade300;
    return Column(
      children: [
        Icon(icon, color: color, size: 28),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: color,
            fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _line(bool active) {
    return Expanded(
      child: Container(
        height: 2,
        color: active ? Colors.green : Colors.grey.shade200,
        margin: const EdgeInsets.only(bottom: 15),
      ),
    );
  }
}
