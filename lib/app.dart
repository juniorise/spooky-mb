import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:navigation_history_observer/navigation_history_observer.dart';
import 'package:provider/provider.dart';
import 'package:spooky/core/routes/sp_router.dart';
import 'package:spooky/providers/theme_provider.dart';
import 'package:spooky/utils/util_widgets/app_builder.dart';
import 'package:spooky/core/routes/sp_route_config.dart';
import 'package:spooky/main.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App({
    Key? key,
  }) : super(key: key);

  static final RouteObserver<ModalRoute> storyQueryListObserver = RouteObserver<ModalRoute>();
  static final RouteObserver<ModalRoute> homeViewModelObserver = RouteObserver<ModalRoute>();
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>(debugLabel: "App");
  static final FirebaseAnalyticsObserver _analyticsObserver =
      FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance);

  @override
  Widget build(BuildContext context) {
    ThemeProvider provider = Provider.of<ThemeProvider>(context, listen: true);
    return MaterialApp(
      navigatorKey: App.navigatorKey,
      themeMode: provider.themeMode,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      initialRoute: Global.instance.appInitiailized ? SpRouter.main.path : SpRouter.appStarter.path,
      theme: provider.lightTheme,
      darkTheme: provider.darkTheme,
      debugShowCheckedModeBanner: false,
      debugShowMaterialGrid: false,
      builder: (context, child) => AppBuilder(child: child),
      onGenerateRoute: (settings) => SpRouteConfig(context: context, settings: settings).generate(),
      navigatorObservers: [
        storyQueryListObserver,
        homeViewModelObserver,
        _analyticsObserver,
        NavigationHistoryObserver(),
      ],
    );
  }
}
