import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/random_meal_provider.dart';
import '../providers/ingredients_provider.dart'; // For LoadStatus
import '../widgets/app_drawer.dart';
import '../widgets/meal_detail_view.dart';
import '../widgets/loading_view.dart';
import '../widgets/error_view.dart';

class RandomMealScreen extends StatelessWidget {
  const RandomMealScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<RandomMealProvider>();
    final title = provider.status == LoadStatus.success && provider.meal != null
        ? provider.meal!.name
        : 'Surprise Me';

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      drawer: const AppDrawer(),
      body: Consumer<RandomMealProvider>(
        builder: (context, provider, child) {
          switch (provider.status) {
            case LoadStatus.idle:
            case LoadStatus.empty:
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Transform.rotate(
                      angle: 0.785398, // 45 degrees in radians (pi / 4)
                      child: const Icon(Icons.casino, size: 100, color: Colors.orange),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      "Don't know what to cook?",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.auto_awesome),
                      label: const Text('Surprise Me'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        textStyle: const TextStyle(fontSize: 18),
                      ),
                      onPressed: () => provider.fetchRandomMeal(),
                    ),
                  ],
                ),
              );
            case LoadStatus.loading:
              return const LoadingView(message: 'Sharpening the knives...');
            case LoadStatus.error:
              return ErrorView(
                message: provider.error,
                onRetry: () => provider.fetchRandomMeal(),
              );
            case LoadStatus.success:
              final meal = provider.meal;
              if (meal == null) return const LoadingView();
              return MealDetailView(meal: meal);
          }
        },
      ),
      floatingActionButton: Consumer<RandomMealProvider>(
        builder: (context, provider, child) {
          if (provider.status == LoadStatus.success) {
            return FloatingActionButton.extended(
              onPressed: () => provider.fetchRandomMeal(),
              icon: const Icon(Icons.refresh),
              label: const Text('Roll Again'),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
