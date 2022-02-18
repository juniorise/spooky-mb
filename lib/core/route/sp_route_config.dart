import 'package:flutter/material.dart';
import 'package:spooky/core/models/story_model.dart';
import 'package:spooky/core/route/router.gr.dart';
import 'package:spooky/core/route/setting/animated_route_setting.dart';
import 'package:spooky/core/route/setting/base_route_setting.dart';
import 'package:spooky/core/route/setting/default_route_setting.dart';
import 'package:spooky/theme/m3/m3_color.dart';
import 'package:spooky/ui/views/archive/archive_view.dart';
import 'package:spooky/ui/views/changes_history/changes_history_view.dart';
import 'package:spooky/ui/views/content_reader/content_reader_view.dart';
import 'package:spooky/ui/views/detail/detail_view.dart';
import 'package:spooky/ui/views/developer_mode/developer_mode_view.dart';
import 'package:spooky/ui/views/explore/explore_view.dart';
import 'package:spooky/ui/views/home/home_view.dart';
import 'package:spooky/ui/views/init_pick_color/init_pick_color_view.dart';
import 'package:spooky/ui/views/main/main_view.dart';
import 'package:spooky/ui/views/manage_pages/manage_pages_view.dart';
import 'package:spooky/ui/views/nickname_creator/nickname_creator_view.dart';
import 'package:spooky/ui/views/setting/setting_view.dart';
import 'package:spooky/ui/views/theme_setting/theme_setting_view.dart';

export 'router.gr.dart';

class SpRouteConfig {
  final RouteSettings? settings;
  final BuildContext context;

  SpRouteConfig({
    required this.context,
    this.settings,
  });

  static const String themeSetting = '/theme-setting';
  static const String managePages = '/manage-pages';
  static const String archive = '/archive';
  static const String contentReader = '/content-reader';
  static const String changesHistory = '/changes-history';
  static const String detail = '/detail';
  static const String main = '/main';
  static const String home = '/home';
  static const String explore = '/explore';
  static const String setting = '/setting';
  static const String appStarter = 'landing/app-starter';
  static const String initPickColor = '/landing/init-pick-color';
  static const String nicknameCreator = '/landing/nickname-creator';
  static const String developerModeView = '/developer-mode-view';
  static const String notFound = '/not-found';

  bool hasRoute(String name) => routes.containsKey(name);

  Route<dynamic> generate() {
    String? name = settings?.name;
    if (name == null || !hasRoute(name)) name = notFound;

    BaseRouteSetting? setting = routes[name];
    Route? route = setting?.toRoute(context, settings);

    if (route != null) {
      return route;
    } else {
      return MaterialPageRoute(
        fullscreenDialog: true,
        settings: settings?.copyWith(arguments: routes[name]!),
        builder: (context) {
          return buildNotFound();
        },
      );
    }
  }

  Map<String, BaseRouteSetting> get routes {
    return {
      themeSetting: DefaultRouteSetting(
        title: "Theme Setting",
        canSwap: false,
        fullscreenDialog: false,
        route: (context) => ThemeSettingView(),
      ),
      managePages: DefaultRouteSetting(
        title: "Manage Pages",
        canSwap: false,
        fullscreenDialog: false,
        route: (context) {
          Object? arguments = settings?.arguments;
          if (arguments is ManagePagesArgs) return ManagePagesView(content: arguments.content);
          return buildNotFound();
        },
      ),
      archive: DefaultRouteSetting(
        title: "Archive",
        canSwap: false,
        fullscreenDialog: false,
        route: (context) => ArchiveView(),
      ),
      contentReader: DefaultRouteSetting(
        title: "Content Reader",
        canSwap: false,
        fullscreenDialog: false,
        route: (context) {
          Object? arguments = settings?.arguments;
          if (arguments is ContentReaderArgs) return ContentReaderView(content: arguments.content);
          return buildNotFound();
        },
      ),
      changesHistory: DefaultRouteSetting(
        title: "Changes History",
        canSwap: false,
        fullscreenDialog: false,
        route: (context) {
          Object? arguments = settings?.arguments;
          if (arguments is ChangesHistoryArgs) {
            return ChangesHistoryView(
              story: arguments.story,
              onRestorePressed: arguments.onRestorePressed,
              onDeletePressed: arguments.onDeletePressed,
            );
          }
          return buildNotFound();
        },
      ),
      detail: DefaultRouteSetting<StoryModel>(
        title: "Detail",
        canSwap: false,
        fullscreenDialog: false,
        route: (context) {
          Object? arguments = settings?.arguments;
          if (arguments is DetailArgs) {
            return DetailView(
              initialStory: arguments.initialStory,
              intialFlow: arguments.intialFlow,
            );
          }
          return buildNotFound();
        },
      ),
      "/": DefaultRouteSetting(
        title: "Main",
        canSwap: false,
        fullscreenDialog: false,
        route: (context) => MainView(),
      ),
      main: DefaultRouteSetting(
        title: "Main",
        canSwap: false,
        fullscreenDialog: false,
        route: (context) => MainView(),
      ),
      home: DefaultRouteSetting(
        title: "Home",
        canSwap: false,
        fullscreenDialog: false,
        route: (context) {
          Object? arguments = settings?.arguments;
          if (arguments is HomeArgs) {
            return HomeView(
              onTabChange: arguments.onTabChange,
              onYearChange: arguments.onYearChange,
              onListReloaderReady: arguments.onListReloaderReady,
            );
          }
          return buildNotFound();
        },
      ),
      explore: DefaultRouteSetting(
        title: "Explore",
        canSwap: false,
        fullscreenDialog: false,
        route: (context) => ExploreView(),
      ),
      setting: DefaultRouteSetting(
        title: "Setting",
        canSwap: false,
        fullscreenDialog: false,
        route: (context) => SettingView(),
      ),
      initPickColor: AnimatedRouteSetting(
        title: "Pick Color",
        fullscreenDialog: true,
        fillColor: M3Color.of(context).background,
        route: (context) => InitPickColorView(),
      ),
      nicknameCreator: AnimatedRouteSetting(
        title: "Nickname Creator",
        fullscreenDialog: true,
        fillColor: M3Color.of(context).background,
        route: (context) => NicknameCreatorView(),
      ),
      developerModeView: DefaultRouteSetting(
        title: "Developer Mode",
        canSwap: false,
        fullscreenDialog: false,
        route: (context) => DeveloperModeView(),
      ),
      notFound: DefaultRouteSetting(
        title: "Not Found",
        canSwap: false,
        fullscreenDialog: false,
        route: (context) => buildNotFound(),
      ),
    };
  }

  static Widget buildNotFound() {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Text("Not found"),
      ),
    );
  }
}
