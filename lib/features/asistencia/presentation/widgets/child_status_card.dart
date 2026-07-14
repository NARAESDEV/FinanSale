import 'package:flutter/material.dart';

class ChildStatusCard extends StatelessWidget {
  final String avatarUrl;
  final String childName;
  final String grade;
  final String group;
  final bool isInSchool; // Para cambiar colores y textos
  final String statusLabel; // ej. "En la escuela" o "Ya salió"
  final String lastUpdateLabel; // ej. "Última actualización" o "Salida registrada"
  final String time; // ej. "08:15 AM"
  final String statusMessage; // ej. "Llegó seguro en el transporte escolar."

  const ChildStatusCard({
    super.key,
    required this.avatarUrl,
    required this.childName,
    required this.grade,
    required this.group,
    required this.isInSchool,
    required this.statusLabel,
    required this.lastUpdateLabel,
    required this.time,
    required this.statusMessage,
  });

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF0F172A); // Texto principal oscuro
    const mutedColor = Color(0xFF64748B); // Texto secundario
    const blueColor = Color(0xFF3E77BC);
    const orangeColor = Color(0xFFF59E0B);
    const purpleColor = Color(0xFF8B5CF6);

    final statusBgColor = isInSchool ? const Color(0xFFE0E7FF) : const Color(0xFFFFEDD5);
    final statusTextColor = isInSchool ? blueColor : orangeColor;
    final timelineDotColor = isInSchool ? blueColor : purpleColor;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.1), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header del estudiante
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar con bordes redondeados
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  avatarUrl,
                  width: 56,
                  height: 56,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 56,
                    height: 56,
                    color: Colors.grey.shade200,
                    child: const Icon(Icons.person, color: Colors.grey),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Nombre y grado
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      childName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: [
                        _buildBadge(grade, const Color(0xFFE2E8F0), primaryColor),
                        _buildBadge(group, const Color(0xFFF1F5F9), mutedColor),
                      ],
                    ),
                  ],
                ),
              ),
              // Chip de Estado superior derecho
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: statusBgColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (!isInSchool)
                      const Padding(
                        padding: EdgeInsets.only(right: 4),
                        child: Icon(Icons.logout, size: 14, color: orangeColor),
                      )
                    else
                      Container(
                        margin: const EdgeInsets.only(right: 4),
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: blueColor.withValues(alpha: 0.7),
                          shape: BoxShape.circle,
                        ),
                      ),
                    Text(
                      statusLabel,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: statusTextColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 20),
          
          // Timeline Info Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Línea de tiempo visual (Simple con contenedores, sin custom paint para evitar jank)
                Column(
                  children: [
                    const SizedBox(height: 4),
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: timelineDotColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    Container(
                      width: 2,
                      height: 24,
                      color: Colors.grey.shade300,
                    ),
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade400,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 12),
                
                // Textos del timeline
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            lastUpdateLabel,
                            style: const TextStyle(
                              fontSize: 13,
                              color: mutedColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            time,
                            style: const TextStyle(
                              fontSize: 13,
                              color: mutedColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '"$statusMessage"',
                        style: const TextStyle(
                          fontSize: 14,
                          color: primaryColor,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget auxiliar para los chips pequeños (Grado/Grupo) extraído para rendimiento
  Widget _buildBadge(String text, Color bgColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
    );
  }
}
