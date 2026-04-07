import 'package:flutter/material.dart';

class NaraesHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final bool isCompact;
  final VoidCallback? onBack;

  const NaraesHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.isCompact = false,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    // Definimos la altura según el tipo
    final double headerHeight = isCompact ? 180 : 260;

    return Container(
      width: double.infinity,
      height: headerHeight,
      padding: const EdgeInsets.symmetric(horizontal: 25),
      decoration: const BoxDecoration(
        color: Color(0xFF3E77BC),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Columna de Textos
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
                          alignment: Alignment.centerLeft,
                        ),
                      if (!isCompact)
                        Text(
                          "Hola,",
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 16,
                          ),
                        ),
                      Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (subtitle != null)
                        Container(
                          margin: const EdgeInsets.only(top: 5),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            subtitle!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                // Avatar
                CircleAvatar(
                  radius: isCompact ? 25 : 35,
                  backgroundColor: Colors.white.withOpacity(0.2),
                  child: const Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
