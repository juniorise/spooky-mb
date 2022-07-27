import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spooky/flavor_config.dart';
import 'package:spooky/theme/m3/m3_color.dart';
import 'package:spooky/theme/m3/m3_text_theme.dart';
import 'package:spooky/utils/extensions/string_extension.dart';

class AppBuilder extends StatelessWidget {
  const AppBuilder({
    Key? key,
    this.child,
  }) : super(key: key);

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    SystemUiOverlayStyle overlay = fetchOverlayStyle(context);
    SystemChrome.setSystemUIOverlayStyle(overlay);
    if (FlavorConfig.isProduction()) {
      return buildWrapper(overlay);
    } else {
      return buildWrapperWithBanner(overlay, context);
    }
  }

  Widget buildWrapperWithBanner(
    SystemUiOverlayStyle overlay,
    BuildContext context,
  ) {
    return Stack(
      children: [
        buildWrapper(overlay),
        buildBanner(context),
      ],
    );
  }

  Widget buildBanner(BuildContext context) {
    return Positioned(
      bottom: 0,
      right: 0,
      child: CustomPaint(
        painter: BannerPainter(
          message: FlavorConfig.instance.flavor.name.capitalize,
          color: FlavorConfig.instance.color(context) ?? const Color(0xA0B71C1C),
          textStyle: M3TextTheme.of(context).caption!.copyWith(color: M3Color.of(context).onPrimary),
          location: BannerLocation.bottomEnd,
          textDirection: Directionality.of(context),
          layoutDirection: Directionality.of(context),
        ),
      ),
    );
  }

  Widget buildWrapper(SystemUiOverlayStyle overlay) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: overlay,
        child: child ?? const SizedBox.shrink(),
      ),
    );
  }

  SystemUiOverlayStyle fetchOverlayStyle(BuildContext context) {
    SystemUiOverlayStyle overlay = fetchOverlay(context);
    return overlay.copyWith(systemNavigationBarColor: Theme.of(context).appBarTheme.backgroundColor);
  }

  SystemUiOverlayStyle fetchOverlay(BuildContext context) {
    if (Theme.of(context).brightness == Brightness.dark) {
      return SystemUiOverlayStyle.dark;
    } else {
      return SystemUiOverlayStyle.light;
    }
  }
}
