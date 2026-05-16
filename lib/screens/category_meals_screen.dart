import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../providers/meals_by_category_provider.dart';
import '../providers/ingredients_provider.dart'; // for LoadStatus
import '../widgets/meal_tile.dart';
import '../widgets/loading_view.dart';
import '../widgets/error_view.dart';
import '../widgets/empty_view.dart';

class CategoryMealsScreen extends StatefulWidget {
  final String category;

  const CategoryMealsScreen({super.key, required this.category});

  @override
  State<CategoryMealsScreen> createState() => _CategoryMealsScreenState();
}

class _CategoryMealsScreenState extends State<CategoryMealsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MealsByCategoryProvider>().fetch(widget.category);
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MealsByCategoryProvider>();

    return Scaffold(
      appBar: AppBar(title: Text(widget.category)),
      body: _buildBody(provider),
    );
  }

  Widget _buildBody(MealsByCategoryProvider provider) {
    switch (provider.status) {
      case LoadStatus.idle:
      case LoadStatus.loading:
        return const LoadingView();
      case LoadStatus.error:
        return ErrorView(
          message: provider.error,
          onRetry: () => provider.fetch(widget.category),
        );
      case LoadStatus.empty:
        return EmptyView(message: 'No meals found for ${widget.category}');
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
