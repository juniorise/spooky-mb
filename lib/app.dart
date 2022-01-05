import 'package:easy_localization/easy_localization.dart';
import 'package:spooky/app_builder.dart';
import 'package:spooky/theme/theme_config.dart';
import 'package:spooky/theme/theme_constant.dart';
import 'package:spooky/theme/m3/m3_text_theme.dart';
import 'package:spooky/utils/mixins/scaffold_messenger_mixin.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:flutter/material.dart';
import 'package:spooky/core/route/router.gr.dart' as r;

class App extends StatefulWidget {
  const App({
    Key? key,
  }) : super(key: key);

  static _AppState? of(BuildContext context) {
    return context.findAncestorStateOfType<_AppState>();
  }

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> with ScaffoldMessengerMixin {
  late r.Router _appRouter;
  late M3TextTheme textTheme;

  @override
  void initState() {
    _appRouter = r.Router(StackedService.navigatorKey);
    textTheme = ThemeConstant.textThemeM3;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      theme: ThemeConfig.light().themeData,
      darkTheme: ThemeConfig.dark().themeData,
      routerDelegate: _appRouter.delegate(),
      routeInformationParser: _appRouter.defaultRouteParser(),
      builder: (context, child) => AppBuilder(child: child),
    );
  }
}
