import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/category.dart';

class CategoryTile extends StatelessWidget {
  final Category category;
  final VoidCallback onTap;

  const CategoryTile({
    super.key,
    required this.category,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: CachedNetworkImage(
          imageUrl: category.thumb,
          width: 60,
          height: 48,
          fit: BoxFit.cover,
          placeholder: (_, _) => const SizedBox(
            width: 60,
            height: 48,
            child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
          ),
          errorWidget: (_, _, _) => const SizedBox(
            width: 60,
            height: 48,
            child: Icon(Icons.error),
          ),
        ),
      ),
      title: Text(category.name),
      subtitle: Text(
        category.description,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      onTap: onTap,
    );
  }
}
