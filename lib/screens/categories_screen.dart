import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../providers/categories_provider.dart';
import '../providers/ingredients_provider.dart'; // for LoadStatus
import '../validators/search_validator.dart';
import '../widgets/app_drawer.dart';
import '../widgets/category_tile.dart';
import '../widgets/loading_view.dart';
import '../widgets/error_view.dart';
import '../widgets/empty_view.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final _formKey = GlobalKey<FormState>();
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CategoriesProvider>().fetch();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    context.read<CategoriesProvider>().filter(value);
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CategoriesProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Categories')),
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
                  hintText: 'Search categories…',
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

  Widget _buildBody(CategoriesProvider provider) {
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
        return const EmptyView(message: 'No categories found');
      case LoadStatus.success:
        return ListView.separated(
          itemCount: provider.categories.length,
          separatorBuilder: (_, _) => const Divider(height: 1),
          itemBuilder: (_, index) {
            final category = provider.categories[index];
            return CategoryTile(
              category: category,
              onTap: () => context.push('/meals/category/${category.name}'),
            );
          },
        );
    }
  }
}
