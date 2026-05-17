import 'package:go_router/go_router.dart';
import '../screens/ingredients_screen.dart';
import '../screens/meals_screen.dart';
import '../screens/meal_detail_screen.dart';
import '../screens/settings_screen.dart';
import '../screens/categories_screen.dart';
import '../screens/category_meals_screen.dart';
import '../screens/favourites_screen.dart';

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
      path: '/meals/category/:name',
      builder: (context, state) {
        final name = state.pathParameters['name']!;
        return CategoryMealsScreen(category: name);
      },
    ),
  ],
);
