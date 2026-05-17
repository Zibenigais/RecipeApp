import 'package:go_router/go_router.dart';
import '../screens/ingredients_screen.dart';
import '../screens/meals_screen.dart';
import '../screens/meal_detail_screen.dart';
import '../screens/settings_screen.dart';
<<<<<<< Updated upstream
import '../screens/categories_screen.dart';
import '../screens/category_meals_screen.dart';
=======
import '../screens/recent_meals_screen.dart';
>>>>>>> Stashed changes

final appRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const IngredientsScreen(),
    ),
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
<<<<<<< Updated upstream
      path: '/categories',
      builder: (context, state) => const CategoriesScreen(),
    ),
    GoRoute(
      path: '/meals/category/:name',
      builder: (context, state) {
        final name = state.pathParameters['name']!;
        return CategoryMealsScreen(category: name);
      },
=======
      path: '/recent_meals',
      builder: (context, state) => const RecentMealsScreen(),
>>>>>>> Stashed changes
    ),
  ],
);
