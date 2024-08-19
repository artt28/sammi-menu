import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:easy_localization/easy_localization.dart';
import '../../data/models/menu.dart';
import '../../common/shoplist/cart_logic.dart';

class MenuDetailScreen extends ConsumerStatefulWidget {
  final Menu menu;

  const MenuDetailScreen({Key? key, required this.menu}) : super(key: key);

  @override
  _MenuDetailScreenState createState() => _MenuDetailScreenState();
}

class _MenuDetailScreenState extends ConsumerState<MenuDetailScreen> {
  late int _quantity;
  late Future<String> _imageUrlFuture;
  bool _isAlreadyInWishlist = false;

  @override
  void initState() {
    super.initState();
    _imageUrlFuture = _getImageUrl(widget.menu.imageUrl);
    _initializeQuantity();
  }

  void _initializeQuantity() {
    // Check if the item is already in the wishlist
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImage(),
            const SizedBox(height: 16),
            Text(
              widget.menu.name[context.locale.languageCode]!,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(widget.menu.description[context.locale.languageCode]!),
            const SizedBox(height: 16),
            Text(
              '₩${widget.menu.price}',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            _buildQuantitySelector(),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (_quantity == 0) {
                  _removeFromWishlist();
                } else {
                  _addOrUpdateWishlist();
                }
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      _quantity == 0
                          ? 'removed_from_cart'.tr(args: [widget.menu.name[context.locale.languageCode]!])
                          : 'updated_in_cart'.tr(args: [widget.menu.name[context.locale.languageCode]!]),
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.brown,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
              child: Text(_quantity == 0
                  ? 'remove_from_cart'
                  : _isAlreadyInWishlist
                  ? 'update_cart'
                  : 'add_to_cart')
                  .tr(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage() {
    return FutureBuilder<String>(
      future: _imageUrlFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          print('Error loading image: ${snapshot.error}');
          return const Center(child: Icon(Icons.error));
        } else {
          return snapshot.hasData
              ? Image.network(
            snapshot.data!,
            errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
          )
              : const Icon(Icons.error);
        }
      },
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

  Future<String> _getImageUrl(String imageUrl) async {
    try {
      if (imageUrl.startsWith('gs://')) {
        final ref = firebase_storage.FirebaseStorage.instance.refFromURL(imageUrl);
        final downloadUrl = await ref.getDownloadURL();
        print('Download URL: $downloadUrl');
        return downloadUrl;
      }
      return imageUrl;
    } catch (e) {
      print('Error getting image URL: $e');
      return '';
    }
  }
}
