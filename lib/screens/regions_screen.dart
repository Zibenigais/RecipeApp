import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../providers/areas_provider.dart';
import '../providers/ingredients_provider.dart'; // for LoadStatus
import '../validators/search_validator.dart';
import '../widgets/app_drawer.dart';
import '../widgets/area_tile.dart';
import '../widgets/loading_view.dart';
import '../widgets/error_view.dart';
import '../widgets/empty_view.dart';

class RegionsScreen extends StatefulWidget {
  const RegionsScreen({super.key});

  @override
  State<RegionsScreen> createState() => _RegionsScreenState();
}

class _RegionsScreenState extends State<RegionsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AreasProvider>().fetch();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    context.read<AreasProvider>().filter(value);
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AreasProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Meals by Region')),
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
                  hintText: 'Search regions…',
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

  Widget _buildBody(AreasProvider provider) {
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
        return const EmptyView(message: 'No regions found');
      case LoadStatus.success:
        return ListView.separated(
          itemCount: provider.areas.length,
          separatorBuilder: (_, _) => const Divider(height: 1),
          itemBuilder: (_, index) {
            final area = provider.areas[index];
            return AreaTile(
              area: area,
              onTap: () => context.push('/meals/region/${area.name}'),
            );
          },
        );
    }
  }
}
