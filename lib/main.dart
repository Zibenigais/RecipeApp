import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app.dart';
import 'services/meal_db_service.dart';
import 'services/settings_service.dart';
import 'providers/theme_provider.dart';
import 'providers/ingredients_provider.dart';
import 'providers/meals_by_ingredient_provider.dart';
import 'providers/meal_detail_provider.dart';
import 'providers/categories_provider.dart';
import 'providers/meals_by_category_provider.dart';
import 'services/recent_meals_service.dart';
import 'providers/recent_meals_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final settingsService = SettingsService();
  final mealDbService = MealDbService();
  final themeProvider = ThemeProvider(settingsService);
  await themeProvider.load();

  final recentMealsService = RecentMealsService();
  final recentMealsProvider = RecentMealsProvider(recentMealsService);
  recentMealsProvider.load(); // Load asynchronously

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: themeProvider),
        ChangeNotifierProvider(
          create: (_) => IngredientsProvider(mealDbService, settingsService),
        ),
        ChangeNotifierProvider(
          create: (_) => CategoriesProvider(mealDbService),
        ),
        ChangeNotifierProvider(
          create: (_) => MealsByIngredientProvider(mealDbService),
        ),
        ChangeNotifierProvider(
          create: (_) => MealsByCategoryProvider(mealDbService),
        ),
        ChangeNotifierProvider(
          create: (_) => MealDetailProvider(mealDbService),
        ),
        ChangeNotifierProvider.value(value: recentMealsProvider),
      ],
      child: const RecipeApp(),
    ),
  );
}
