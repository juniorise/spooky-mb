import 'package:flutter/material.dart';
import 'package:spooky/core/routes/sp_router.dart';

class MainTabBarItem {
  final GlobalKey<NavigatorState> navigatorKey;
  final SpRouter router;
  final IconData inactiveIcon;
  final IconData activeIcon;
  final bool optinal;

  String get label {
    return router.datas.shortTitle ?? router.datas.title;
  }

  MainTabBarItem({
    required this.navigatorKey,
    required this.router,
    required this.inactiveIcon,
    required this.activeIcon,
    this.optinal = true,
  });
}

class MainTabBar {
  Map<SpRouter, MainTabBarItem> availableTabs = {};
  MainTabBar() {
    for (SpRouter route in SpRouter.values) {
      if (route.datas.tab != null) {
        availableTabs[route] = route.datas.tab!;
      }
    }
  }
}
