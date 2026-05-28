# Recipe App

A Flutter app for discovering and planning meals, powered by [TheMealDB](https://www.themealdb.com) API.

## Features

### Discovery
- **Browse ingredients** — scrollable list of all ingredients with search/filter (validated input)
- **Browse categories** — browse meals grouped by category (e.g. Beef, Seafood, Dessert) with search/filter
- **Browse by region** — explore cuisines from around the world with search/filter
- **Surprise Me** — fetch a random meal at the tap of a button; tap *Roll Again* to get another

### Meals
- Tap an ingredient, category, or region to see all matching meals
- Tap any meal to view its full details: image, ingredient list with measures, and step-by-step instructions
- Favourite a meal from its detail screen; long-press in Favourites to remove it

### Personal lists
- **Favourites** — save and revisit your favourite meals, persisted across sessions
- **Recent Meals** — automatically tracks every meal you open; clearable history
- **Weekly Meal Plan** — assign multiple meals to each day of the week; search or browse the full meal catalogue when adding; plan persisted across sessions
- **Shopping List** — auto-generated from your weekly plan (ingredients are aggregated across all meals); check off items and clear checked ones; list persisted across sessions

### App
- Light/dark theme toggle, persisted across sessions
- Loading, error (with retry), and empty states on every screen
- Drawer navigation: Ingredients · Categories · Meals by Region · Recent Meals · Favourites · Surprise Me · Weekly Meal Plan · Shopping List · Settings

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
| `provider` | ChangeNotifier-based state management |
| `http` | REST calls to TheMealDB API |
| `go_router` | Named/path-based routing with path parameters |
| `shared_preferences` | Persist theme, favourites, weekly plan, and shopping list across sessions |
| `cached_network_image` | Efficient image loading and caching |
| `mockito` + `build_runner` | Mock HTTP client in service tests |

## Architecture

```
lib/
  models/         # Ingredient, Category, Area, MealSummary, Meal, WeeklyMealPlan — fromJson/toJson
  services/       # MealDbService (HTTP), SettingsService, FavouritesService, RecentMealsService
  providers/      # ChangeNotifiers: Ingredients, Categories, Areas, MealsByIngredient,
                  #   MealsByCategory, MealsByArea, MealDetail, RandomMeal, Favourites,
                  #   RecentMeals, WeeklyMealPlan, ShoppingList, Theme
  validators/     # Pure validator functions (no widget deps)
  screens/        # IngredientsScreen, CategoriesScreen, RegionsScreen, MealsScreen,
                  #   CategoryMealsScreen, RegionMealsScreen, MealDetailScreen,
                  #   RandomMealScreen, FavouritesScreen, RecentMealsScreen,
                  #   WeeklyPlannerScreen, ShoppingListScreen, SettingsScreen
  widgets/        # IngredientTile, CategoryTile, AreaTile, MealTile, MealDetailView,
                  #   FavouriteButton, AppDrawer, LoadingView, ErrorView, EmptyView
  routes/         # GoRouter config
```

## Tests

```bash
flutter test
```

Covers:
- **Models** — `fromJson`/`toJson` for `Ingredient` and `Meal`
- **Validators** — all search-validator edge cases
- **Services** — `MealDbService` and `FavouritesService` with a mocked HTTP client
- **Providers** — `FavouritesProvider` (toggle, persist, load)
- **Widgets** — `IngredientTile`

## Data Source

[TheMealDB](https://www.themealdb.com) — free meal database API.
