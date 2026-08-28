import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/product.dart';
import '../providers/cart_provider.dart';
import '../providers/favorites_provider.dart';
import '../providers/product_provider.dart';
import '../widgets/quantity_selector.dart';
class ProductDetailScreen extends ConsumerStatefulWidget {
  final String productId;

  const ProductDetailScreen({super.key, required this.productId});

  @override
  ConsumerState<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends ConsumerState<ProductDetailScreen> {
  int _quantity = 1;

  @override
  Widget build(BuildContext context) {
    final productsAsync = ref.watch(productsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Détail du produit')),
      body: productsAsync.when(
        data: (products) {
          final product = products.firstWhere((p) => p.id == widget.productId);
          return _ProductDetailBody(
            product: product,
            quantity: _quantity,
            onQuantityChanged: (value) {
              setState(() => _quantity = value < 1 ? 1 : value);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Erreur : $error')),
      ),
    );
  }
}

class _ProductDetailBody extends ConsumerStatefulWidget {
  final Product product;
  final int quantity;
  final ValueChanged<int> onQuantityChanged;

  const _ProductDetailBody({
    required this.product,
    required this.quantity,
    required this.onQuantityChanged,
  });

  @override
  ConsumerState<_ProductDetailBody> createState() => _ProductDetailBodyState();
}

class _ProductDetailBodyState extends ConsumerState<_ProductDetailBody>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 180),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.15)
        .chain(CurveTween(curve: Curves.easeOut))
        .animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleAddToCart() {
    ref.read(cartProvider.notifier).addProduct(widget.product);

    _animationController.forward().then((_) => _animationController.reverse());

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${widget.product.name} ajouté au panier (x${widget.quantity})'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final favorites = ref.watch(favoritesProvider);
    final isFavorite = favorites.contains(product.id);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Image.asset(
                product.imageUrl,
                width: double.infinity,
                height: 260,
                fit: BoxFit.cover,
              ),
              Positioned(
                top: 12,
                right: 12,
                child: FloatingActionButton.small(
                  heroTag: 'favorite_${product.id}',
                  backgroundColor: Colors.white,
                  onPressed: () {
                    ref.read(favoritesProvider.notifier).toggleFavorite(product.id);
                  },
                  child: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: Colors.red,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.category,
                  style: TextStyle(color: Theme.of(context).colorScheme.primary),
                ),
                const SizedBox(height: 4),
                Text(
                  product.name,
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  '${product.price.toStringAsFixed(2)} €',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 16),
                Text(
                  product.description,
                  style: const TextStyle(fontSize: 15, height: 1.4),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Quantité', style: TextStyle(fontWeight: FontWeight.bold)),
                    QuantitySelector(
                      quantity: widget.quantity,
                      onChanged: widget.onQuantityChanged,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ScaleTransition(
                    scale: _scaleAnimation,
                    child: FilledButton.icon(
                      onPressed: _handleAddToCart,
                      icon: const Icon(Icons.add_shopping_cart),
                      label: const Text('Ajouter au panier'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
