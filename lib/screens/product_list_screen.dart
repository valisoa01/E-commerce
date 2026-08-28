import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/filter_provider.dart';
import '../widgets/product_card.dart';
class ProductListScreen extends ConsumerWidget {
  const ProductListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filteredProducts = ref.watch(filteredProductsProvider);
    final categoriesAsync = ref.watch(categoriesProvider);
    final selectedCategory = ref.watch(selectedCategoryProvider);
    final sortOption = ref.watch(sortOptionProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Produits'),
        actions: [
          PopupMenuButton<SortOption>(
            icon: const Icon(Icons.sort),
            tooltip: 'Trier',
            initialValue: sortOption,
            onSelected: (value) {
              ref.read(sortOptionProvider.notifier).setSort(value);
            },
            itemBuilder: (context) => const [
              PopupMenuItem(value: SortOption.none, child: Text('Par défaut')),
              PopupMenuItem(value: SortOption.priceAsc, child: Text('Prix croissant')),
              PopupMenuItem(value: SortOption.priceDesc, child: Text('Prix décroissant')),
              PopupMenuItem(value: SortOption.nameAsc, child: Text('Nom (A-Z)')),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Rechercher un produit...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
                isDense: true,
              ),
              onChanged: (value) {
                ref.read(searchQueryProvider.notifier).setQuery(value);
              },
            ),
          ),
          const SizedBox(height: 8),
          categoriesAsync.when(
            data: (categories) => _CategoryFilterRow(
              categories: categories,
              selectedCategory: selectedCategory,
            ),
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),
          const SizedBox(height: 4),
          Expanded(
            child: filteredProducts.when(
              data: (products) {
                if (products.isEmpty) {
                  return const Center(child: Text('Aucun produit trouvé.'));
                }
                return GridView.builder(
                  padding: const EdgeInsets.all(12),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.72,
                  ),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    return ProductCard(product: products[index]);
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(child: Text('Erreur : $error')),
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryFilterRow extends ConsumerWidget {
  final List<String> categories;
  final String? selectedCategory;

  const _CategoryFilterRow({
    required this.categories,
    required this.selectedCategory,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: 40,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        children: [
          _CategoryChip(
            label: 'Toutes',
            selected: selectedCategory == null,
            onTap: () => ref.read(selectedCategoryProvider.notifier).setCategory(null),
          ),
          for (final category in categories)
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: _CategoryChip(
                label: category,
                selected: selectedCategory == category,
                onTap: () =>
                    ref.read(selectedCategoryProvider.notifier).setCategory(category),
              ),
            ),
        ],
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _CategoryChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onTap(),
    );
  }
}
