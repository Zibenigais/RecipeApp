import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/meal_summary.dart';

class MealTile extends StatelessWidget {
  final MealSummary meal;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;

  const MealTile({
    super.key,
    required this.meal,
    required this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: CachedNetworkImage(
          imageUrl: meal.thumbUrl,
          width: 56,
          height: 56,
          fit: BoxFit.cover,
          placeholder: (_, _) => const SizedBox(
            width: 56,
            height: 56,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          errorWidget: (_, _, _) => const Icon(Icons.restaurant, size: 40),
        ),
      ),
      title: Text(meal.name),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
      onLongPress: onLongPress,
    );
  }
}
