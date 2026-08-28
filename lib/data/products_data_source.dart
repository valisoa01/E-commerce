import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;
class ProductsDataSource {
  static const _assetPath = 'assets/data/products.json';

  Future<List<Map<String, dynamic>>> loadRawProducts() async {
    final jsonString = await rootBundle.loadString(_assetPath);
    final List<dynamic> decoded = jsonDecode(jsonString) as List<dynamic>;
    return decoded.cast<Map<String, dynamic>>();
  }
}
