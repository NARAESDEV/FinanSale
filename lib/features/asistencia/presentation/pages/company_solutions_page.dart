import 'package:flutter/material.dart';
import '../data/solutions_ui_data.dart';
import '../widgets/product_card.dart';

/// Vista genérica y reutilizable para mostrar el catálogo de soluciones de cualquier empresa
/// (ej. NARAES o ALCOPTEC SYSTEMS), sin duplicar pantallas ni lógica por tenant o marca.
class CompanySolutionsPage extends StatelessWidget {
  final CompanyUiItem company;

  const CompanySolutionsPage({super.key, required this.company});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          company.name,
          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWideScreen = constraints.maxWidth >= 650;
            final products = company.products;

            // Estado visual controlado para empresas sin productos cargados (ej. ALCOPTEC SYSTEMS)
            if (products.isEmpty) {
              return _buildEmptyState(context);
            }

            return CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                // Encabezado informativo de la empresa
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (company.badgeLabel != null) ...[
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: colorScheme.primary.withValues(
                                alpha: 0.12,
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              company.badgeLabel!,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: colorScheme.primary,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                        ],
                        Text(
                          company.subtitle,
                          style: textTheme.titleLarge?.copyWith(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: colorScheme.onSurface,
                            letterSpacing: -0.4,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          company.description,
                          style: textTheme.bodyMedium?.copyWith(
                            fontSize: 14,
                            height: 1.45,
                            color: colorScheme.onSurface.withValues(
                              alpha: 0.75,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),

                // Lista o Grid responsivo de soluciones
                if (isWideScreen)
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    sliver: SliverGrid(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 16,
                            crossAxisSpacing: 16,
                            childAspectRatio: 0.95,
                          ),
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final item = products[index];
                        return ProductCard(
                          key: ValueKey(item.id),
                          name: item.name,
                          category: item.category,
                          description: item.description,
                          imageAsset: item.imageAsset,
                          fallbackIcon: item.fallbackIcon,
                          actionText: item.actionText,
                          onActionPressed: () {},
                        );
                      }, childCount: products.length),
                    ),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final item = products[index];
                        return ProductCard(
                          key: ValueKey(item.id),
                          name: item.name,
                          category: item.category,
                          description: item.description,
                          imageAsset: item.imageAsset,
                          fallbackIcon: item.fallbackIcon,
                          actionText: item.actionText,
                          onActionPressed: () {},
                        );
                      }, childCount: products.length),
                    ),
                  ),

                const SliverToBoxAdapter(child: SizedBox(height: 32)),
              ],
            );
          },
        ),
      ),
    );
  }

  /// Renderiza un estado visual controlado y ligero sin crear simulaciones de error
  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 36),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: colorScheme.primary.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.auto_awesome_outlined,
                size: 56,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Soluciones próximamente',
              textAlign: TextAlign.center,
              style: textTheme.titleLarge?.copyWith(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Estamos integrando nuevas capacidades, herramientas tecnológicas y módulos especializados para el ecosistema de ${company.name}.',
              textAlign: TextAlign.center,
              style: textTheme.bodyMedium?.copyWith(
                fontSize: 14,
                height: 1.5,
                color: colorScheme.onSurface.withValues(alpha: 0.70),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
