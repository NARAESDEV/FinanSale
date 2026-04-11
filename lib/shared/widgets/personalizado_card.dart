import 'package:flutter/material.dart';

const _kCardShadow = [
  BoxShadow(color: Color(0x40000000), blurRadius: 10, offset: Offset(0, 4)),
];

class PersonalizadoCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final Color backgroundColor;
  final double borderRadius;
  const PersonalizadoCard({
    super.key,
    required this.child,
    this.padding,
    this.backgroundColor = Colors.white,
    this.borderRadius = 24,
  });
  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Container(
        width: double.infinity,
        padding: padding ?? const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: _kCardShadow,
        ),
        child: child,
      ),
    );
  }
}
