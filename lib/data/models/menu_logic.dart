import '../repository/menu.dart';
import 'menu.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'menu_logic.g.dart'; // Add this line

// Create a provider for the MenuService
final menuServiceProvider = Provider<MenuService>((ref) => MenuService());

// Provider to fetch and store the menu list
@riverpod
class MenuList extends _$MenuList {
  @override
  Future<List<Menu>> build() async {
    final menuService = ref.watch(menuServiceProvider);
    // Get the initial list of menus
    final snapshot = await menuService.getMenus().first;
    return snapshot;
  }

  // Optional: Method to refresh the menu list
  Future<void> refreshMenuList() async {
    state = await AsyncValue.guard(build);
  }
}
