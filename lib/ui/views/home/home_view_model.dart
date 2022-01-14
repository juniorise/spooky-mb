import 'dart:io';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:spooky/core/file_managers/story_file_manager.dart';
import 'package:spooky/core/services/initial_tab_service.dart';
import 'package:spooky/utils/constants/app_constant.dart';
import 'package:spooky/utils/widgets/sp_date_picker.dart';
import 'package:stacked/stacked.dart';

class HomeViewModel extends IndexTrackingViewModel {
  late int year;
  late int month;

  final StoryFileManager storyFileManager = StoryFileManager();

  final void Function(int index) onTabChange;
  final void Function(int year) onYearChange;
  late final void Function(void Function()) onListReloaderReady;
  HomeViewModel(this.onTabChange, this.onYearChange, this.onListReloaderReady) {
    year = InitialStoryTabService.initial.year;
    month = InitialStoryTabService.initial.month;
  }

  void setYear(int? selectedYear) {
    if (year == selectedYear || selectedYear == null) return;
    year = selectedYear;
    notifyListeners();
    onYearChange(year);
  }

  Future<List<int>> fetchYears() async {
    Directory root = Directory(storyFileManager.rootPath);
    if (await root.exists()) {
      await storyFileManager.ensureDirExist(root);

      List<FileSystemEntity> result = root.listSync();
      List<String> years = result.map((e) {
        return e.absolute.path.split("/").last;
      }).toList();

      Set<int> yearsInt = {};
      for (String e in years) {
        int? y = int.tryParse(e);
        if (y != null) yearsInt.add(y);
      }

      yearsInt.add(year);
      return yearsInt.toList();
    }
    return [year];
  }

  int get docsCount {
    Directory root = Directory(storyFileManager.rootPath + "/" + "$year");
    if (root.existsSync()) {
      List<FileSystemEntity> result = root.listSync(recursive: true);
      Set<String> docs = {};

      for (FileSystemEntity element in result) {
        String path = element.absolute.path;
        if (path.endsWith("." + AppConstant.documentExstension)) {
          docs.add(path.split("/").reversed.toList()[1]);
        }
      }

      return docs.length;
    }
    return 0;
  }

  Future<void> pickYear(BuildContext context) async {
    List<int> years = await fetchYears();

    List<AlertDialogAction<String>> actions = years.map((e) {
      return AlertDialogAction(
        key: "$e",
        label: e.toString(),
      );
    }).toList();
    actions.insert(0, const AlertDialogAction(key: "create", label: "Create new"));

    String? selectedOption = await showConfirmationDialog(
      context: context,
      title: "Year",
      actions: actions,
    );

    if (selectedOption == null) return;
    if (selectedOption == "create") {
      SpDatePicker.showYearPicker(context, (date) {
        int year = date.year;
        setYear(year);
      });
    } else {
      int? year = int.tryParse(selectedOption);
      setYear(year);
    }
  }
}
