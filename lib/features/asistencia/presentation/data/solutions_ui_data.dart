import 'package:flutter/material.dart';

/// Modelo visual estático e inmutable para los productos y soluciones de cada empresa.
/// Representa únicamente la interfaz (UI Data), sin serialización ni lógica de dominio.
class SolutionProductUiItem {
  final String id;
  final String name;
  final String category;
  final String description;
  final String? imageAsset;
  final IconData? fallbackIcon;
  final String actionText;

  const SolutionProductUiItem({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    this.imageAsset,
    this.fallbackIcon,
    this.actionText = 'Explorar solución',
  });
}

/// Modelo visual estático e inmutable para las empresas del módulo Soluciones.
class CompanyUiItem {
  final String id;
  final String name;
  final String subtitle;
  final String description;
  final String? headerImageAsset;
  final String? logoAsset;
  final IconData? fallbackHeaderIcon;
  final String buttonText;
  final String? badgeLabel;
  final List<SolutionProductUiItem> products;

  const CompanyUiItem({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.description,
    this.headerImageAsset,
    this.logoAsset,
    this.fallbackHeaderIcon,
    this.buttonText = 'Ver soluciones',
    this.badgeLabel,
    required this.products,
  });
}

/// Catálogo local estático del módulo Asistencia/Soluciones.
/// Centraliza la configuración de NARAES y ALCOPTEC SYSTEMS para facilitar
/// su futura integración multi-tenant sin modificar la capa visual.
class SolutionsUiCatalog {
  static const List<CompanyUiItem> companies = [
    CompanyUiItem(
      id: 'naraes',
      name: 'NARAES',
      subtitle: 'Ecosistema Tecnológico Inteligente',
      description:
          'Plataforma integral de soluciones avanzadas en control de asistencia, gestión financiera y desarrollo digital para instituciones escolares.',
      headerImageAsset: null, // Placeholder visual controlado
      logoAsset: 'assets/images/logo.png', // Asset existente en el proyecto
      fallbackHeaderIcon: Icons.hub_rounded,
      buttonText: 'Ver soluciones',
      badgeLabel: 'Ecosistema Destacado',
      products: [
        SolutionProductUiItem(
          id: 'ticketns',
          name: 'TicketNS',
          category: 'Gestión Escolar & Cobros',
          description:
              'Sistema inteligente de control de cobros, administración de tickets y accesos escolares con conciliación automatizada en tiempo real.',
          fallbackIcon: Icons.confirmation_number_outlined,
          actionText: 'Conocer más',
        ),
        SolutionProductUiItem(
          id: 'finansale',
          name: 'FinanSale',
          category: 'Finanzas & Punto de Venta',
          description:
              'Plataforma de terminal punto de venta y control financiero escolar adaptada al ecosistema institucional con reportes analíticos.',
          fallbackIcon: Icons.point_of_sale_rounded,
          actionText: 'Conocer más',
        ),
        SolutionProductUiItem(
          id: 'landing_page',
          name: 'Landing Page Institucional',
          category: 'Presencia Digital & Web',
          description:
              'Portales institucionales web modernos, altamente responsivos y orientados a la conversión para captación estudiantil y comunicación.',
          fallbackIcon: Icons.web_rounded,
          actionText: 'Conocer más',
        ),
      ],
    ),
    CompanyUiItem(
      id: 'alcoptec',
      name: 'ALCOPTEC SYSTEMS',
      subtitle: 'Ingeniería en Sistemas & Seguridad',
      description:
          'Especialistas en infraestructura de control biométrico, seguridad escolar patrimonial y tecnologías de integración de red de alto rendimiento.',
      headerImageAsset: null, // Pendiente de asset definitivo
      logoAsset: null, // Pendiente de logo definitivo
      fallbackHeaderIcon: Icons.security_rounded,
      buttonText: 'Ver soluciones',
      badgeLabel: 'Socio Tecnológico',
      products:
          [], // Lista vacía que muestra el estado controlado "Soluciones próximamente"
    ),
  ];
}
