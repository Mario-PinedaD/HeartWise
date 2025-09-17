# UI/Logic Separation Plan (per screen)

Goal: isolate business logic/state from widgets to enable testability and reuse. Initial step uses simple controllers; future step can adopt Provider/Riverpod/BLoC.

## Auth
- SplashScreen
  - Move session check into a `SplashController` (calls `SessionService.isSessionActive`).
- LoginScreen
  - Extract authentication flow into `LoginController` (uses `DatabaseService` + `SessionService`).
  - Keep only form widgets and event wiring in the widget.

## Navigation
- MainNavigationScreen
  - Extract currentIndex handling into `NavigationController` (expose `currentIndex`, `selectTab`, and `pages`).

## Home
- HomeScreenContent
  - Move user loading and logout to `HomeController` (reads `SessionService`, handles confirmation).
  - Widget focuses on layout and grid configuration.

## Profile
- PerfilScreen
  - Extract user data and logout into `ProfileController`.
- BiomarcadoresScreen
  - Move form controllers and validation to `BiomarkersController`.

## Analysis
- EvaluacionCorporalScreen / AnalisisClinicoScreen
  - Encapsulate calculation/validation in `AnalysisController`.

## Results
- ResultadosScreen / ResultadosPorCorreo
  - Extract data fetching and mapping into `ResultsController`.

## Implementation Notes
- Place controllers under each feature: `lib/features/<feature>/application/`.
- Controllers are plain Dart classes with dependencies injected via constructor.
- Later, wrap controllers with Provider or Riverpod for reactive updates.
