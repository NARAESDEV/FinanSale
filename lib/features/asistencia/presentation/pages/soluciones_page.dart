import 'package:flutter/material.dart';
import '../data/solutions_ui_data.dart';
import '../widgets/company_card.dart';
import 'company_solutions_page.dart';

/// Pantalla principal de la pestaña "Soluciones" dentro del módulo Asistencia.
/// Presenta el catálogo visual estático de empresas (NARAES y ALCOPTEC SYSTEMS)
/// preparado con componentes de alto rendimiento sin consumo de red ni dependencias externas.
class SolucionesPage extends StatelessWidget {
  const SolucionesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final isIOS = theme.platform == TargetPlatform.iOS;

    final mediaQuery = MediaQuery.of(context);
    final adjustedMediaQuery = isIOS
        ? mediaQuery.copyWith(
            textScaler: mediaQuery.textScaler.clamp(
              minScaleFactor: 1.0,
              maxScaleFactor: 1.15,
            ),
          )
        : mediaQuery;

    Widget content = SafeArea(
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // Header y título de sección
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Ecosistema & Seguridad',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Soluciones',
                    style: textTheme.titleLarge?.copyWith(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: colorScheme.onSurface,
                      letterSpacing: -0.6,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Catálogo de plataformas tecnológicas, control financiero y seguridad patrimonial para su institución.',
                    style: textTheme.bodyMedium?.copyWith(
                      fontSize: 14,
                      height: 1.4,
                      color: colorScheme.onSurface.withValues(alpha: 0.70),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),

          // Lista de tarjetas de empresa construida perezosamente para prevenir jank
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final company = SolutionsUiCatalog.companies[index];
                return CompanyCard(
                  key: ValueKey(company.id),
                  name: company.name,
                  subtitle: company.subtitle,
                  description: company.description,
                  headerImageAsset: company.headerImageAsset,
                  logoAsset: company.logoAsset,
                  fallbackIcon: company.fallbackHeaderIcon,
                  buttonText: company.buttonText,
                  badgeLabel: company.badgeLabel,
                  onSeeSolutions: () {
                    // Navegación local hacia la pantalla normal y genérica de soluciones
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => CompanySolutionsPage(company: company),
                      ),
                    );
                  },
                );
              }, childCount: SolutionsUiCatalog.companies.length),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),
    );

    if (isIOS) {
      content = Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: content,
        ),
      );
    }

    return MediaQuery(data: adjustedMediaQuery, child: content);
  }
}
