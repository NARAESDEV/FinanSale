import 'package:flutter/material.dart';

class BadgeReinforcementCard extends StatelessWidget {
  final String title;
  final String description;

  const BadgeReinforcementCard({
    super.key,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    const blueColor = Color(0xFF1E3A8A); // Azul oscuro para texto destacado
    const lightBgColor = Color(0xFFEFF6FF); // Fondo azul muy claro
    const primaryColor = Color(0xFF1E293B);
    const mutedColor = Color(0xFF475569);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: lightBgColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.blue.withValues(alpha: 0.08),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Icono con destellos
          Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Icon(
                Icons.auto_awesome,
                color: Color(0xFF3E77BC),
                size: 24,
              ),
            ),
          ),
          const SizedBox(width: 16),

          // Textos motivacionales
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: blueColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 13,
                    color: mutedColor,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
