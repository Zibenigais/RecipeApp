import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/meal.dart';

class MealDetailView extends StatelessWidget {
  final Meal meal;

  const MealDetailView({super.key, required this.meal});

  @override
  Widget build(BuildContext context) {
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
                Text(
                  'Ingredients',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
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
                Text(
                  'Instructions',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
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
