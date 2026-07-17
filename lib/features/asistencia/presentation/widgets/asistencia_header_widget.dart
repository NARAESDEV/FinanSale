import 'package:flutter/material.dart';

class AsistenciaHeaderWidget extends StatelessWidget {
  final String tutorName;
  final String avatarUrl; 
  final VoidCallback? onProfileTap;
  
  const AsistenciaHeaderWidget({
    super.key,
    required this.tutorName,
    required this.avatarUrl,
    this.onProfileTap,
  });

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF3E77BC);
    const surfaceColor = Color(0xFFF3F4F6); // Gris clarito para el fondo de botones
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Lado izquierdo: Avatar + Textos
        Row(
          children: [
            InkWell(
              onTap: onProfileTap,
              borderRadius: BorderRadius.circular(24),
              child: CircleAvatar(
                radius: 24,
                backgroundColor: Colors.grey.shade300,
                backgroundImage: NetworkImage(avatarUrl),
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Buenos días,',
                  style: TextStyle(
                    fontSize: 14,
                    color: primaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  tutorName, 
                  style: const TextStyle(
                    fontSize: 16,
                    color: primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
        
        // Lado derecho: Botones de notificaciones y chat
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Botón de notificaciones (Campana)
            Container(
              decoration: const BoxDecoration(
                color: surfaceColor,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.notifications_none_rounded),
                color: const Color(0xFF0F172A),
                iconSize: 22,
                onPressed: () {
                  // Acción de notificaciones
                },
              ),
            ),
            const SizedBox(width: 12),
            // Botón de Chat con badge rojo
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  decoration: const BoxDecoration(
                    color: surfaceColor,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.chat_bubble_outline_rounded),
                    color: const Color(0xFF0F172A),
                    iconSize: 20,
                    onPressed: () {
                      // Acción de chat
                    },
                  ),
                ),
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: Colors.redAccent,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
