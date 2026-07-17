import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CollapsingStudentHeader extends SliverPersistentHeaderDelegate {
  final String childName;
  final String avatarUrl;
  final String grade;
  final String schoolName;

  CollapsingStudentHeader({
    required this.childName,
    required this.avatarUrl,
    required this.grade,
    required this.schoolName,
  });

  @override
  double get maxExtent => 280.0;

  @override
  double get minExtent => 90.0;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    final double percent = (shrinkOffset / (maxExtent - minExtent)).clamp(0.0, 1.0);
    final safeAreaTop = MediaQuery.of(context).padding.top;

    // Paleta de colores consistente
    const primaryColor = Color(0xFF0F172A);
    const mutedColor = Color(0xFF64748B);
    const blueColor = Color(0xFF3E77BC);

    // Interpolaciones de tamaño
    final avatarSize = Tween<double>(begin: 110.0, end: 36.0).transform(percent);
    final avatarRadius = Tween<double>(begin: 32.0, end: 12.0).transform(percent);
    final nameFontSize = Tween<double>(begin: 24.0, end: 16.0).transform(percent);
    
    // Posiciones (Y)
    // Expandido: Centrado verticalmente en el espacio disponible.
    // Colapsado: Centrado en la barra de herramientas (minExtent - safeAreaTop)
    final double toolBarHeight = minExtent - safeAreaTop;
    
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: percent > 0.8
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                )
              ]
            : null,
      ),
      child: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            // Botón de Volver (siempre visible en la esquina superior izquierda)
            Positioned(
              left: 8,
              top: (toolBarHeight - 40) / 2, // Centrado vertical en la barra de herramientas
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.withValues(alpha: Tween<double>(begin: 0.1, end: 0.0).transform(percent)),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
                  color: primaryColor,
                  onPressed: () => context.pop(),
                ),
              ),
            ),

            // Contenedor del Avatar (Anima tamaño y posición)
            Positioned(
              // Interpolación de X:
              // Expandido: Centrado en pantalla -> (screenWidth - avatarSize) / 2
              // Colapsado: Al lado del botón volver -> 56.0
              left: Tween<double>(
                begin: (MediaQuery.of(context).size.width - avatarSize) / 2,
                end: 56.0,
              ).transform(percent),
              // Interpolación de Y:
              // Expandido: A 20px del top del stack
              // Colapsado: Centrado en la barra de herramientas
              top: Tween<double>(
                begin: 20.0,
                end: (toolBarHeight - avatarSize) / 2,
              ).transform(percent),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: avatarSize,
                    height: avatarSize,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(avatarRadius),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(avatarRadius),
                      child: Image.network(
                        avatarUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: Colors.grey.shade200,
                          child: const Icon(Icons.person, color: Colors.grey),
                        ),
                      ),
                    ),
                  ),
                  // Escudo azul ("En la escuela"). Fades out al colapsar para evitar jank visual
                  Positioned(
                    right: -4,
                    bottom: -4,
                    child: Opacity(
                      opacity: (1.0 - percent * 2).clamp(0.0, 1.0),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: blueColor,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.shield,
                          size: 14,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Nombre y detalles del estudiante (Leo Harrison)
            Positioned(
              // Interpolación de X:
              // Expandido: Centrado -> full width
              // Colapsado: Al lado del avatar -> 104.0
              left: Tween<double>(
                begin: 0.0,
                end: 104.0,
              ).transform(percent),
              // Interpolación de Y:
              // Expandido: Debajo de la foto (140px)
              // Colapsado: Centrado en la barra de herramientas
              top: Tween<double>(
                begin: 144.0,
                end: (toolBarHeight - nameFontSize * 1.2) / 2,
              ).transform(percent),
              right: percent > 0.8 ? 16.0 : 0.0,
              child: SizedBox(
                width: percent > 0.8
                    ? null
                    : MediaQuery.of(context).size.width, // Ocupa todo el ancho cuando está centrado
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: percent > 0.8
                      ? CrossAxisAlignment.start
                      : CrossAxisAlignment.center,
                  children: [
                    Text(
                      childName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: nameFontSize,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                    // Detalles (Grado/Colegio). Fades out al colapsar
                    if (percent < 0.6)
                      Opacity(
                        opacity: (1.0 - percent * 2.5).clamp(0.0, 1.0),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 6.0),
                          child: Text(
                            '$grade • $schoolName',
                            style: const TextStyle(
                              fontSize: 13,
                              color: mutedColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant CollapsingStudentHeader oldDelegate) {
    return childName != oldDelegate.childName ||
        avatarUrl != oldDelegate.avatarUrl ||
        grade != oldDelegate.grade ||
        schoolName != oldDelegate.schoolName;
  }
}
