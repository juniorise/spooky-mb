import 'package:flutter/material.dart';
import 'package:spooky/core/models/bottom_nav_item_list_model.dart';
import 'package:spooky/core/models/bottom_nav_item_model.dart';
import 'package:spooky/core/routes/sp_router.dart';
import 'package:spooky/core/storages/local_storages/bottom_nav_items_storage.dart';

class BottomNavItemsProvider extends ChangeNotifier {
  final BottomNavItemStorage storage = BottomNavItemStorage();
  BottomNavItemsProvider() {
    load();
  }

  List<SpRouter>? get tabs => _tabs;
  List<SpRouter>? _tabs;
  List<SpRouter>? _nonOptionalTabs;

  BottomNavItemListModel? get availableTabs => _availableTabs;
  BottomNavItemListModel? _availableTabs;

  Future<void> load() async {
    _tabs = [];

    BottomNavItemListModel result = await storage.getItems();
    for (BottomNavItemModel item in result.items ?? <BottomNavItemModel>[]) {
      if (item.selected == true && item.router != null) {
        _tabs!.add(item.router!);
      }
    }

    setTabs(result);
  }

  void setTabs(BottomNavItemListModel items) {
    // _tabs
    _availableTabs = items;
    _nonOptionalTabs = _tabs?.where((e) => e.datas.tab != null && e.datas.tab?.optinal == false).toList();
    notifyListeners();
  }

  Future<String?> set({
    required BottomNavItemListModel tabsList,
    required BuildContext context,
  }) async {
    List<SpRouter?> tabs = tabsList.items?.map((e) => e.router).toList() ?? [];
    for (SpRouter tab in _nonOptionalTabs ?? <SpRouter>[]) {
      if (!tabs.contains(tab)) {
        return "Must include default tabs";
      }
    }

    if (tabs.length < 2) {
      return "Must be greater than 2";
    }

    setTabs(tabsList);
    await storage.writeObject(tabsList);
    await load();

    return null;
  }
}
