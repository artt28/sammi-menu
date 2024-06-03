import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:http/http.dart' as http;

import '../../common/shoplist/cart_logic.dart';
import '../../common/image/image_helpers.dart';
import '../../data/models/menu.dart';

class CartModal extends ConsumerStatefulWidget {
  @override
  _CartModalState createState() => _CartModalState();
}

class _CartModalState extends ConsumerState<CartModal> {
  final Map<Menu, String> _imageCache = {};
  final Set<Menu> _failedImages = {};

  @override
  Widget build(BuildContext context) {
    final cartItems = ref.watch(cartProvider);
    final total = cartItems.fold<int>(
        0, (sum, item) => sum + item.menu.price * item.quantity);
    final isKoreanLocale = context.locale.languageCode == 'ko';

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Cart'.tr(),
            style: const TextStyle(
                fontSize: 24, fontWeight: FontWeight.bold, color: Colors.brown),
          ),
          const SizedBox(height: 16),
          Text(
            'order_warning_message'.tr(),
            style: const TextStyle(
                color: Colors.brown, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ).tr(),
          const SizedBox(height: 16),
          if (cartItems.isEmpty)
            const Text('Your cart is empty').tr()
          else
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: cartItems.length,
                      itemBuilder: (context, index) {
                        final cartItem = cartItems[index];
                        final localeName =
                        cartItem.menu.name[context.locale.languageCode]!;
                        final koreanName = cartItem.menu.name['ko']!;
                        final cachedImageUrl = _imageCache[cartItem.menu];

                        if (_failedImages.contains(cartItem.menu)) {
                          return _buildCartItem(context, cartItem, localeName,
                              koreanName, null, isKoreanLocale);
                        }

                        if (cachedImageUrl != null) {
                          return _buildCartItem(context, cartItem, localeName,
                              koreanName, cachedImageUrl, isKoreanLocale);
                        } else {
                          final imageUrlFuture =
                          getImageUrl(cartItem.menu.imageUrl);
                          return FutureBuilder<String>(
                            future: imageUrlFuture,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return _buildCartItem(context, cartItem,
                                    localeName, koreanName, null, isKoreanLocale,
                                    isLoading: true);
                              } else if (snapshot.hasError ||
                                  !snapshot.hasData ||
                                  snapshot.data!.isEmpty) {
                                _failedImages.add(cartItem.menu);
                                return _buildCartItem(context, cartItem,
                                    localeName, koreanName, null, isKoreanLocale);
                              } else {
                                _imageCache[cartItem.menu] = snapshot.data!;
                                return _buildCartItem(
                                    context,
                                    cartItem,
                                    localeName,
                                    koreanName,
                                    snapshot.data!,
                                    isKoreanLocale);
                              }
                            },
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 10,
                            spreadRadius: 2,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: RichText(
                        text: TextSpan(
                          text: 'Total'.tr() + ': ', // Localized part
                          style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.brown),
                          children: [
                            TextSpan(
                              text: '₩$total', // Non-localized part
                              style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blueAccent),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () {
                        ref.read(cartProvider.notifier).clearCart();
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.brown,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 32, vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Clear Cart').tr(),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCartItem(
      BuildContext context,
      CartItem cartItem,
      String localeName,
      String koreanName,
      String? imageUrl,
      bool isKoreanLocale,
      {bool isLoading = false}) {
    return ListTile(
      leading: isLoading
          ? const CircularProgressIndicator()
          : imageUrl != null
          ? CachedNetworkImage(
        imageUrl: imageUrl,
        width: 50,
        height: 50,
        fit: BoxFit.cover,
        errorWidget: (context, url, error) {
          print('Error loading image: $url, $error');
          return const Icon(Icons.error);
        },
      )
          : const Icon(Icons.error),
      title: _buildItemTitle(localeName, koreanName, isKoreanLocale),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '₩${cartItem.menu.price * cartItem.quantity}',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.blueAccent,
            ),
          ),
          Text(
            '₩${cartItem.menu.price} x ${cartItem.quantity}',
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
        ],
      ),
      subtitle: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.remove, color: Colors.brown),
            onPressed: () {
              if (cartItem.quantity > 1) {
                ref.read(cartProvider.notifier).updateQuantity(cartItem, cartItem.quantity - 1);
              } else {
                ref.read(cartProvider.notifier).removeFromCart(cartItem);
              }
            },
          ),
          Text(
            cartItem.quantity.toString(),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.brown,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.add, color: Colors.brown),
            onPressed: () {
              ref.read(cartProvider.notifier).updateQuantity(cartItem, cartItem.quantity + 1);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildItemTitle(String localeName, String koreanName, bool isKoreanLocale) {
    return isKoreanLocale
        ? Text(localeName, style: const TextStyle(color: Colors.brown))
        : Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(localeName, style: const TextStyle(color: Colors.brown)),
        Text(
          koreanName,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Future<void> checkImageUrl(String url) async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      print('Image URL is valid: $url');
    } else {
      print('Image URL is invalid: $url, Status code: ${response.statusCode}');
    }
  }
}
