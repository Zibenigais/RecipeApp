import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import '../providers/weekly_meal_plan_provider.dart';
import '../models/weekly_meal_plan.dart';
import '../models/meal.dart';
import '../widgets/app_drawer.dart';

class WeeklyPlannerScreen extends StatelessWidget {
  static const List<String> days = [
    'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'
  ];

  const WeeklyPlannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final plan = context.watch<WeeklyMealPlanProvider>().plan;
    return Scaffold(
      appBar: AppBar(title: const Text('Weekly Meal Plan')),
      drawer: const AppDrawer(),
      body: ListView.builder(
        itemCount: 7,
        itemBuilder: (context, dayIndex) {
          final meals = plan.meals[dayIndex] ?? [];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(days[dayIndex], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                      IconButton(
                        icon: const Icon(Icons.add),
                        tooltip: 'Add meal',
                        onPressed: () async {
                          final selected = await showSearch<PlannedMeal?>(
                            context: context,
                            delegate: MealSearchDelegate(),
                          );
                          if (selected != null) {
                            context.read<WeeklyMealPlanProvider>().addMeal(dayIndex, selected);
                          }
                        },
                      ),
                    ],
                  ),
                  if (meals.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Text('No meals planned.', style: TextStyle(color: Colors.grey)),
                    ),
                  ...List.generate(meals.length, (mealIndex) {
                    final meal = meals[mealIndex];
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Image.network(meal.mealThumb, width: 40, height: 40),
                      title: Text(meal.mealName),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        tooltip: 'Remove meal',
                        onPressed: () => context.read<WeeklyMealPlanProvider>().removeMeal(dayIndex, mealIndex),
                      ),
                    );
                  }),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class MealSearchDelegate extends SearchDelegate<PlannedMeal?> {
  @override
  List<Widget>? buildActions(BuildContext context) => [
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () => query = '',
        ),
      ];

  @override
  Widget? buildLeading(BuildContext context) => IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => close(context, null),
      );

  @override
  Widget buildResults(BuildContext context) => _buildResults(context);

  @override
  Widget buildSuggestions(BuildContext context) => _buildResults(context);

  Widget _buildResults(BuildContext context) {
    return FutureBuilder<List<PlannedMeal>>(
      future: query.isEmpty ? _fetchAllMeals() : _searchMeals(query),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No meals found'));
        }
        final meals = snapshot.data!;
        meals.sort((a, b) => a.mealName.compareTo(b.mealName));
        return ListView.builder(
          itemCount: meals.length,
          itemBuilder: (context, index) {
            final meal = meals[index];
            return ListTile(
              title: Text(meal.mealName),
              leading: Image.network(meal.mealThumb, width: 40, height: 40),
              onTap: () async {
                final detail = await _fetchMealDetail(meal.mealId);
                if (detail == null) return;
                final result = await showDialog<PlannedMeal?>(
                  context: context,
                  builder: (context) => MealDetailDialog(meal: detail),
                );
                if (result != null) {
                  close(context, result);
                }
              },
            );
          },
        );
      },
    );
  }

  Future<List<PlannedMeal>> _searchMeals(String query) async {
    final uri = Uri.parse('https://www.themealdb.com/api/json/v1/1/search.php?s=${Uri.encodeComponent(query)}');
    final response = await http.get(uri);
    if (response.statusCode != 200) return [];
    final body = jsonDecode(response.body) as Map<String, dynamic>;
    final meals = body['meals'] as List<dynamic>?;
    if (meals == null) return [];
    return meals.map((e) => PlannedMeal(
      mealId: e['idMeal'] as String,
      mealName: e['strMeal'] as String,
      mealThumb: e['strMealThumb'] as String,
    )).toList();
  }

  Future<List<PlannedMeal>> _fetchAllMeals() async {
    List<PlannedMeal> all = [];
    for (var c in 'abcdefghijklmnopqrstuvwxyz'.split('')) {
      final uri = Uri.parse('https://www.themealdb.com/api/json/v1/1/search.php?f=$c');
      final response = await http.get(uri);
      if (response.statusCode != 200) continue;
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      final meals = body['meals'] as List<dynamic>?;
      if (meals == null) continue;
      all.addAll(meals.map((e) => PlannedMeal(
        mealId: e['idMeal'] as String,
        mealName: e['strMeal'] as String,
        mealThumb: e['strMealThumb'] as String,
      )));
    }
    return all;
  }

  Future<Meal?> _fetchMealDetail(String id) async {
    final uri = Uri.parse('https://www.themealdb.com/api/json/v1/1/lookup.php?i=$id');
    final response = await http.get(uri);
    if (response.statusCode != 200) return null;
    final body = jsonDecode(response.body) as Map<String, dynamic>;
    final meals = body['meals'] as List<dynamic>?;
    if (meals == null || meals.isEmpty) return null;
    return Meal.fromJson(meals.first as Map<String, dynamic>);
  }
}

class MealDetailDialog extends StatelessWidget {
  final Meal meal;
  const MealDetailDialog({super.key, required this.meal});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(meal.name),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (meal.thumbUrl.isNotEmpty)
              Center(child: Image.network(meal.thumbUrl, width: 120, height: 120)),
            const SizedBox(height: 8),
            Text('Ingredients:', style: const TextStyle(fontWeight: FontWeight.bold)),
            ...meal.ingredients.map((im) => Text('${im.ingredient}: ${im.measure}')),
            const SizedBox(height: 8),
            if (meal.instructions.isNotEmpty)
              Text('Instructions:', style: const TextStyle(fontWeight: FontWeight.bold)),
            if (meal.instructions.isNotEmpty)
              Text(meal.instructions, maxLines: 6, overflow: TextOverflow.ellipsis),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(PlannedMeal(
            mealId: meal.id,
            mealName: meal.name,
            mealThumb: meal.thumbUrl,
          )),
          child: const Text('Add'),
        ),
      ],
    );
  }
}
