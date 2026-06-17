# FinanSale - Documentación de Arquitectura

Este proyecto sigue una arquitectura basada en **Clean Architecture** (Arquitectura Limpia) y **Feature-Driven Development** (Desarrollo Orientado a Funcionalidades), utilizando **Cubit** para la gestión de estado y **Dio** para las peticiones de red.

## Estructura de Carpetas

La carpeta `lib/` está dividida en tres módulos principales:

### 1. `core/` (Núcleo)
Contiene la configuración global, utilidades y clases fundamentales que no pertenecen a ninguna funcionalidad específica, sino que son transversales a toda la aplicación.
- **`auth/`**: Manejo global de la sesión y tokens (ej. `session_manager.dart`).
- **`navigation/`**: Configuración de rutas y navegación de la aplicación (`app_router.dart`).
- **`network/`**: Configuración del cliente HTTP (`dio_client.dart`), donde se definen los interceptores para inyectar headers (como el Authorization) y manejo de errores globales.
- **`theme/`**: Temas, colores, tipografía y gestión del tema global (`app_theme.dart`, `theme_cubit.dart`).
- **`utils/`**: Clases utilitarias (ej. mapeadores de errores, helpers como `attachment_helper.dart`).

### 2. `features/` (Funcionalidades)
Cada módulo de la aplicación (ej. `auth`, `rh`, `hub`) se encuentra aquí de forma independiente, aislando su lógica y sus vistas del resto del proyecto. Las funcionalidades complejas siguen los principios de **Clean Architecture**, dividiéndose en tres capas internas:

- **`data/`**: Capa de datos, encargada de obtener y mandar información hacia el exterior.
  - **`datasources/`**: Fuentes de datos remotas (API con Dio) o locales (SharedPreferences/SQLite).
  - **`models/`**: Modelos de datos (Data Transfer Objects). Suelen extender de las entidades del dominio y se encargan del parseo JSON (`fromJson`, `toJson`).
  - **`repositories/`**: Implementación de las interfaces/contratos de los repositorios definidos en el dominio.
- **`domain/`**: Capa de dominio (lógica de negocio pura, sin dependencias de Flutter, UI o paquetes externos como Dio).
  - **`entities/`**: Entidades fundamentales de negocio.
  - **`repositories/`**: Contratos (interfaces/clases abstractas) que definen qué métodos debe cumplir el repositorio de datos.
- **`presentation/`**: Capa de presentación (UI e interacción del usuario).
  - **`cubit/`**: Gestores de estado y sus clases de estado correspondientes (`_cubit.dart`, `_state.dart`). Son el puente entre la UI y el dominio/datos.
  - **`pages/` / Pantallas**: Vistas principales de la funcionalidad.
  - **`widgets/`**: Componentes específicos que solo se usan en esa funcionalidad.

### 3. `shared/` (Compartido)
Contiene elementos que pueden ser reutilizados por múltiples `features`. A diferencia del `core`, aquí suelen ir cosas más orientadas a UI o servicios específicos de dispositivo, no configuraciones globales abstractas.
- **`services/`**: Servicios genéricos de sistema (ej. `media_service.dart`, `storage_service.dart`).
- **`widgets/`**: Componentes visuales genéricos (botones, modales, tarjetas, inputs personalizados, headers) que se utilizan en múltiples vistas de la app a lo largo de diversas features.

## Tecnologías y Librerías Principales
- **Flutter**: Framework UI.
- **Bloc / Cubit** (`flutter_bloc`): Manejo del estado reactivo de la aplicación.
- **Dio**: Cliente HTTP para las comunicaciones con las APIs backend.
- **Clean Architecture**: Patrón arquitectónico principal para mantener el código escalable, testeable y desacoplado.
