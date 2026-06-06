import 'package:flutter/material.dart';

const _kCardShadowLight = [
  BoxShadow(color: Color(0x40000000), blurRadius: 10, offset: Offset(0, 4)),
];

const _kCardShadowDark = [
  BoxShadow(color: Color(0x60000000), blurRadius: 12, offset: Offset(0, 4)),
];

class PersonalizadoCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;

  /// Si es null, usa Theme.of(context).colorScheme.surface automáticamente.
  final Color? backgroundColor;
  final double borderRadius;
  const PersonalizadoCard({
    super.key,
    required this.child,
    this.padding,
    this.backgroundColor,
    this.borderRadius = 24,
  });
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final effectiveColor =
        backgroundColor ?? Theme.of(context).colorScheme.surface;

    return RepaintBoundary(
      child: Container(
        width: double.infinity,
        padding: padding ?? const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: effectiveColor,
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: isDark ? _kCardShadowDark : _kCardShadowLight,
        ),
        child: child,
      ),
    );
  }
}
