import 'package:flutter/material.dart';

import '../models/cart_item.dart';
import 'quantity_selector.dart';

/// Affiche une ligne du panier : image, nom, prix, sélecteur de quantité
/// et bouton de suppression.
class CartItemTile extends StatelessWidget {
  final CartItem item;
  final ValueChanged<int> onQuantityChanged;
  final VoidCallback onRemove;

  const CartItemTile({
    super.key,
    required this.item,
    required this.onQuantityChanged,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final product = item.product;

    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: Image.asset(
          product.imageUrl,
          width: 56,
          height: 56,
          fit: BoxFit.cover,
        ),
      ),
      title: Text(product.name),
      subtitle: Text('${item.totalPrice.toStringAsFixed(2)} €'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          QuantitySelector(
            quantity: item.quantity,
            onChanged: onQuantityChanged,
          ),
          IconButton(
            onPressed: onRemove,
            icon: const Icon(Icons.delete_outline, color: Colors.red),
          ),
        ],
      ),
    );
  }
}
