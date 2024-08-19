// features/menu/menu_type_section.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../data/models/menu.dart';
import '../../common/image/image_helpers.dart';
import '../../common/shoplist/cart_logic.dart';
import 'menu_detail_screen.dart';

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
                      onTap: () {
                        // Navigate to the detail screen
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => MenuDetailScreen(menu: menu),
                        ));
                      },
                      contentPadding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ],
    );
  }
}
