import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../providers/meals_by_ingredient_provider.dart';
import '../providers/ingredients_provider.dart';
import '../widgets/meal_tile.dart';
import '../widgets/loading_view.dart';
import '../widgets/error_view.dart';
import '../widgets/empty_view.dart';

class MealsScreen extends StatefulWidget {
  final String ingredient;

  const MealsScreen({super.key, required this.ingredient});

  @override
  State<MealsScreen> createState() => _MealsScreenState();
}

class _MealsScreenState extends State<MealsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MealsByIngredientProvider>().fetch(widget.ingredient);
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MealsByIngredientProvider>();

    return Scaffold(
      appBar: AppBar(title: Text(widget.ingredient)),
      body: _buildBody(provider),
    );
  }

  Widget _buildBody(MealsByIngredientProvider provider) {
    switch (provider.status) {
      case LoadStatus.idle:
      case LoadStatus.loading:
        return const LoadingView();
      case LoadStatus.error:
        return ErrorView(
          message: provider.error,
          onRetry: () => provider.fetch(widget.ingredient),
        );
      case LoadStatus.empty:
        return EmptyView(message: 'No meals found for ${widget.ingredient}');
      case LoadStatus.success:
        return ListView.separated(
          itemCount: provider.meals.length,
          separatorBuilder: (_, _) => const Divider(height: 1),
          itemBuilder: (_, index) {
            final meal = provider.meals[index];
            return MealTile(
              meal: meal,
              onTap: () => context.push('/meal/${meal.id}'),
            );
          },
        );
    }
  }
}
