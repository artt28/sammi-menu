import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../common/language_change_botton/language_change_button.dart';
import '../../data/models/menu.dart';
import '../../data/models/menu_logic.dart';
import 'menu_type_section.dart';
import 'cart_modal.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({Key? key}) : super(key: key);

  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LanguageButtonWrapper(
        supportedLocales: context.supportedLocales.map((locale) => locale.languageCode).toList(),
        onLocaleChanged: (context, newLocale) {
          context.setLocale(Locale(newLocale));
        },
        child: Consumer(
          builder: (context, ref, child) {
            final menuListAsyncValue = ref.watch(menuListProvider);

            return menuListAsyncValue.when(
              data: (menus) {
                final groupedMenus = _groupMenusByType(menus);
                return Stack(
                  children: [
                    ListView.builder(
                      itemCount: groupedMenus.length,
                      itemBuilder: (context, index) {
                        final menuType = groupedMenus.keys.elementAt(index);
                        final menuList = groupedMenus[menuType]!;
                        return MenuTypeSection(menuType: menuType, menuList: menuList);
                      },
                    ),
                    Positioned(
                      bottom: 16,
                      right: 16,
                      child: FloatingActionButton(
                        onPressed: () => _showCartModal(context, ref),
                        child: const Icon(Icons.shopping_cart),
                      ),
                    ),
                  ],
                );
              },
              error: (error, stackTrace) => Center(child: Text('Error: $error')),
              loading: () => const Center(child: CircularProgressIndicator()),
            );
          },
        ),
      ),
    );
  }

  Map<String, List<Menu>> _groupMenusByType(List<Menu> menus) {
    final List<String> order = ['Beef', 'Pork', 'Sides', 'Meals'];
    final Map<String, List<Menu>> groupedMenus = {for (var type in order) type: []};

    for (var menu in menus) {
      if (groupedMenus.containsKey(menu.menuType)) {
        groupedMenus[menu.menuType]!.add(menu);
      }
    }

    return groupedMenus;
  }

  void _showCartModal(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      builder: (context) => CartModal(),
    );
  }
}
