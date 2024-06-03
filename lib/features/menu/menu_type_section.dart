import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../data/models/menu.dart';
import '../../common/image/image_helpers.dart';
import '../../common/shoplist/cart_logic.dart';

class MenuTypeSection extends ConsumerStatefulWidget {
  final String menuType;
  final List<Menu> menuList;

  const MenuTypeSection({required this.menuType, required this.menuList});

  @override
  _MenuTypeSectionState createState() => _MenuTypeSectionState();
}

class _MenuTypeSectionState extends ConsumerState<MenuTypeSection> {
  Map<Menu, String> menuImages = {};
  String? typeImage;

  @override
  void initState() {
    super.initState();
    for (final menu in widget.menuList) {
      _loadMenuImageUrl(menu);
    }
    _loadTypeImageUrl(widget.menuType);
  }

  void _loadMenuImageUrl(Menu menu) async {
    final imageUrl = await getImageUrl(menu.imageUrl);
    setState(() {
      menuImages[menu] = imageUrl;
    });
  }

  void _loadTypeImageUrl(String typeName) async {
    final imageUrl = await getTypeImageUrl(typeName);
    setState(() {
      typeImage = imageUrl;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (typeImage != null)
          CachedNetworkImage(
            imageUrl: typeImage!,
            width: double.infinity,
            height: 300,
            fit: BoxFit.cover,
            errorWidget: (context, url, error) => Container(
              width: double.infinity,
              height: 300,
              color: Colors.grey,
            ),
          )
        else
          Container(
            width: double.infinity,
            height: 300,
            color: Colors.grey,
          ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            widget.menuType,
            style: Theme.of(context).textTheme.headlineMedium!.copyWith(
              color: Colors.brown[800],
              fontWeight: FontWeight.bold,
            ),
          ).tr(),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: widget.menuList.length,
          itemBuilder: (context, index) {
            final menu = widget.menuList[index];
            return Consumer(
              builder: (context, ref, child) {
                final cartItems = ref.watch(cartProvider);
                final cartItem = cartItems.firstWhere(
                      (item) => item.menu == menu,
                  orElse: () => CartItem(menu: menu, quantity: 0),
                );

                return Column(
                  children: [
                    ListTile(
                      leading: menuImages[menu] != null
                          ? CachedNetworkImage(
                        imageUrl: menuImages[menu]!,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                        errorWidget: (context, url, error) => const Icon(Icons.error),
                      )
                          : const CircularProgressIndicator(),
                      title: Text(
                        menu.name[context.locale.languageCode]!,
                        style: TextStyle(color: Colors.brown[800]),
                      ),
                      subtitle: Text(
                        menu.description[context.locale.languageCode]!,
                        style: TextStyle(color: Colors.brown[600]),
                      ),
                      trailing: Text(
                        '₩${menu.price}',
                        style: TextStyle(color: Colors.brown[800], fontWeight: FontWeight.bold),
                      ),
                      onTap: () => _toggleQuantityControls(menu, ref),
                      contentPadding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                    ),
                    if (cartItem.quantity > 0) _buildQuantityControls(menu, ref, cartItem.quantity),
                  ],
                );
              },
            );
          },
        ),
      ],
    );
  }

  void _toggleQuantityControls(Menu menu, WidgetRef ref) {
    final cartItems = ref.read(cartProvider);
    final cartItem = cartItems.firstWhere(
          (item) => item.menu == menu,
      orElse: () => CartItem(menu: menu, quantity: 0),
    );
    if (cartItem.quantity == 0) {
      ref.read(cartProvider.notifier).addToCart(menu, 1);
    }
  }

  Widget _buildQuantityControls(Menu menu, WidgetRef ref, int quantity) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton(
          icon: const Icon(Icons.remove),
          onPressed: () {
            if (quantity > 0) {
              ref.read(cartProvider.notifier).addToCart(menu, -1);
            }
          },
        ),
        Text(
          quantity.toString(),
          style: TextStyle(color: Colors.brown[800], fontWeight: FontWeight.bold),
        ),
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: () {
            ref.read(cartProvider.notifier).addToCart(menu, 1);
          },
        ),
      ],
    );
  }
}
