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

    // 고기 메뉴가 1인당 1개 이상인지 확인
    final meatItemsCount = cartItems
        .where((item) =>
            item.menu.menuType == 'Beef' || item.menu.menuType == 'Pork')
        .fold<int>(0, (sum, item) => sum + item.quantity);

    // 점심시간을 제외하고, 식사류는 고기를 주문한 경우에만 가능
    final now = DateTime.now();
    final isLunchTime = now.hour >= 11 && now.hour < 14;
    final hasMealsWithoutMeat = !isLunchTime &&
        cartItems.any((item) => item.menu.menuType == 'Meals') &&
        meatItemsCount == 0;

    return Container(
      height: MediaQuery.of(context).size.height * 0.75, // 모달의 높이를 고정
      color: Colors.brown[50],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Cart'.tr(),
              style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.brown[800]),
            ),
            const SizedBox(height: 12),
            Text(
              'order_warning_message'.tr(),
              style: TextStyle(
                  color: Colors.brown[600],
                  fontWeight: FontWeight.w500,
                  fontSize: 14),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            if (cartItems.isEmpty)
              Text('Your cart is empty',
                      style: TextStyle(fontSize: 18, color: Colors.brown[400]))
                  .tr()
            else
              Expanded(
                child: ListView.separated(
                  itemCount: cartItems.length,
                  separatorBuilder: (context, index) =>
                      Divider(color: Colors.brown[200]),
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
                            return _buildCartItem(context, cartItem, localeName,
                                koreanName, null, isKoreanLocale,
                                isLoading: true);
                          } else if (snapshot.hasError ||
                              !snapshot.hasData ||
                              snapshot.data!.isEmpty) {
                            _failedImages.add(cartItem.menu);
                            return _buildCartItem(context, cartItem, localeName,
                                koreanName, null, isKoreanLocale);
                          } else {
                            _imageCache[cartItem.menu] = snapshot.data!;
                            return _buildCartItem(context, cartItem, localeName,
                                koreanName, snapshot.data!, isKoreanLocale);
                          }
                        },
                      );
                    }
                  },
                ),
              ),
            const SizedBox(height: 20),
            // 항상 공지사항을 표시
            Text(
              'meat_order_notice'.tr(),
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'dinner_meal_notice'.tr(),
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.brown[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total'.tr(),
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.brown[800]),
                  ),
                  Text(
                    '₩$total',
                    style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.green),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    ref.read(cartProvider.notifier).clearCart();
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[700],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: Icon(Icons.delete),
                  label:
                      Text('Clear Cart'.tr(), style: TextStyle(fontSize: 16)),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    _showOrderSummary(context, cartItems);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[700],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: Icon(Icons.receipt),
                  label:
                      Text('print_order'.tr(), style: TextStyle(fontSize: 16)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showOrderSummary(BuildContext context, List<CartItem> cartItems) {
    final orderSummary = cartItems.map((item) {
      final name = item.menu.name['ko']!;
      final quantity = item.quantity;
      return '$name x $quantity';
    }).join('\n');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('주문서'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(orderSummary),
              const SizedBox(height: 20),
              Text(
                'show_to_staff'.tr(),
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('닫기'),
            ),
          ],
        );
      },
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          isLoading
              ? const CircularProgressIndicator()
              : imageUrl != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: CachedNetworkImage(
                        imageUrl: imageUrl,
                        width: 70,
                        height: 70,
                        fit: BoxFit.cover,
                        errorWidget: (context, url, error) {
                          print('Error loading image: $url, $error');
                          return const Icon(Icons.error);
                        },
                      ),
                    )
                  : const Icon(Icons.error, size: 70),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildItemTitle(localeName, koreanName, isKoreanLocale),
                const SizedBox(height: 4),
                Text(
                  '₩${cartItem.menu.price} x ${cartItem.quantity}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _buildQuantityButton(Icons.remove, () {
                      if (cartItem.quantity > 1) {
                        ref
                            .read(cartProvider.notifier)
                            .updateQuantity(cartItem, cartItem.quantity - 1);
                      } else {
                        ref
                            .read(cartProvider.notifier)
                            .removeFromCart(cartItem);
                      }
                    }),
                    const SizedBox(width: 12),
                    Text(
                      cartItem.quantity.toString(),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.brown,
                      ),
                    ),
                    const SizedBox(width: 12),
                    _buildQuantityButton(Icons.add, () {
                      ref
                          .read(cartProvider.notifier)
                          .updateQuantity(cartItem, cartItem.quantity + 1);
                    }),
                  ],
                ),
              ],
            ),
          ),
          Text(
            '₩${cartItem.menu.price * cartItem.quantity}',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuantityButton(IconData icon, VoidCallback onPressed) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.brown[200],
        borderRadius: BorderRadius.circular(4),
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.white, size: 18),
        onPressed: onPressed,
        padding: EdgeInsets.all(4),
        constraints: BoxConstraints(minWidth: 30, minHeight: 30),
      ),
    );
  }

  Widget _buildItemTitle(
      String localeName, String koreanName, bool isKoreanLocale) {
    return isKoreanLocale
        ? Text(localeName,
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.brown[800]))
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(localeName,
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.brown[800])),
              const SizedBox(height: 2),
              Text(
                koreanName,
                style: TextStyle(
                  fontSize: 14,
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
