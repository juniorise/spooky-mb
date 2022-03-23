import 'package:spooky/core/models/bottom_nav_item_list_model.dart';
import 'package:spooky/core/models/bottom_nav_item_model.dart';
import 'package:spooky/core/routes/sp_router.dart';
import 'package:spooky/core/storages/base_storages/base_object_storage.dart';

class BottomNavItemStorage extends BaseObjectStorage<BottomNavItemListModel> {
  List<SpRouter> defaultTabs = [SpRouter.home, SpRouter.setting];

  @override
  BottomNavItemListModel deserialize(Map<String, dynamic> json) {
    return BottomNavItemListModel.fromJson(json);
  }

  @override
  Map<String, dynamic> serialize(BottomNavItemListModel object) {
    return object.toJson();
  }

  Future<BottomNavItemListModel> getItems() async {
    BottomNavItemListModel? listModel = await super.readObject();
    List<BottomNavItemModel> validatedItems = [];

    for (final item in listModel?.items ?? <BottomNavItemModel>[]) {
      if (item.router != null) {
        validatedItems.add(item);
      }
    }

    List<SpRouter?> validatedRouters = validatedItems.map((e) {
      return e.router;
    }).toList();

    // make sure other index available
    for (SpRouter route in SpRouter.values) {
      if (route.tab != null && !validatedRouters.contains(route)) {
        validatedItems.add(
          BottomNavItemModel(
            router: route,
            selected: route.tab?.optinal == false,
          ),
        );
      }
    }

    return BottomNavItemListModel(validatedItems);
  }
}
