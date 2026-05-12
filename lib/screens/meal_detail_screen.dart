import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../providers/meal_detail_provider.dart';
import '../providers/ingredients_provider.dart';
import '../models/meal.dart';
import '../widgets/loading_view.dart';
import '../widgets/error_view.dart';

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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MealDetailProvider>().fetch(widget.mealId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MealDetailProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text(provider.meal?.name ?? 'Meal Detail'),
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
        return _buildDetail(meal);
    }
  }

  Widget _buildDetail(Meal meal) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CachedNetworkImage(
            imageUrl: meal.thumbUrl,
            width: double.infinity,
            height: 250,
            fit: BoxFit.cover,
            placeholder: (_, _) => const SizedBox(
              height: 250,
              child: Center(child: CircularProgressIndicator()),
            ),
            errorWidget: (_, _, _) => const SizedBox(
              height: 250,
              child: Icon(Icons.restaurant, size: 80),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _chip(Icons.category, meal.category),
                _chip(Icons.public, meal.area),
                const SizedBox(height: 16),
                Text('Ingredients',
                    style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                ...meal.ingredients.map(
                  (i) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Row(
                      children: [
                        const Icon(Icons.fiber_manual_record, size: 8),
                        const SizedBox(width: 8),
                        Expanded(child: Text('${i.ingredient} — ${i.measure}')),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text('Instructions',
                    style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                Text(meal.instructions),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _chip(IconData icon, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey),
          const SizedBox(width: 6),
          Text(label, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}
