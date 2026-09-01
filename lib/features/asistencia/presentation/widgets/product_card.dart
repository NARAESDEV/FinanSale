import 'package:flutter/material.dart';

/// Tarjeta visual reutilizable para representar productos o soluciones de una empresa
/// (ej. TicketNS, FinanSale, Landing Page) con un diseño limpio, ligero y adaptable.
class ProductCard extends StatelessWidget {
  final String name;
  final String category;
  final String description;
  final String? imageAsset;
  final IconData? fallbackIcon;
  final String actionText;
  final VoidCallback? onActionPressed;

  const ProductCard({
    super.key,
    required this.name,
    required this.category,
    required this.description,
    this.imageAsset,
    this.fallbackIcon,
    this.actionText = 'Explorar solución',
    this.onActionPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 16),
      color: theme.cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: theme.dividerColor.withValues(alpha: 0.7),
          width: 1,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Sección superior visual: Imagen o banner temático consistente
          AspectRatio(
            aspectRatio: 16 / 7,
            child: imageAsset != null
                ? Image.asset(
                    imageAsset!,
                    fit: BoxFit.cover,
                    cacheWidth:
                        800, // Anti-jank para optimizar memoria de textura
                  )
                : Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          colorScheme.primary.withValues(alpha: 0.15),
                          colorScheme.primary.withValues(alpha: 0.05),
                        ],
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Icon(
                      fallbackIcon ?? Icons.widgets_outlined,
                      size: 44,
                      color: colorScheme.primary.withValues(alpha: 0.85),
                    ),
                  ),
          ),

          // Contenido inferior
          Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Etiqueta superior de Categoría
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    category.toUpperCase(),
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.6,
                      color: colorScheme.primary,
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // Nombre destacado del Producto
                Text(
                  name,
                  style: textTheme.titleMedium?.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: colorScheme.onSurface,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 6),

                // Descripción
                Text(
                  description,
                  style: textTheme.bodyMedium?.copyWith(
                    fontSize: 13.5,
                    height: 1.4,
                    color: colorScheme.onSurface.withValues(alpha: 0.75),
                  ),
                ),
                const SizedBox(height: 16),

                // Acción o botón inferior
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton.icon(
                    onPressed: onActionPressed ?? () {},
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      backgroundColor: colorScheme.primary.withValues(
                        alpha: 0.08,
                      ),
                    ),
                    icon: Icon(
                      Icons.arrow_forward_rounded,
                      size: 18,
                      color: colorScheme.primary,
                    ),
                    label: Text(
                      actionText,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: colorScheme.primary,
                      ),
                    ),
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
