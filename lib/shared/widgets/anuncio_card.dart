import 'package:flutter/material.dart';
import 'personalizado_card.dart';

class AnuncioCard extends StatelessWidget {
  final String title;
  final String description;
  final String imageUrl;
  final String category;
  final IconData icon;
  final Color iconColor;

  const AnuncioCard({
    super.key,
    required this.title,
    required this.description,
    required this.imageUrl,
    this.category = "COMUNICADOS",
    this.icon = Icons.campaign,
    this.iconColor = Colors.orange,
  });

  @override
  Widget build(BuildContext context) {
    return PersonalizadoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Encabezado del anuncio
          Row(
            children: [
              Icon(icon, color: iconColor, size: 24),
              const SizedBox(width: 10),
              Text(
                category.toUpperCase(),
                style: const TextStyle(
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF1E293B),
                  fontSize: 12,
                  letterSpacing: 1.1,
                ),
              ),
            ],
          ),

          const SizedBox(height: 15),

          // Imagen del anuncio con bordes redondeados
          Container(
            height: 160,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              image: DecorationImage(
                image: NetworkImage(imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),

          const SizedBox(height: 15),

          // Título del anuncio
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Color(0xFF1E293B),
            ),
          ),

          const SizedBox(height: 5),

          // Descripción o cuerpo del anuncio
          Text(
            description,
            style: const TextStyle(
              color: Color(0xFF64748B),
              fontSize: 13,
              height: 1.4,
            ),
            maxLines: 2, // Limitamos líneas para mantener el diseño limpio
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
