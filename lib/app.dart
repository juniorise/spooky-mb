import 'package:easy_localization/easy_localization.dart';
import 'package:spooky/app_builder.dart';
import 'package:spooky/core/route/sp_route_config.dart';
import 'package:spooky/core/storages/color_storage.dart';
import 'package:spooky/theme/m3/m3_color.dart';
import 'package:spooky/theme/theme_config.dart';
import 'package:spooky/theme/theme_constant.dart';
import 'package:spooky/utils/mixins/scaffold_messenger_mixin.dart';
import 'package:flutter/material.dart';

class App extends StatefulWidget {
  const App({
    Key? key,
    required this.themeMode,
  }) : super(key: key);

  final ThemeMode themeMode;
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static _AppState? of(BuildContext context) {
    return context.findAncestorStateOfType<_AppState>();
  }

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> with ScaffoldMessengerMixin {
  late TextTheme textTheme;

  @override
  void initState() {
    textTheme = ThemeConstant.defaultTextTheme;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: App.navigatorKey,
      themeMode: widget.themeMode,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      theme: ThemeConfig.light().themeData,
      darkTheme: ThemeConfig.dark().themeData,
      builder: (context, child) => AppBuilder(child: child),
      onGenerateRoute: (settings) => SpRouteConfig(context: context, settings: settings).generate(),
    );
  }

  Future<void> updateColor(Color? color) async {
    await ColorStorage().write(color?.value);
    await M3Color.initialize();
    setState(() {});
  }
}
