import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../providers/meals_by_area_provider.dart';
import '../providers/ingredients_provider.dart'; // for LoadStatus
import '../widgets/meal_tile.dart';
import '../widgets/loading_view.dart';
import '../widgets/error_view.dart';
import '../widgets/empty_view.dart';

class RegionMealsScreen extends StatefulWidget {
  final String region;

  const RegionMealsScreen({super.key, required this.region});

  @override
  State<RegionMealsScreen> createState() => _RegionMealsScreenState();
}

class _RegionMealsScreenState extends State<RegionMealsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MealsByAreaProvider>().fetch(widget.region);
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MealsByAreaProvider>();

    return Scaffold(
      appBar: AppBar(title: Text('${widget.region} Cuisine')),
      body: _buildBody(provider),
    );
  }

  Widget _buildBody(MealsByAreaProvider provider) {
    switch (provider.status) {
      case LoadStatus.idle:
      case LoadStatus.loading:
        return const LoadingView();
      case LoadStatus.error:
        return ErrorView(
          message: provider.error,
          onRetry: () => provider.fetch(widget.region),
        );
      case LoadStatus.empty:
        return EmptyView(message: 'No meals found for ${widget.region}');
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
