# Recipe App

A Flutter app for discovering and planning meals, powered by [TheMealDB](https://www.themealdb.com) API.

## Screenshots

| Side Navigation | Home (Ingredients) | Meal Details by Ingredient |
| :---: | :---: | :---: |
| <img width="399" height="653" alt="Side Navigation Bar" src="https://github.com/user-attachments/assets/f59868e1-196d-4a0f-ada2-95a475a312dd" /> | <img width="398" height="644" alt="Home Page Ingredients" src="https://github.com/user-attachments/assets/4374c1fb-0f0b-454c-a0c7-742b4593ca97" /> | <img width="395" height="643" alt="Meal Details Screen" src="https://github.com/user-attachments/assets/96783e19-1f20-4df1-9dde-8984356211b0" /> |

---

## Features

### Discovery
- **Browse ingredients** — scrollable list of all ingredients with search/filter (validated input)
- **Browse categories** — browse meals grouped by category (e.g. Beef, Seafood, Dessert) with search/filter
- **Browse by region** — explore cuisines from around the world with search/filter
- **Surprise Me** — fetch a random meal at the tap of a button; tap *Roll Again* to get another

#### Discovery Screenshots

| Browse Ingredients | Ingredient-Filtered Meals | Browse Categories |
| :---: | :---: | :---: |
| <img width="398" alt="Browse Ingredients" src="https://github.com/user-attachments/assets/a2f6cdd9-16f4-4567-9067-28af6107d2cf" /> | <img width="394" alt="Ingredient Based Meals" src="https://github.com/user-attachments/assets/bc292b5d-6ac2-43ae-95fa-dfaaff40753a" /> | <img width="396" alt="Browse Categories" src="https://github.com/user-attachments/assets/a7f6aa06-4d03-43c7-85d7-29cf176317c0" /> |

| Category-Filtered Meals | Browse by Region | Surprise Me (Initial) | Surprise Me (Result) |
| :---: | :---: | :---: | :---: |
| <img width="397" alt="Category Filtered Meals" src="https://github.com/user-attachments/assets/1565b733-6d06-4779-b386-26458eb94cc6" /> | <img width="394" alt="Browse by Region" src="https://github.com/user-attachments/assets/a5b70fb1-85f1-455a-9438-410d87d71738" /> | <img width="392" alt="Surprise Me Default" src="https://github.com/user-attachments/assets/27f6376a-e3b3-482b-9993-0e6e84efba57" /> | <img width="395" alt="Surprise Me Random Meal" src="https://github.com/user-attachments/assets/51a3ee43-7292-4ba1-96b3-1f076ec57ba7" /> |

### Meals
- Tap an ingredient, category, or region to see all matching meals
- Tap any meal to view its full details: image, ingredient list with measures, and step-by-step instructions
- Favourite a meal from its detail screen; long-press in Favourites to remove it

### Personal lists
- **Favourites** — save and revisit your favourite meals, persisted across sessions
- **Recent Meals** — automatically tracks every meal you open; clearable history
- **Weekly Meal Plan** — assign multiple meals to each day of the week; search or browse the full meal catalogue when adding; plan persisted across sessions
- **Shopping List** — auto-generated from your weekly plan (ingredients are aggregated across all meals); check off items and clear checked ones; list persisted across sessions

#### Planner & Shopping List Screenshots

| Weekly Meal Plan | Shopping List (Aggregated) |
| :---: | :---: |
| <img width="395" height="647" alt="SCR-20260529-mstv" src="https://github.com/user-attachments/assets/07793d94-d78d-425d-818a-4f7a4e082430" /> | <img width="393" alt="Shopping List View" src="https://github.com/user-attachments/assets/2a99cbbe-884f-4d76-bcfd-00d37275cbb2" /> |

### App
- Light/dark theme toggle, persisted across sessions
- Loading, error (with retry), and empty states on every screen
- Drawer navigation: Ingredients · Categories · Meals by Region · Recent Meals · Favourites · Surprise Me · Weekly Meal Plan · Shopping List · Settings

#### App States & Navigation Screenshots

| Side Navigation (Dark Mode) | Error & Retry State |
| :---: | :---: |
| <img width="396" alt="Dark Mode Side Navigation" src="https://github.com/user-attachments/assets/53f32bda-9381-4c29-ad5b-4e148aa128a4" /> | <img width="393" height="648" alt="Error and Retry State" src="https://github.com/user-attachments/assets/aa63ce4a-ce61-4cf3-8ac3-ed37adf774e7" /> |

---

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
