// ignore_for_file: prefer_function_declarations_over_variables

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';

import '../data/getstore/get_store_helper.dart';
import '../di/components/service_locator.dart';
import '../features/home/home.dart';
import '../features/info/info_screen.dart';
import '../features/menu/menu_screen.dart';
import '../features/welcome/welcome_screen.dart';
import 'fade_extension.dart';

GetStoreHelper getStoreHelper = getIt<GetStoreHelper>();

enum SGRoute {
  home,
  welCome,
  menu,
  login,
  register,
  forgotPassword,
  profile,
  editProfile,
  changePassword;

  String get route => '/${toString().replaceAll('SGRoute.', '')}';
  String get name => toString().replaceAll('SGRoute.', '');
}

@Singleton()
class SGGoRouter {
  final GoRouter goRoute = GoRouter(
    initialLocation: SGRoute.welCome.route,
    routes: <GoRoute>[
      GoRoute(
        path: SGRoute.welCome.route,
        builder: (BuildContext context, GoRouterState state) =>
            const WelcomePage(),
      ).fade(),
      GoRoute(
        path: SGRoute.menu.route,
        builder: (BuildContext context, GoRouterState state) =>
        const MenuScreen(),
      ).fade(),
    ],
  );
  GoRouter get getGoRouter => goRoute;
}

/// Example: Auth guard for Route Protection. GetStoreHelper is used to get token.
// ignore: unused_element
final String? Function(BuildContext context, GoRouterState state) _authGuard =
    (BuildContext context, GoRouterState state) {
  if (!(getStoreHelper.getToken() != null)) {
    return SGRoute.login.route;
  }
  return null;
};
