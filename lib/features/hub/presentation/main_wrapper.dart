import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainWrapper extends StatelessWidget {
  final Widget child;
  const MainWrapper({super.key, required this.child});

  int _getSelectedIndex(String path) {
    if (path.startsWith('/rh-dashboard')) return 0;
    if (path.startsWith('/solicitudes')) return 1;
    if (path.startsWith('/historial')) return 2;
    if (path.startsWith('/perfil')) return 3;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final currentPath = GoRouterState.of(context).uri.path;
    final selectedIndex = _getSelectedIndex(currentPath);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: child,
      bottomNavigationBar: DecoratedBox(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          border: Border(
            top: BorderSide(color: Theme.of(context).dividerColor, width: 1),
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF0F172A).withValues(alpha: 0.08),
              blurRadius: 20,
              offset: const Offset(0, -4),
              spreadRadius: -6,
            ),
            BoxShadow(
              color: const Color(0xFF0F172A).withValues(alpha: 0.04),
              blurRadius: 6,
              offset: const Offset(0, -1),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: 74,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Row(
                children: [
                  _navBtn(
                    context,
                    icon: Icons.home_rounded,
                    label: "Inicio",
                    route: "/rh-dashboard",
                    currentPath: currentPath,
                    isSelected: selectedIndex == 0,
                  ),
                  _navBtn(
                    context,
                    icon: Icons.assignment_outlined,
                    label: "Solicitudes",
                    route: "/solicitudes",
                    currentPath: currentPath,
                    isSelected: selectedIndex == 1,
                  ),
                  _navBtn(
                    context,
                    icon: Icons.history_rounded,
                    label: "Historial",
                    route: "/historial",
                    currentPath: currentPath,
                    isSelected: selectedIndex == 2,
                  ),
                  _navBtn(
                    context,
                    icon: Icons.person_outline_rounded,
                    label: "Perfil",
                    route: "/perfil",
                    currentPath: currentPath,
                    isSelected: selectedIndex == 3,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _navBtn(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String route,
    required String currentPath,
    required bool isSelected,
  }) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    final mutedColor = Theme.of(
      context,
    ).colorScheme.onSurface.withValues(alpha: 0.4);

    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: () => context.go(route),
        child: Center(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOutCubic,
            padding: EdgeInsets.symmetric(
              horizontal: isSelected ? 12 : 8,
              vertical: 10,
            ),
            decoration: BoxDecoration(
              color: isSelected
                  ? primaryColor.withValues(alpha: 0.10)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(18),
              border: isSelected
                  ? Border.all(
                      color: primaryColor.withValues(alpha: 0.12),
                      width: 1,
                    )
                  : null,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  size: 22,
                  color: isSelected ? primaryColor : mutedColor,
                ),
                const SizedBox(height: 4),
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11,
                    height: 1,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: isSelected ? primaryColor : mutedColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
