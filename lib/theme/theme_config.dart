import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:spooky/theme/m3/m3_color.dart';
import 'package:spooky/theme/theme_constant.dart';
import 'package:spooky/utils/constants/config_constant.dart';
import 'package:spooky/utils/helpers/app_helper.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';

class ThemeConfig {
  final bool isDarkMode;
  final String fontFamily;
  final FontWeight fontWeight;
  final ColorScheme? colorScheme;

  ThemeConfig(
    this.isDarkMode,
    this.fontFamily,
    this.fontWeight,
    this.colorScheme,
  );

  factory ThemeConfig.light() {
    return ThemeConfig.fromDarkMode(false);
  }

  factory ThemeConfig.dark() {
    return ThemeConfig.fromDarkMode(true);
  }

  ThemeConfig.fromDarkMode(this.isDarkMode)
      : fontFamily = ThemeConstant.defaultFontFamily,
        fontWeight = ThemeConstant.defaultFontWeight,
        colorScheme = null;

  ColorScheme get _light => M3Color.colorScheme(Brightness.light);
  ColorScheme get _dark => M3Color.colorScheme(Brightness.dark);

  ThemeData get themeData {
    ColorScheme colorScheme = this.colorScheme ?? (isDarkMode ? _dark : _light);
    TextTheme textTheme = buildTextTheme();

    ThemeData themeData = ThemeData(
      useMaterial3: true,
      applyElevationOverlayColor: true,
      primaryColor: colorScheme.primary,
      scaffoldBackgroundColor: colorScheme.background,
      colorScheme: colorScheme,
      canvasColor: colorScheme.readOnly.surface2,
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.readOnly.surface2,
        centerTitle: false,
        elevation: 0.0,
        foregroundColor: colorScheme.onSurface,
        iconTheme: IconThemeData(color: colorScheme.onSurface),
        titleTextStyle: textTheme.titleLarge?.copyWith(color: colorScheme.onSurface),
      ),
      cardTheme: CardTheme(
        clipBehavior: Clip.hardEdge,
        elevation: 0.0,
        margin: const EdgeInsets.symmetric(horizontal: ConfigConstant.margin2),
        color: colorScheme.readOnly.surface1,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        enableFeedback: true,
        elevation: 2.0,
        backgroundColor: colorScheme.secondaryContainer,
        foregroundColor: colorScheme.onSecondaryContainer,
        extendedPadding: const EdgeInsets.symmetric(horizontal: ConfigConstant.margin2 + 4),
      ),
      navigationBarTheme: NavigationBarThemeData(
        labelTextStyle: MaterialStateProperty.all(
          const TextStyle(overflow: TextOverflow.ellipsis),
        ),
      ),
      tabBarTheme: TabBarTheme(
        labelColor: colorScheme.primary,
        unselectedLabelColor: colorScheme.onSurface.withOpacity(0.75),
        labelStyle: textTheme.labelLarge,
        unselectedLabelStyle: textTheme.labelLarge,
        indicator: MaterialIndicator(color: colorScheme.primary, height: 3, strokeWidth: 2),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: const Color(0xFF323232),
        contentTextStyle: textTheme.bodyMedium?.copyWith(color: _light.background),
        actionTextColor: _dark.primary,
        shape: RoundedRectangleBorder(
          borderRadius: ConfigConstant.circlarRadius1,
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: ConfigConstant.circlarRadius1,
        ),
      ),
      switchTheme: buildSwitchTheme(colorScheme),
      radioTheme: buildRadioTheme(colorScheme),
      checkboxTheme: buildCheckBoxTheme(colorScheme),
      // splashColor: ThemeConstant.splashColor,
      indicatorColor: colorScheme.onPrimary,
      textTheme: textTheme,
      textButtonTheme: buildTextButtonStyle(colorScheme),
      cupertinoOverrideTheme: const CupertinoThemeData(
        textTheme: CupertinoTextThemeData(),
      ),
      listTileTheme: ListTileThemeData(
        iconColor: colorScheme.onBackground.withOpacity(0.5),
      ),
    );

    return withDefault(themeData);
  }

  static RadioThemeData buildRadioTheme(ColorScheme colorScheme) {
    return RadioThemeData(
      fillColor: MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
        if (states.contains(MaterialState.disabled)) return null;
        if (states.contains(MaterialState.selected)) return colorScheme.primary;
        return null;
      }),
    );
  }

  static CheckboxThemeData buildCheckBoxTheme(ColorScheme colorScheme) {
    return CheckboxThemeData(
      fillColor: MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
        if (states.contains(MaterialState.disabled)) return null;
        if (states.contains(MaterialState.selected)) return colorScheme.primary;
        return null;
      }),
      checkColor: MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
        if (states.contains(MaterialState.disabled)) return null;
        if (states.contains(MaterialState.selected)) return colorScheme.onPrimary;
        return null;
      }),
    );
  }

  static ThemeData withDefault(ThemeData themeData) {
    Color dividerColor = themeData.colorScheme.outline.withOpacity(0.2);
    return themeData.copyWith(
      // platform: TargetPlatform.android,
      dividerColor: dividerColor,
      dividerTheme: DividerThemeData(color: dividerColor, thickness: 0.5),
      cardTheme: themeData.cardTheme.copyWith(
        shape: RoundedRectangleBorder(
          side: BorderSide(color: dividerColor, width: 0.5),
          borderRadius: ConfigConstant.circlarRadius2,
        ),
      ),
      // selection toolbars
      cardColor: themeData.colorScheme.readOnly.surface5,
      splashFactory: buildSplash(themeData.platform),
    );
  }

  // InkSparkle.splashFactory,
  // InkRipple.splashFactory,
  // InkSplash.splashFactory,
  // NoSplash.splashFactory
  static InteractiveInkFeatureFactory buildSplash(TargetPlatform platform) {
    switch (platform) {
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        return InkSparkle.splashFactory;
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        return NoSplash.splashFactory;
    }
  }

  static bool isApple(TargetPlatform platform) {
    switch (platform) {
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        return false;
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        return true;
    }
  }

  static SwitchThemeData buildSwitchTheme(ColorScheme colorScheme) {
    return SwitchThemeData(
      thumbColor: MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
        if (states.contains(MaterialState.disabled)) return null;
        if (states.contains(MaterialState.selected)) return null;
        return null;
      }),
      trackColor: MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
        if (states.contains(MaterialState.disabled)) return null;
        if (states.contains(MaterialState.selected)) return null;
        return null;
      }),
    );
  }

  TextButtonThemeData buildTextButtonStyle(ColorScheme colorScheme) {
    return const TextButtonThemeData(
        // style: TextButton.styleFrom(
        //   onSurface: colorScheme.onSurface,
        //   primary: colorScheme.primary,
        //   backgroundColor: colorScheme.background,
        // ).copyWith(
        //   padding: MaterialStateProperty.all(const EdgeInsets.symmetric(horizontal: ConfigConstant.margin1)),
        //   overlayColor: MaterialStateProperty.all(ThemeConstant.splashColor),
        // backgroundColor: MaterialStateProperty.resolveWith(
        //   (states) {
        //     if (states.isNotEmpty) {
        //       switch (states.last) {
        //         case MaterialState.hovered:
        //           return colorScheme.onPrimary.withOpacity(0.1);
        //         case MaterialState.focused:
        //           return colorScheme.onPrimary.withOpacity(0.1);
        //         case MaterialState.pressed:
        //           return colorScheme.onPrimary.withOpacity(0.1);
        //         case MaterialState.dragged:
        //           return colorScheme.onPrimary.withOpacity(0.1);
        //         case MaterialState.selected:
        //           return colorScheme.onPrimary.withOpacity(0.1);
        //         case MaterialState.scrolledUnder:
        //           return colorScheme.onPrimary.withOpacity(0.1);
        //         case MaterialState.disabled:
        //           return colorScheme.onPrimary.withOpacity(0.1);
        //         case MaterialState.error:
        //           return colorScheme.onPrimary.withOpacity(0.1);
        //       }
        //     }
        //     return colorScheme.primary;
        //   },
        // ),
        // ),
        );
  }

  TextTheme buildTextTheme() {
    return GoogleFonts.getTextTheme(
      fontFamily,
      _defaultTextTheme,
    );
  }

  TextTheme get _defaultTextTheme {
    return TextTheme(
      displayLarge: TextStyle(
        fontWeight: AppHelper.fontWeightGetter(FontWeight.w400, fontWeight),
        fontSize: 57,
        letterSpacing: -0.25,
      ),
      displayMedium: TextStyle(
        fontWeight: AppHelper.fontWeightGetter(FontWeight.w400, fontWeight),
        fontSize: 45,
      ),
      displaySmall: TextStyle(
        fontWeight: AppHelper.fontWeightGetter(FontWeight.w400, fontWeight),
        fontSize: 36,
        letterSpacing: 0.5,
      ),
      headlineLarge: TextStyle(
        fontWeight: AppHelper.fontWeightGetter(FontWeight.w400, fontWeight),
        fontSize: 32,
      ),
      headlineMedium: TextStyle(
        fontWeight: AppHelper.fontWeightGetter(FontWeight.w400, fontWeight),
        fontSize: 28,
      ),
      headlineSmall: TextStyle(
        fontWeight: AppHelper.fontWeightGetter(FontWeight.w400, fontWeight),
        fontSize: 24,
      ),
      titleLarge: TextStyle(
        fontWeight: AppHelper.fontWeightGetter(FontWeight.w400, fontWeight),
        fontSize: 22,
      ),
      titleMedium: TextStyle(
        fontWeight: AppHelper.fontWeightGetter(FontWeight.w400, fontWeight),
        fontSize: 16,
        letterSpacing: 0.1,
      ),
      titleSmall: TextStyle(
        fontWeight: AppHelper.fontWeightGetter(FontWeight.w500, fontWeight),
        fontSize: 14,
        letterSpacing: 0.1,
      ),
      labelLarge: TextStyle(
        fontWeight: AppHelper.fontWeightGetter(FontWeight.w500, fontWeight),
        fontSize: 14,
        letterSpacing: 0.1,
      ),
      labelMedium: TextStyle(
        fontWeight: AppHelper.fontWeightGetter(FontWeight.w500, fontWeight),
        fontSize: 12,
        letterSpacing: 0.5,
      ),
      labelSmall: TextStyle(
        fontWeight: AppHelper.fontWeightGetter(FontWeight.w500, fontWeight),
        fontSize: 11,
        letterSpacing: 0.5,
      ),
      bodyLarge: TextStyle(
        fontWeight: AppHelper.fontWeightGetter(FontWeight.w400, fontWeight),
        fontSize: 16,
        letterSpacing: 0.5,
      ),
      bodyMedium: TextStyle(
        fontWeight: AppHelper.fontWeightGetter(FontWeight.w400, fontWeight),
        fontSize: 14,
        letterSpacing: 0.25,
      ),
      bodySmall: TextStyle(
        fontWeight: AppHelper.fontWeightGetter(FontWeight.w400, fontWeight),
        fontSize: 12,
        letterSpacing: 0.4,
      ),
    );
  }
}
