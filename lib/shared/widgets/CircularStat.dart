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
  // Agregamos el parámetro que faltaba
  final String estado;

  const StatusStepper({super.key, required this.estado});

  @override
  Widget build(BuildContext context) {
    // Lógica para determinar el progreso según el String del backend
    final bool isEnviada =
        estado == "Enviada" || estado == "Pendiente" || estado == "Aprobada";
    final bool isPendiente = estado == "Pendiente" || estado == "Aprobada";
    final bool isAprobada = estado == "Aprobada";

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
      child: Row(
        children: [
          _step(
            Icons.check_circle,
            "Enviada",
            isEnviada,
            isCurrent: estado == "Enviada",
          ),
          _line(isPendiente),
          _step(
            Icons.access_time_filled,
            "Pendiente",
            isPendiente,
            isCurrent: estado == "Pendiente",
          ),
          _line(isAprobada),
          _step(
            Icons.radio_button_unchecked,
            "Aprobada",
            isAprobada,
            isCurrent: estado == "Aprobada",
          ),
        ],
      ),
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
        Icon(
          isCurrent ? icon : (active ? Icons.check_circle : icon),
          color: color,
          size: 28,
        ),
        const SizedBox(height: 4),
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
