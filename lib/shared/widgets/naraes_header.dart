import 'package:flutter/material.dart';

class NaraesHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final bool isCompact;
  final VoidCallback? onBack;
  final Widget? bottomWidget;

  const NaraesHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.isCompact = false,
    this.onBack,
    this.bottomWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.only(left: 25, right: 25, top: 15, bottom: 45),
      decoration: const BoxDecoration(
        color: Color(0xFF3E77BC),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
      ),
      child: SafeArea(
        // Quitamos el bottom del SafeArea para tener control total
        bottom: false,
        child: Column(
          mainAxisSize: MainAxisSize.min, // El container se ajusta al contenido
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Fila Principal: Textos y Avatar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (onBack != null)
                        IconButton(
                          icon: const Icon(
                            Icons.arrow_back_ios,
                            color: Colors.white,
                            size: 20,
                          ),
                          onPressed: onBack,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          alignment: Alignment.centerLeft,
                        ),

                      // Ajustamos el "Hola," para que esté pegado arriba
                      if (!isCompact)
                        Text(
                          "Hola,",
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 15,
                            height: 1.0,
                          ),
                        ),

                      const SizedBox(height: 2), // Espacio mínimo

                      Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          height: 1.1,
                        ),
                      ),

                      if (subtitle != null)
                        Container(
                          margin: const EdgeInsets.only(top: 8),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            subtitle!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

                // Avatar elevado
                CircleAvatar(
                  radius: isCompact ? 24 : 34,
                  backgroundColor: Colors.white.withOpacity(0.2),
                  child: const Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ],
            ),

            // Si hay barra de progreso, aparece abajo con espacio controlado
            if (bottomWidget != null) ...[
              const SizedBox(height: 25),
              bottomWidget!,
            ],
          ],
        ),
      ),
    );
  }
}
