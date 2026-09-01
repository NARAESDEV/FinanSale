import 'package:flutter/material.dart';

/// Destino inmutable y configurable para la navegación exclusiva de Asistencia.
class AsistenciaNavDestination {
  final String label;
  final IconData icon;
  final IconData selectedIcon;

  const AsistenciaNavDestination({
    required this.label,
    required this.icon,
    required this.selectedIcon,
  });
}

/// Navbar inferior exclusivo, configurable y de alto rendimiento para el módulo Asistencia.
/// Diseñado para prevenir jank y desacoplar la navegación local de otras features como RH.
class AsistenciaNavbar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final List<AsistenciaNavDestination> destinations;

  const AsistenciaNavbar({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
    this.destinations = const [
      AsistenciaNavDestination(
        label: 'Inicio',
        icon: Icons.home_outlined,
        selectedIcon: Icons.home_rounded,
      ),
      AsistenciaNavDestination(
        label: 'Soluciones',
        icon: Icons.auto_awesome_mosaic_outlined,
        selectedIcon: Icons.auto_awesome_mosaic_rounded,
      ),
    ],
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final primaryColor = colorScheme.primary;
    final unselectedColor = colorScheme.onSurface.withValues(alpha: 0.55);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: theme.dividerColor.withValues(alpha: 0.6),
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 72,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(destinations.length, (index) {
                final destination = destinations[index];
                final isSelected = selectedIndex == index;

                return Expanded(
                  child: Semantics(
                    button: true,
                    selected: isSelected,
                    label: destination.label,
                    child: InkWell(
                      onTap: () => onDestinationSelected(index),
                      borderRadius: BorderRadius.circular(16),
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      child: Container(
                        alignment: Alignment.center,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeOutCubic,
                          padding: EdgeInsets.symmetric(
                            horizontal: isSelected ? 20 : 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? primaryColor.withValues(alpha: 0.12)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(16),
                            border: isSelected
                                ? Border.all(
                                    color: primaryColor.withValues(alpha: 0.2),
                                    width: 1,
                                  )
                                : null,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                isSelected
                                    ? destination.selectedIcon
                                    : destination.icon,
                                size: 22,
                                color: isSelected
                                    ? primaryColor
                                    : unselectedColor,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                destination.label,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 12,
                                  height: 1.1,
                                  fontWeight: isSelected
                                      ? FontWeight.w700
                                      : FontWeight.w500,
                                  color: isSelected
                                      ? primaryColor
                                      : unselectedColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}
