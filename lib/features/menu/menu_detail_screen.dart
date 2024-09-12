import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../data/models/menu.dart';
import '../../common/shoplist/cart_logic.dart';

class MenuDetailScreen extends ConsumerStatefulWidget {
  final Menu menu;
  final String imageUrl;

  const MenuDetailScreen({Key? key, required this.menu, required this.imageUrl})
      : super(key: key);

  @override
  _MenuDetailScreenState createState() => _MenuDetailScreenState();
}

class _MenuDetailScreenState extends ConsumerState<MenuDetailScreen> {
  late int _quantity;
  bool _isAlreadyInWishlist = false;

  @override
  void initState() {
    super.initState();
    _initializeQuantity();
  }

  void _initializeQuantity() {
    final cartItems = ref.read(cartProvider);
    final cartItem = cartItems.firstWhere(
      (item) => item.menu.id == widget.menu.id,
      orElse: () => CartItem(menu: widget.menu, quantity: 0),
    );
    _quantity = cartItem.quantity > 0 ? cartItem.quantity : 1;
    _isAlreadyInWishlist = cartItem.quantity > 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.menu.name[context.locale.languageCode]!),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  constraints: BoxConstraints(
                    maxHeight: 300,
                    maxWidth: MediaQuery.of(context).size.width,
                  ),
                  child: Image.network(
                    widget.imageUrl,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.error),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                widget.menu.name[context.locale.languageCode]!,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 8),
              Text(
                '₩${widget.menu.price}',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),
              Text(widget.menu.description[context.locale.languageCode]!),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildQuantitySelector(),
                  ElevatedButton(
                    onPressed: () {
                      if (_quantity == 0) {
                        _removeFromWishlist();
                      } else {
                        _addOrUpdateWishlist();
                      }
                      // 기존 SnackBar를 모두 제거
                      ScaffoldMessenger.of(context).clearSnackBars();
                      // 새로운 SnackBar 표시 (지속 시간 단축)
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            _quantity == 0
                                ? 'removed_from_cart'.tr(args: [
                                    widget
                                        .menu.name[context.locale.languageCode]!
                                  ])
                                : 'updated_in_cart'.tr(args: [
                                    widget
                                        .menu.name[context.locale.languageCode]!
                                  ]),
                          ),
                          duration:
                              const Duration(milliseconds: 1500), // 지속 시간 단축
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                    ),
                    child: Text(
                      _quantity == 0
                          ? 'remove_from_cart'
                          : _isAlreadyInWishlist
                              ? 'update_cart'
                              : 'add_to_cart',
                      style: TextStyle(color: Colors.white),
                    ).tr(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuantitySelector() {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.remove),
          onPressed: () {
            setState(() {
              if (_quantity > 0) _quantity--;
            });
          },
        ),
        Text(
          _quantity.toString(),
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: () {
            setState(() {
              _quantity++;
            });
          },
        ),
      ],
    );
  }

  void _addOrUpdateWishlist() {
    final cartItems = ref.read(cartProvider);
    final cartItem = cartItems.firstWhere(
      (item) => item.menu.id == widget.menu.id,
      orElse: () => CartItem(menu: widget.menu, quantity: 0),
    );

    if (cartItem.quantity > 0) {
      ref.read(cartProvider.notifier).updateQuantity(cartItem, _quantity);
    } else {
      ref.read(cartProvider.notifier).addToCart(widget.menu, _quantity);
    }
  }

  void _removeFromWishlist() {
    final cartItems = ref.read(cartProvider);
    final cartItem = cartItems.firstWhere(
      (item) => item.menu.id == widget.menu.id,
      orElse: () => CartItem(menu: widget.menu, quantity: 0),
    );

    if (cartItem.quantity > 0) {
      ref.read(cartProvider.notifier).removeFromCart(cartItem);
    }
  }
}
