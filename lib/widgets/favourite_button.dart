import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/meal.dart';
import '../providers/favourites_provider.dart';

class FavouriteButton extends StatelessWidget {
  final Meal meal;

  const FavouriteButton({super.key, required this.meal});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<FavouritesProvider>();
    final isFavourite = provider.isFavourite(meal.id);

    return IconButton(
      tooltip: isFavourite ? 'Remove favourite' : 'Add favourite',
      icon: Icon(isFavourite ? Icons.favorite : Icons.favorite_border),
      onPressed: () async {
        await context.read<FavouritesProvider>().toggle(meal.id, meal);
        if (!context.mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isFavourite ? 'Removed from favourites' : 'Added to favourites',
            ),
            duration: const Duration(seconds: 1),
          ),
        );
      },
    );
  }
}
