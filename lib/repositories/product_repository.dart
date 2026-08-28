import 'dart:async';

import '../data/products_data_source.dart';
import '../models/product.dart';
 
class ProductRepository {
  ProductRepository({ProductsDataSource? dataSource})
      : _dataSource = dataSource ?? ProductsDataSource();

  final ProductsDataSource _dataSource;

  Future<List<Product>> getProducts() async {
   await Future.delayed(const Duration(seconds: 1));

    final rawProducts = await _dataSource.loadRawProducts();
    return rawProducts.map(Product.fromJson).toList();
  }
}
