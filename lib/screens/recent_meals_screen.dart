import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../providers/recent_meals_provider.dart';
import '../providers/ingredients_provider.dart'; // For LoadStatus
import '../models/meal_summary.dart';
import '../widgets/meal_tile.dart';
import '../widgets/empty_view.dart';
import '../widgets/app_drawer.dart';

class RecentMealsScreen extends StatelessWidget {
  const RecentMealsScreen({super.key});

  void _confirmClear(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Clear History'),
        content: const Text('Are you sure you want to clear your recently viewed meals?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<RecentMealsProvider>().clearAll();
              Navigator.pop(ctx);
            },
            child: const Text('Clear', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recent Meals'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            tooltip: 'Clear history',
            onPressed: () => _confirmClear(context),
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: Consumer<RecentMealsProvider>(
        builder: (context, provider, child) {
          if (provider.status == LoadStatus.empty || provider.items.isEmpty) {
            return const EmptyView(message: 'No recent meals found.');
          }

          return ListView.builder(
            itemCount: provider.items.length,
            itemBuilder: (context, index) {
              final meal = provider.items[index];
              final summary = MealSummary(
                id: meal.id,
                name: meal.name,
                thumbUrl: meal.thumbUrl,
              );
              return MealTile(
                meal: summary,
                onTap: () => context.push('/meal/${meal.id}'),
              );
            },
          );
        },
      ),
    );
  }
}
