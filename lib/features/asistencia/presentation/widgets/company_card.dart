import 'package:flutter/material.dart';

/// Tarjeta reutilizable y configurable para representar a cualquier empresa en la sección Soluciones
/// (ej. NARAES, ALCOPTEC SYSTEMS), optimizada para alto rendimiento e independencia visual.
class CompanyCard extends StatelessWidget {
  final String name;
  final String subtitle;
  final String description;
  final String? headerImageAsset;
  final String? logoAsset;
  final IconData? fallbackIcon;
  final String buttonText;
  final String? badgeLabel;
  final VoidCallback onSeeSolutions;

  const CompanyCard({
    super.key,
    required this.name,
    required this.subtitle,
    required this.description,
    this.headerImageAsset,
    this.logoAsset,
    this.fallbackIcon,
    this.buttonText = 'Ver soluciones',
    this.badgeLabel,
    required this.onSeeSolutions,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 22),
      color: theme.cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(
          color: theme.dividerColor.withValues(alpha: 0.8),
          width: 1,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Banner superior de imagen, logo o representación temática
          AspectRatio(
            aspectRatio: 16 / 8,
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Fondo del banner
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        colorScheme.primary.withValues(alpha: 0.14),
                        colorScheme.primary.withValues(alpha: 0.04),
                      ],
                    ),
                  ),
                  child: _buildHeaderGraphic(colorScheme),
                ),

                // Etiqueta flotante opcional (Badge) en la esquina superior izquierda
                if (badgeLabel != null)
                  Positioned(
                    top: 14,
                    left: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme.surface,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(
                              0xFF0F172A,
                            ).withValues(alpha: 0.08),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                        border: Border.all(
                          color: theme.dividerColor.withValues(alpha: 0.5),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.auto_awesome,
                            size: 13,
                            color: colorScheme.primary,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            badgeLabel!,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // Contenedor inferior de información
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Nombre destacado de la empresa
                Text(
                  name,
                  style: textTheme.titleLarge?.copyWith(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: colorScheme.onSurface,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 4),

                // Subtítulo técnico o comercial
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 12),

                // Descripción de los servicios/ecosistema
                Text(
                  description,
                  style: textTheme.bodyMedium?.copyWith(
                    fontSize: 14,
                    height: 1.45,
                    color: colorScheme.onSurface.withValues(alpha: 0.75),
                  ),
                ),
                const SizedBox(height: 22),

                // Botón amplio "Ver soluciones"
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: onSeeSolutions,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      foregroundColor: colorScheme.onPrimary,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          buttonText,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.arrow_forward_rounded, size: 18),
                      ],
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

  Widget _buildHeaderGraphic(ColorScheme colorScheme) {
    if (headerImageAsset != null) {
      return Image.asset(
        headerImageAsset!,
        fit: BoxFit.cover,
        cacheWidth: 900, // Previene consumo innecesario de memoria
      );
    }
    if (logoAsset != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
          child: Image.asset(
            logoAsset!,
            fit: BoxFit.contain,
            cacheWidth: 600,
            errorBuilder: (context, error, stackTrace) =>
                _buildFallbackIcon(colorScheme),
          ),
        ),
      );
    }
    return _buildFallbackIcon(colorScheme);
  }

  Widget _buildFallbackIcon(ColorScheme colorScheme) {
    return Center(
      child: Icon(
        fallbackIcon ?? Icons.apartment_rounded,
        size: 56,
        color: colorScheme.primary.withValues(alpha: 0.8),
      ),
    );
  }
}
