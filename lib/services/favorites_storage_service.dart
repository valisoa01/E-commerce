import 'package:shared_preferences/shared_preferences.dart';

class FavoritesStorageService {
  static const _storageKey = 'favorite_product_ids';

  Future<Set<String>> loadFavoriteIds() async {
    final prefs = await SharedPreferences.getInstance();
    final ids = prefs.getStringList(_storageKey) ?? <String>[];
    return ids.toSet();
  }

  Future<void> saveFavoriteIds(Set<String> ids) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_storageKey, ids.toList());
  }
}
