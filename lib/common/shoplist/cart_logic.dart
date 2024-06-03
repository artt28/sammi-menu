import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/menu.dart';

class CartItem {
  final Menu menu;
  int quantity;

  CartItem({required this.menu, required this.quantity});
}

class CartState extends StateNotifier<List<CartItem>> {
  CartState() : super([]);

  void addToCart(Menu menu, int quantity) {
    state = [
      for (final item in state)
        if (item.menu == menu)
          if (item.quantity + quantity > 0)
            CartItem(menu: item.menu, quantity: item.quantity + quantity)
          else
            ...[]
        else
          item,
      if (!state.any((item) => item.menu == menu) && quantity > 0)
        CartItem(menu: menu, quantity: quantity),
    ];
  }

  void removeFromCart(CartItem cartItem) {
    state = state.where((item) => item != cartItem).toList();
  }

  void updateQuantity(CartItem cartItem, int quantity) {
    state = state
        .map((item) {
      if (item == cartItem) {
        if (quantity == 0) {
          return null; // Mark item for removal
        } else {
          return CartItem(menu: item.menu, quantity: quantity);
        }
      }
      return item;
    })
        .where((item) => item != null) // Remove null entries
        .cast<CartItem>()
        .toList();
  }

  void clearCart() {
    state = [];
  }
}

final cartProvider = StateNotifierProvider<CartState, List<CartItem>>((ref) {
  return CartState();
});
