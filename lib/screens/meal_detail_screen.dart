import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/meal_detail_provider.dart';
import '../providers/ingredients_provider.dart';
import '../providers/recent_meals_provider.dart';
import '../widgets/favourite_button.dart';
import '../widgets/loading_view.dart';
import '../widgets/error_view.dart';
import '../widgets/meal_detail_view.dart';

class MealDetailScreen extends StatefulWidget {
  final String mealId;

  const MealDetailScreen({super.key, required this.mealId});

  @override
  State<MealDetailScreen> createState() => _MealDetailScreenState();
}

class _MealDetailScreenState extends State<MealDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final provider = context.read<MealDetailProvider>();
      await provider.fetch(widget.mealId);
      final meal = provider.meal;
      if (meal != null && mounted) {
        context.read<RecentMealsProvider>().add(meal);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MealDetailProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text(provider.meal?.name ?? 'Meal Detail'),
        actions: [
          if (provider.meal != null) FavouriteButton(meal: provider.meal!),
        ],
      ),
      body: _buildBody(provider),
    );
  }

  Widget _buildBody(MealDetailProvider provider) {
    switch (provider.status) {
      case LoadStatus.idle:
      case LoadStatus.loading:
        return const LoadingView();
      case LoadStatus.error:
        return ErrorView(
          message: provider.error,
          onRetry: () => provider.fetch(widget.mealId),
        );
      case LoadStatus.empty:
      case LoadStatus.success:
        final meal = provider.meal;
        if (meal == null) return const LoadingView();
        return MealDetailView(meal: meal);
    }
  }
}
