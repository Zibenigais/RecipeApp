import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../providers/ingredients_provider.dart';
import '../validators/search_validator.dart';
import '../widgets/app_drawer.dart';
import '../widgets/ingredient_tile.dart';
import '../widgets/loading_view.dart';
import '../widgets/error_view.dart';
import '../widgets/empty_view.dart';

class IngredientsScreen extends StatefulWidget {
  const IngredientsScreen({super.key});

  @override
  State<IngredientsScreen> createState() => _IngredientsScreenState();
}

class _IngredientsScreenState extends State<IngredientsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<IngredientsProvider>().fetch();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    context.read<IngredientsProvider>().filter(value);
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<IngredientsProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Ingredients')),
      drawer: const AppDrawer(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Form(
              key: _formKey,
              child: TextFormField(
                controller: _searchController,
                validator: validateSearch,
                onChanged: _onSearchChanged,
                decoration: InputDecoration(
                  hintText: 'Search ingredients…',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            _onSearchChanged('');
                          },
                        )
                      : null,
                ),
              ),
            ),
          ),
          Expanded(child: _buildBody(provider)),
        ],
      ),
    );
  }

  Widget _buildBody(IngredientsProvider provider) {
    switch (provider.status) {
      case LoadStatus.idle:
      case LoadStatus.loading:
        return const LoadingView();
      case LoadStatus.error:
        return ErrorView(
          message: provider.error,
          onRetry: () => provider.fetch(),
        );
      case LoadStatus.empty:
        return const EmptyView(message: 'No ingredients found');
      case LoadStatus.success:
        return ListView.separated(
          itemCount: provider.ingredients.length,
          separatorBuilder: (_, _) => const Divider(height: 1),
          itemBuilder: (_, index) {
            final ingredient = provider.ingredients[index];
            return IngredientTile(
              ingredient: ingredient,
              onTap: () => context.push('/meals/${ingredient.name}'),
            );
          },
        );
    }
  }
}
