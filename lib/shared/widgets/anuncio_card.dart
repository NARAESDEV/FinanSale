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

          // ✅ Imagen con ClipRRect + Image.network con cacheWidth
          // Evita re-decodificación del JPEG en el raster thread
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.network(
              imageUrl,
              height: 160,
              width: double.infinity,
              fit: BoxFit.cover,
              cacheWidth: 600, // Limita decodificación a 600px de ancho
              errorBuilder: (context, error, stackTrace) => Container(
                height: 160,
                color: const Color(0xFFE2E8F0),
                child: const Center(
                  child: Icon(Icons.image_not_supported, color: Colors.grey),
                ),
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
