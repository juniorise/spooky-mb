import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:spooky/ui/views/detail/detail_view.dart';
import 'package:spooky/ui/views/explore/explore_view.dart';
import 'package:spooky/ui/views/file_manager/file_manager_view.dart';
import 'package:spooky/ui/views/file_viewer/file_viewer_view.dart';
import 'package:spooky/ui/views/home/home_view.dart';
import 'package:spooky/ui/views/main/main_view.dart';
import 'package:spooky/ui/views/setting/setting_view.dart';

export 'router.gr.dart';
export 'package:auto_route/auto_route.dart';

@MaterialAutoRouter(
  routes: <AutoRoute>[
    MaterialRoute(
      page: FileViewerView,
      name: 'FileViewer',
    ),
    AutoRoute(
      name: 'Detail',
      page: DetailView,
    ),
    AutoRoute(
      name: "FileManager",
      page: FileManagerView,
    ),
    AutoRoute(
      name: "LicensePage",
      page: LicensePage,
    ),
    AutoRoute(
      name: 'Main',
      page: MainView,
      children: [
        AutoRoute(
          name: 'Home',
          page: HomeView,
        ),
        AutoRoute(
          name: 'Explore',
          page: ExploreView,
        ),
        AutoRoute(
          name: 'Setting',
          page: SettingView,
        ),
      ],
      initial: true,
    ),
  ],
)
class $AppRouter {}
