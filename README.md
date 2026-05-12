# Recipe App

A Flutter app for browsing ingredients and discovering meals you can cook with them, powered by [TheMealDB](https://www.themealdb.com) API.

## Features

- Browse a scrollable list of ingredients
- Search/filter ingredients by name (validated input)
- Tap an ingredient to see all meals that use it as the main ingredient
- Tap a meal to view full details (instructions, ingredients, image)
- Light/dark theme toggle, persisted across sessions
- Loading, error (with retry), and empty states on every screen
- Drawer navigation: Ingredients / Settings / About

## Setup & Run

**Requirements:** Flutter 3.x (SDK `^3.11.4`)

```bash
git clone <repo-url>
cd RecipeApp
flutter pub get
flutter run
```

Tested on iOS and Android emulators.

## Packages

| Package | Why |
|---|---|
| `provider` | Simple ChangeNotifier-based state management |
| `http` | REST calls to TheMealDB API |
| `go_router` | Named/path-based routing with params |
| `shared_preferences` | Persist dark-mode setting across sessions |
| `cached_network_image` | Efficient image loading and caching |
| `mockito` + `build_runner` | Mock HTTP client in service tests |

## Architecture

```
lib/
  models/         # Ingredient, MealSummary, Meal — fromJson/toJson
  services/       # MealDbService (HTTP), SettingsService (prefs)
  providers/      # ChangeNotifiers: Ingredients, MealsByIngredient, MealDetail, Theme
  validators/     # Pure validator functions (no widget deps)
  screens/        # IngredientsScreen, MealsScreen, MealDetailScreen, SettingsScreen, AboutScreen
  widgets/        # IngredientTile, MealTile, AppDrawer, LoadingView, ErrorView, EmptyView
  routes/         # GoRouter config
```

## Tests

```bash
flutter test
```

Covers: model `fromJson`/`toJson`, all validator cases, `MealDbService` with mocked HTTP client, and a widget test for `IngredientTile`.

## Data Source

[TheMealDB](https://www.themealdb.com) — free meal database API.
