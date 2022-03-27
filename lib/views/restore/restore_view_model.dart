import 'dart:convert';
import 'dart:io';
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spooky/core/backup/backup_service.dart';
import 'package:spooky/core/base/base_view_model.dart';
import 'package:spooky/core/api/cloud_storages/gdrive_backup_storage.dart';
import 'package:spooky/core/file_manager/managers/story_manager.dart';
import 'package:spooky/core/models/backup_display_model.dart';
import 'package:spooky/core/models/backup_model.dart';
import 'package:spooky/core/models/cloud_file_list_model.dart';
import 'package:spooky/core/models/cloud_file_model.dart';
import 'package:spooky/core/models/story_model.dart';
import 'package:spooky/core/models/story_query_options_model.dart';
import 'package:spooky/core/services/messenger_service.dart';
import 'package:spooky/core/types/file_path_type.dart';

class RestoreViewModel extends BaseViewModel {
  late final ValueNotifier<bool> showSkipNotifier;
  final bool showSkipButton;

  Map<String, List<CloudFileModel>>? groupByYear;
  CloudFileListModel? fileList;
  RestoreViewModel(this.showSkipButton) {
    load();
    showSkipNotifier = ValueNotifier<bool>(true);
  }

  void setGroupByYear() {
    Map<String, List<CloudFileModel>> groups = {};
    for (CloudFileModel e in fileList?.files ?? []) {
      BackupDisplayModel display = BackupDisplayModel.fromCloudModel(e);
      List<CloudFileModel>? type = groups[display.fileName];
      type != null ? type.add(e) : type = [e];
      groups[display.fileName] = type;
    }
    groupByYear = groups;
  }

  Future<void> load() async {
    GDriveBackupStorage storage = GDriveBackupStorage();
    fileList = await storage.execHandler(() => storage.list({"next_token": fileList?.nextToken}));
    setGroupByYear();
    notifyListeners();
  }

  Map<String, BackupModel> cacheDownloadRestores = {};
  BackupModel? getCache(CloudFileModel file) {
    return cacheDownloadRestores[file.id];
  }

  Future<BackupModel?> download(CloudFileModel file) async {
    if (cacheDownloadRestores.containsKey(file.id)) {
      return cacheDownloadRestores[file.id]!;
    } else {
      GDriveBackupStorage storage = GDriveBackupStorage();
      String? content = await storage.get({"file": file});
      if (content != null) {
        dynamic map = jsonDecode(content);
        BackupModel backup = BackupModel.fromJson(map);
        cacheDownloadRestores[file.id] = backup;
        return backup;
      }
    }
    return null;
  }

  Future<bool> restore(
    BuildContext context,
    CloudFileModel file,
    BackupDisplayModel display,
  ) async {
    var year = display.createAt?.year;
    Iterable<FileSystemEntity>? result = await StoryManager().fetchFiles(
      options: StoryQueryOptionsModel(
        filePath: FilePathType.docs,
        year: display.createAt?.year,
      ),
    );

    if (result?.isNotEmpty == true) {
      OkCancelResult result = await showOkCancelAlertDialog(
        context: context,
        title: "Notice",
        message: year != null
            ? "Look like you have some data in $year. So, exist stories will be overrided by cloud stories. Are you sure to restore?"
            : "Exist stories will be overrided by cloud stories. Are you sure to restore?",
        okLabel: "Restore",
        isDestructiveAction: true,
      );
      switch (result) {
        case OkCancelResult.ok:
          break;
        case OkCancelResult.cancel:
          return false;
      }
    }

    BackupModel? backup = await MessengerService.instance.showLoading(future: () => download(file), context: context);
    await BackupService().restore(backup);

    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      showSkipNotifier.value = false;
      MessengerService.instance.showSnackBar("Restored");
    });

    return true;
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      showSkipNotifier.dispose();
    });
  }

  Future<void> delete(BuildContext context, CloudFileModel file) async {
    OkCancelResult result = await showOkCancelAlertDialog(
      context: context,
      title: "Are you sure to delete?",
      message: "You can't undo this action",
      okLabel: "Delete",
      isDestructiveAction: true,
    );
    switch (result) {
      case OkCancelResult.ok:
        GDriveBackupStorage storage = GDriveBackupStorage();
        bool? success = await MessengerService.instance.showLoading(
          future: () async {
            await storage.execHandler(() async {
              return storage.delete({'file_id': file.id});
            });
            await load();
            return fileList?.files.map((e) => e.id).contains(file.id) == true;
          },
          context: context,
        );
        String message = success == true ? "Delete successfully!" : "Delete unsuccessfully!";
        MessengerService.instance.showSnackBar(message);
        break;
      case OkCancelResult.cancel:
        break;
    }
  }
}
