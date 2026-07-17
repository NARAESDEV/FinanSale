import 'package:flutter/material.dart';

class AsistenciaActivity {
  final String title;
  final String time;
  final String description;
  final bool
  isArrival; // Determina el color (azul para llegada, morado para salida)

  const AsistenciaActivity({
    required this.title,
    required this.time,
    required this.description,
    required this.isArrival,
  });
}

class ActivityTimeline extends StatelessWidget {
  final List<AsistenciaActivity> activities;
  final String dateText;

  const ActivityTimeline({
    super.key,
    required this.activities,
    required this.dateText,
  });

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF0F172A);
    const mutedColor = Color(0xFF64748B);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Fila de título de sección y fecha
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Actividad de Ayer',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
            Text(
              dateText,
              style: const TextStyle(
                fontSize: 13,
                color: mutedColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // Lista de items de la línea de tiempo
        if (activities.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 24.0),
            child: Center(
              child: Text(
                'Sin actividad registrada hoy.',
                style: TextStyle(color: mutedColor, fontSize: 14),
              ),
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics:
                const NeverScrollableScrollPhysics(), // Scroll gestionado por CustomScrollView padre
            padding: EdgeInsets.zero,
            itemCount: activities.length,
            itemBuilder: (context, index) {
              final activity = activities[index];
              final isLast = index == activities.length - 1;
              return _TimelineItem(activity: activity, isLast: isLast);
            },
          ),
      ],
    );
  }
}

class _TimelineItem extends StatelessWidget {
  final AsistenciaActivity activity;
  final bool isLast;

  const _TimelineItem({required this.activity, required this.isLast});

  @override
  Widget build(BuildContext context) {
    const blueColor = Color(0xFF3E77BC);
    const purpleColor = Color(0xFF8B5CF6);
    final themeColor = activity.isArrival ? blueColor : purpleColor;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Lado Izquierdo: El indicador visual de línea de tiempo
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              children: [
                // Círculo indicador
                Container(
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(color: themeColor, width: 3.5),
                  ),
                  child: Center(
                    child: Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: themeColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
                // Línea conectora
                if (!isLast)
                  Expanded(
                    child: Container(width: 2, color: Colors.grey.shade200),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 8),

          // Lado Derecho: La tarjeta con la información
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24.0),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.grey.withValues(alpha: 0.08),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.02),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          activity.title,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: themeColor,
                          ),
                        ),
                        // Badge de hora
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            activity.time,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF475569),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      activity.description,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF475569),
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
