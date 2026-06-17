# Prompt para Generar Arquitectura Flutter (Clean Architecture + Cubit + Dio)

Puedes utilizar el siguiente prompt copiándolo y pegándolo en **Gemini Pro**, ChatGPT, o Claude para generar la estructura y el código base de nuevas aplicaciones manteniendo exactamente la misma arquitectura que `FinanSale`.

---

**Copia y pega el siguiente texto:**

> Actúa como un desarrollador experto en Flutter (Senior Flutter Developer). Quiero que me ayudes a estructurar y generar el código base para una nueva aplicación en Flutter. 
> 
> La aplicación debe seguir una arquitectura **Feature-Driven** combinada con **Clean Architecture**. Se utilizará **Cubit** (de la librería `flutter_bloc`) para la gestión del estado de la interfaz, y **Dio** para las peticiones de red (HTTP).
> 
> A continuación, te detallo la estructura de carpetas exacta que debes utilizar como referencia para el andamiaje del proyecto:
> 
> ```text
> lib/
> ├── core/
> │   ├── auth/ (ej. session_manager.dart)
> │   ├── navigation/ (ej. app_router.dart)
> │   ├── network/ (ej. dio_client.dart con configuración de interceptores)
> │   ├── theme/ (ej. app_theme.dart, theme_cubit.dart)
> │   └── utils/ (ej. error_mapper.dart, helpers)
> ├── features/
> │   └── [nombre_de_la_feature]/ (ej. auth)
> │       ├── data/
> │       │   ├── datasources/ (ej. [feature]_remote_datasource.dart usando Dio)
> │       │   ├── models/ (ej. [feature]_model.dart con fromJson/toJson extendiendo la Entity)
> │       │   └── repositories/ (ej. [feature]_repository_impl.dart)
> │       ├── domain/
> │       │   ├── entities/ (ej. [feature]_entity.dart)
> │       │   └── repositories/ (ej. [feature]_repository.dart - interfaz/contrato)
> │       └── presentation/
> │           ├── cubit/ (ej. [feature]_cubit.dart, [feature]_state.dart)
> │           ├── pages/ (ej. [feature]_page.dart)
> │           └── widgets/ (ej. componentes específicos de la vista)
> ├── shared/
> │   ├── services/ (ej. storage_service.dart)
> │   └── widgets/ (ej. componentes visuales compartidos y reutilizables)
> └── main.dart
> ```
> 
> **Reglas e Instrucciones:**
> 1. **Core:** Crea un `dio_client.dart` robusto en `core/network/` que incluya manejo de tokens y errores globales. 
> 2. **Features:** Al crear una nueva feature, asegúrate de separar estrictamente la lógica según la Clean Architecture. El `Cubit` solo debe depender de casos de uso (si existen) o directamente del contrato del repositorio (`Domain Repository`). La implementación del repositorio en `Data` (`RepositoryImpl`) debe ser quien dependa del `RemoteDataSource` que usará la instancia de `Dio`.
> 3. **Estado:** Utiliza clases de estado exhaustivas o mixins/sealed classes para el Cubit (ej. `Initial`, `Loading`, `Loaded`, `Error`).
> 4. **Punto de partida:** Por favor, genérame primero el código base para la carpeta `core` (especialmente el cliente `Dio` con interceptores básicos), y luego dame el andamiaje completo para la feature de **Autenticación (Auth)** (modelo, repositorio, cubit, estado y una vista de login básica) siguiendo esta estructura exacta.
