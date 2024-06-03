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

class _MenuScreenState extends State<MenuScreen> with SingleTickerProviderStateMixin {
  bool _showHelpMessage = true;
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    // Trigger the fade-in animation when the screen is first displayed
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.forward();
    });
  }

  void _onLocaleChanged(BuildContext context) {
    setState(() {
      _showHelpMessage = true;
      _controller.reset();
      _controller.forward();
    });
  }

  void _toggleHelpMessage() {
    _controller.reverse().then((_) {
      setState(() {
        _showHelpMessage = false;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[50],
      body: LanguageButtonWrapper(
        supportedLocales: context.supportedLocales.map((locale) => locale.languageCode).toList(),
        onLocaleChanged: (context, newLocale) {
          context.setLocale(Locale(newLocale));
          _onLocaleChanged(context);
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
                    if (_showHelpMessage)
                      Positioned(
                        bottom: 80,
                        left: 16,
                        child: GestureDetector(
                          onTap: _toggleHelpMessage,
                          child: FadeTransition(
                            opacity: _fadeAnimation,
                            child: Material(
                              color: Colors.transparent,
                              child: Container(
                                constraints: BoxConstraints(maxWidth: 300),
                                padding: const EdgeInsets.all(12.0),
                                decoration: BoxDecoration(
                                  color: Colors.brown[200],
                                  borderRadius: BorderRadius.circular(8.0),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black26,
                                      spreadRadius: 1,
                                      blurRadius: 5,
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'menu_help_message'.tr(),
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    Icon(Icons.touch_app, color: Colors.white),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    Positioned(
                      bottom: 16,
                      right: 16,
                      child: FloatingActionButton(
                        backgroundColor: Colors.brown,
                        onPressed: () => _showCartModal(context, ref),
                        child: const Icon(Icons.shopping_cart, color: Colors.white),
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
      backgroundColor: Colors.brown[50], // Customize the background color of the modal
    );
  }
}
