import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
            ),
            child: const Text(
              'Recipe App',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.local_dining),
            title: const Text('Ingredients'),
            onTap: () {
              Navigator.pop(context);
              context.go('/');
            },
          ),
          ListTile(
            leading: const Icon(Icons.category),
            title: const Text('Categories'),
            onTap: () {
              Navigator.pop(context);
              context.go('/categories');
            },
          ),
          ListTile(
            leading: const Icon(Icons.history),
            title: const Text('Recent Meals'),
            onTap: () {
              Navigator.pop(context);
              context.go('/recent_meals');
            },
          ),
          ListTile(
            leading: const Icon(Icons.favorite),
            title: const Text('Favourites'),
            onTap: () {
              Navigator.pop(context);
              context.go('/favourites');
            },
          ),
          ListTile(
            leading: Transform.rotate(
              angle: 0.785398, // 45 degrees (pi / 4)
              child: const Icon(Icons.casino),
            ),
            title: const Text('Surprise Me'),
            onTap: () {
              Navigator.pop(context);
              context.go('/surprise-me');
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              Navigator.pop(context);
              context.push('/settings');
            },
          ),
        ],
      ),
    );
  }
}