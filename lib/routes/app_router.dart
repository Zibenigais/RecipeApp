import 'package:go_router/go_router.dart';
import '../screens/ingredients_screen.dart';
import '../screens/meals_screen.dart';
import '../screens/meal_detail_screen.dart';
import '../screens/settings_screen.dart';
import '../screens/categories_screen.dart';
import '../screens/category_meals_screen.dart';
import '../screens/recent_meals_screen.dart';
import '../screens/favourites_screen.dart';
import '../screens/random_meal_screen.dart';
import '../screens/regions_screen.dart';
import '../screens/region_meals_screen.dart';
import '../screens/weekly_planner_screen.dart';
import '../screens/shopping_list_screen.dart';

final appRouter = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => const IngredientsScreen()),
    GoRoute(
      path: '/meals/:name',
      builder: (context, state) {
        final name = state.pathParameters['name']!;
        return MealsScreen(ingredient: name);
      },
    ),
    GoRoute(
      path: '/meal/:id',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return MealDetailScreen(mealId: id);
      },
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsScreen(),
    ),
    GoRoute(
      path: '/categories',
      builder: (context, state) => const CategoriesScreen(),
    ),
    GoRoute(
      path: '/favourites',
      builder: (context, state) => const FavouritesScreen(),
    ),
    GoRoute(
      path: '/surprise-me',
      builder: (context, state) => const RandomMealScreen(),
    ),
    GoRoute(
      path: '/meals/category/:name',
      builder: (context, state) {
        final name = state.pathParameters['name']!;
        return CategoryMealsScreen(category: name);
      },
    ),
    GoRoute(
      path: '/recent_meals',
      builder: (context, state) => const RecentMealsScreen(),
    ),
    GoRoute(
      path: '/regions',
      builder: (context, state) => const RegionsScreen(),
    ),
    GoRoute(
      path: '/meals/region/:name',
      builder: (context, state) {
        final name = state.pathParameters['name']!;
        return RegionMealsScreen(region: name);
      },
    ),
    GoRoute(
      path: '/weekly_planner',
      builder: (context, state) => const WeeklyPlannerScreen(),
    ),
    GoRoute(
      path: '/shopping_list',
      builder: (context, state) => const ShoppingListScreen(),
    ),
  ],
);