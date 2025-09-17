# HeartWise – Auditoría y Propuesta de Arquitectura (v1)

Fecha: 2025-09-17
Rama: `refactor/app-architecture-v1`

## 1. Estado actual (carpeta `lib/`)

- Estructura plana y mixta:
  - `view/` contiene pantallas con lógica UI + algo de navegación propia.
  - `service/` contiene servicios (p. ej., `database_service.dart`, `session_service.dart`).
  - Archivos Python y scripts ajenos a Flutter dentro de `lib/models` y `lib/service` (deberían salir del paquete app).
  - `main.dart` define el inicio y dependencias; recientemente se agregó `SplashScreen` y persistencia de sesión.
- Acoplamientos detectados:
  - Import directo de `mysql1/src/single_connection.dart` en UI (`home_screen.dart`) — fuga de capa e import interno no soportado.
  - Vistas conocen detalles de navegación entre ellas sin router centralizado.
  - Temas/colores están hardcodeados en múltiples pantallas.
- Mejoras recientes:
  - `MainNavigationScreen` con nav flotante, `SplashScreen` con verificación de sesión, `SessionService` con `shared_preferences`.

## 2. Objetivos de la nueva arquitectura

- Escalabilidad y mantenibilidad: capas bien definidas y desacopladas.
- Reutilización: tema/colores tipificados y centralizados.
- Testeabilidad: separar lógica de UI (posible adopción futura de BLoC/Provider/Riverpod sin romper el diseño).
- Navegación predecible: router central (GoRouter/Navigator 2.0 opcional más adelante).
- Limpieza de dependencias: evitar imports internos de paquetes de terceros.

## 3. Propuesta de estructura (v1)

```
lib/
  core/
    constants/
      app_colors.dart
    routing/
      app_router.dart          # Punto único para rutas
    services/
      session_service.dart     # (movido desde service/)
    theme/
      app_theme.dart
  data/
    # Futuro: fuentes de datos y repositorios (API/DB)
  domain/
    # Futuro: entidades y casos de uso
  features/
    auth/
      presentation/
        login_screen.dart
        splash_screen.dart
    home/
      presentation/
        home_screen.dart
    profile/
      presentation/
        perfil_screen.dart
        biomarcadores_screen.dart
    navigation/
      presentation/
        main_navigation_screen.dart
  shared/
    widgets/                   # Widgets comunes reutilizables
    utils/                     # Utilidades UI / helpers
main.dart
```

Notas:
- Fase 1 (este PR): crear `core/` (tema, colores, router básico), mover `SessionService`, alinear imports, limpiar imports erróneos y sacar scripts ajenos a Flutter del `lib/`.
- Fase 2: reorganizar `view/` en `features/` sin romper rutas (backward-compatible), y evaluar introducir `GoRouter` o `Navigator 2.0`.
- Fase 3: separar `service/database_service.dart` en `data/` con repositorios + casos de uso en `domain/`.

## 4. Cambios concretos fase 1

- Core
  - `core/constants/app_colors.dart`: paleta centralizada.
  - `core/theme/app_theme.dart`: tema Material basado en paleta.
  - `core/routing/app_router.dart`: Router central (por ahora con `Navigator.push` helpers; opcional migrar a GoRouter después).
- Servicios
  - Mover `service/session_service.dart` → `core/services/session_service.dart` y actualizar imports.
- Limpieza
  - Quitar import `mysql1/src/single_connection.dart` de `home_screen.dart`.
  - Eliminar archivos `.py` en `lib/models` y `lib/service` (no Flutter) — mover a raíz `tools/` si se requieren.
- `main.dart`
  - Usar `AppTheme.light` y mantener `SplashScreen`.

## 5. Ruta de migración sin rupturas

- Mantener paths antiguos por esta fase (solo movemos SessionService e imports fáciles).
- En fase 2, mover `view/*` a `features/*/presentation` con alias de import temporales si fuese necesario.

## 6. Checklist técnico

- [ ] Compila: `flutter pub get` y `flutter analyze` sin errores.
- [ ] Navegación: Splash → Login/MainNavigation estable.
- [ ] UI: No cambia visual por tema centralizado (colores iguales).
- [ ] Sin imports internos de terceros.

## 7. Siguientes pasos (fase 2 y 3)

- Adoptar GoRouter y definir rutas tipadas.
- Extraer `DatabaseService` a `data/` y repositorios; definir modelos/entidades en `domain/`.
- Introducir un gestor de estado (Provider/Riverpod/BLoC) para aislar lógica.
- Añadir tests unitarios de servicios y widgets clave.
