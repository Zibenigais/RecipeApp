import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/shopping_list_provider.dart';
import '../providers/weekly_meal_plan_provider.dart';
import '../widgets/app_drawer.dart';

class ShoppingListScreen extends StatelessWidget {
  const ShoppingListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ShoppingListProvider>();
    final items = provider.items.entries.toList()
      ..sort((a, b) => a.value.displayName
          .toLowerCase()
          .compareTo(b.value.displayName.toLowerCase()));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping List'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Regenerate',
            onPressed: provider.isLoading
                ? null
                : () {
                    final plan = context.read<WeeklyMealPlanProvider>().plan;
                    provider.generate(plan);
                  },
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: Builder(
        builder: (context) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (items.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(24.0),
                child: Text(
                  'Add meals to your weekly plan, then tap refresh to build your shopping list.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            );
          }
          final hasChecked = items.any((e) => e.value.checked);
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, i) {
                    final entry = items[i];
                    final item = entry.value;
                    return CheckboxListTile(
                      title: Text(item.displayName),
                      subtitle: item.combinedMeasures.isEmpty
                          ? null
                          : Text(item.combinedMeasures),
                      value: item.checked,
                      onChanged: (_) => provider.toggle(entry.key),
                    );
                  },
                ),
              ),
              SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextButton.icon(
                    icon: const Icon(Icons.delete_sweep),
                    label: const Text('Clear checked'),
                    onPressed: hasChecked ? provider.clearChecked : null,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
