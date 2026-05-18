import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../models/meal.dart';
import '../models/meal_summary.dart';
import '../providers/favourites_provider.dart';
import '../providers/ingredients_provider.dart';
import '../widgets/app_drawer.dart';
import '../widgets/empty_view.dart';
import '../widgets/error_view.dart';
import '../widgets/loading_view.dart';
import '../widgets/meal_tile.dart';

class FavouritesScreen extends StatefulWidget {
  const FavouritesScreen({super.key});

  @override
  State<FavouritesScreen> createState() => _FavouritesScreenState();
}

class _FavouritesScreenState extends State<FavouritesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<FavouritesProvider>();
      if (provider.status == LoadStatus.idle) {
        provider.load();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<FavouritesProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Favourites')),
      drawer: const AppDrawer(),
      body: _buildBody(provider),
    );
  }

  Widget _buildBody(FavouritesProvider provider) {
    switch (provider.status) {
      case LoadStatus.idle:
      case LoadStatus.loading:
        return const LoadingView();
      case LoadStatus.error:
        return ErrorView(message: provider.error, onRetry: provider.load);
      case LoadStatus.empty:
        return const EmptyView(message: 'No favourite meals yet');
      case LoadStatus.success:
        final meals = provider.favouriteMeals;
        if (meals.isEmpty) {
          return const EmptyView(message: 'No favourite meals yet');
        }

        return ListView.separated(
          itemCount: meals.length,
          separatorBuilder: (_, _) => const Divider(height: 1),
          itemBuilder: (_, index) {
            final meal = meals[index];
            return MealTile(
              meal: MealSummary(
                id: meal.id,
                name: meal.name,
                thumbUrl: meal.thumbUrl,
              ),
              onTap: () => context.push('/meal/${meal.id}'),
              onLongPress: () => _confirmAndRemove(meal),
            );
          },
        );
    }
  }

  Future<void> _confirmAndRemove(Meal meal) async {
    final shouldRemove = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Remove favourite'),
          content: Text('Remove "${meal.name}" from favourites?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('Remove'),
            ),
          ],
        );
      },
    );

    if (shouldRemove == true && mounted) {
      await context.read<FavouritesProvider>().toggle(meal.id, meal);
    }
  }
}
