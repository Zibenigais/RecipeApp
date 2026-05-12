import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/ingredient.dart';

class IngredientTile extends StatelessWidget {
  final Ingredient ingredient;
  final VoidCallback onTap;

  const IngredientTile({
    super.key,
    required this.ingredient,
    required this.onTap,
  });

  String get _thumbUrl =>
      'https://www.themealdb.com/images/ingredients/${Uri.encodeComponent(ingredient.name)}-Small.png';

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: CachedNetworkImage(
          imageUrl: _thumbUrl,
          width: 48,
          height: 48,
          fit: BoxFit.cover,
          placeholder: (_, _) => const SizedBox(
            width: 48,
            height: 48,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          errorWidget: (_, _, _) =>
              const Icon(Icons.local_dining, size: 40),
        ),
      ),
      title: Text(ingredient.name),
      subtitle: ingredient.type != null ? Text(ingredient.type!) : null,
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
