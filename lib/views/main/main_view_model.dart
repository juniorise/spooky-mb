import 'package:flutter/material.dart';
import 'package:spooky/core/db/models/story_db_model.dart';
import 'package:spooky/core/routes/sp_router.dart';
import 'package:spooky/core/security/security_service.dart';
import 'package:spooky/core/types/detail_view_flow_type.dart';
import 'package:spooky/core/types/list_layout_type.dart';
import 'package:spooky/widgets/sp_list_layout_builder.dart';
import 'package:spooky/utils/mixins/schedule_mixin.dart';
import 'package:spooky/utils/util_widgets/sp_date_picker.dart';
import 'package:spooky/core/base/base_view_model.dart';

class MainViewModel extends BaseViewModel with ScheduleMixin {
  late final ValueNotifier<bool> shouldShowBottomNavNotifier;
  late final ValueNotifier<double?> bottomNavigationHeight;

  final BuildContext context;
  final SecurityService service = SecurityService();

  Map<SpRouter, ScrollController> scrollControllers = {};
  ScrollController? get currentScrollController {
    if (scrollControllers.containsKey(activeRouter)) {
      return scrollControllers[activeRouter];
    }
    return null;
  }

  void setScrollController({
    required int index,
    required ScrollController controller,
  }) {
    scrollControllers[activeRouter] = controller;
  }

  MainViewModel(this.context) {
    shouldShowBottomNavNotifier = ValueNotifier(true);
    bottomNavigationHeight = ValueNotifier(null);
    DateTime date = DateTime.now();
    year = date.year;
    month = date.month;
    day = date.day;
  }

  @override
  void dispose() {
    shouldShowBottomNavNotifier.dispose();
    bottomNavigationHeight.dispose();
    super.dispose();
  }

  SpRouter activeRouter = SpRouter.home;
  void setActiveRouter(SpRouter router) {
    if (activeRouter != router) {
      activeRouter = router;
      notifyListeners();
    }
  }

  void Function()? storyListReloader;

  late int year;
  late int month;
  late int day;

  DateTime get date {
    final now = DateTime.now();
    return DateTime(
      year,
      month,
      day,
      now.hour,
      now.minute,
      now.second,
      now.millisecond,
      now.microsecond,
    );
  }

  void onTabChange(int month) {
    this.month = month;
  }

  void setShouldShowBottomNav(bool value) {
    shouldShowBottomNavNotifier.value = value;
  }

  Future<void> createStory(BuildContext context) async {
    ListLayoutType? layout = await SpListLayoutBuilder.get();

    DateTime? date;
    switch (layout) {
      case ListLayoutType.single:
        date = await SpDatePicker.showMonthDayPicker(context, this.date);
        break;
      case ListLayoutType.tabs:
        date = await SpDatePicker.showDayPicker(context, this.date);
        break;
    }

    if (date != null) onConfirm(date, context);
  }

  void onConfirm(DateTime date, BuildContext context) {
    DetailArgs args = DetailArgs(initialStory: StoryDbModel.fromDate(date), intialFlow: DetailViewFlowType.create);
    Navigator.of(context).pushNamed(SpRouter.detail.path, arguments: args).then((value) {
      if (storyListReloader != null && value != null) storyListReloader!();
    });
  }
}
