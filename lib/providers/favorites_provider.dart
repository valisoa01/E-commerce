import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/favorites_storage_service.dart';
class FavoritesNotifier extends Notifier<Set<String>> {
  late final FavoritesStorageService _storageService;

  @override
  Set<String> build() {
    _storageService = ref.watch(favoritesStorageServiceProvider); 
    _loadFromStorage();
    return <String>{};
  }

  Future<void> _loadFromStorage() async {
    final savedIds = await _storageService.loadFavoriteIds();
    state = savedIds;
  }

  bool isFavorite(String productId) => state.contains(productId);
  void toggleFavorite(String productId) {
    final newState = <String>{...state};

    if (newState.contains(productId)) {
      newState.remove(productId);
    } else {
      newState.add(productId);
    }

    state = newState;
    _storageService.saveFavoriteIds(newState);
  }
}
final favoritesStorageServiceProvider = Provider<FavoritesStorageService>((ref) {
  return FavoritesStorageService();
});
final favoritesProvider = NotifierProvider<FavoritesNotifier, Set<String>>(
  FavoritesNotifier.new,
);
