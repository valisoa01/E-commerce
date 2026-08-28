import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/product.dart';
import 'product_provider.dart';
 
enum SortOption {
  none,
  priceAsc,
  priceDesc,
  nameAsc,
}
 
class SearchQueryNotifier extends Notifier<String> {
  @override
  String build() => '';

  void setQuery(String query) => state = query;
}

final searchQueryProvider = NotifierProvider<SearchQueryNotifier, String>(
  SearchQueryNotifier.new,
);
 
class SelectedCategoryNotifier extends Notifier<String?> {
  @override
  String? build() => null;

  void setCategory(String? category) => state = category;
}

final selectedCategoryProvider = NotifierProvider<SelectedCategoryNotifier, String?>(
  SelectedCategoryNotifier.new,
);

class SortOptionNotifier extends Notifier<SortOption> {
  @override
  SortOption build() => SortOption.none;

  void setSort(SortOption option) => state = option;
}

final sortOptionProvider = NotifierProvider<SortOptionNotifier, SortOption>(
  SortOptionNotifier.new,
);
 
final filteredProductsProvider = Provider<AsyncValue<List<Product>>>((ref) {
  final productsAsync = ref.watch(productsProvider);
  final query = ref.watch(searchQueryProvider).toLowerCase();
  final category = ref.watch(selectedCategoryProvider);
  final sortOption = ref.watch(sortOptionProvider);

  return productsAsync.whenData((products) {
    var result = products.where((product) {
      final matchesQuery =
          query.isEmpty || product.name.toLowerCase().contains(query);
      final matchesCategory = category == null || product.category == category;
      return matchesQuery && matchesCategory;
    }).toList();

    switch (sortOption) {
      case SortOption.priceAsc:
        result.sort((a, b) => a.price.compareTo(b.price));
        break;
      case SortOption.priceDesc:
        result.sort((a, b) => b.price.compareTo(a.price));
        break;
      case SortOption.nameAsc:
        result.sort((a, b) => a.name.compareTo(b.name));
        break;
      case SortOption.none:
        break;
    }

    return result;
  });
});
final categoriesProvider = Provider<AsyncValue<List<String>>>((ref) {
  final productsAsync = ref.watch(productsProvider);
  return productsAsync.whenData((products) {
    return products.map((p) => p.category).toSet().toList()..sort();
  });
});
