import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:spooky/core/notifications/app_notification.dart';
import 'package:spooky/core/services/initial_tab_service.dart';
import 'package:spooky/initial_theme.dart';
import 'package:spooky/utils/constants/app_constant.dart';
import 'package:flutter/material.dart';
import 'package:spooky/utils/helpers/file_helper.dart';
import 'package:timezone/data/latest.dart' as tz;

bool flutterTest = Platform.environment.containsKey('FLUTTER_TEST');

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  tz.initializeTimeZones();
  FileHelper.initialFile();

  await AppNotification().initialize();
  await InitialStoryTabService.initialize();

  runApp(
    EasyLocalization(
      supportedLocales: AppConstant.supportedLocales,
      fallbackLocale: AppConstant.fallbackLocale,
      path: 'assets/translations',
      child: const InitialTheme(),
    ),
  );
}
