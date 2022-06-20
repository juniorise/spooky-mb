import 'dart:convert';
import 'dart:io';
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spooky/core/backups/backups_service.dart';
import 'package:spooky/core/backups/destinations/cloud_file_tuple.dart';
import 'package:spooky/core/backups/models/backups_metadata.dart';
import 'package:spooky/core/backups/models/backups_model.dart';
import 'package:spooky/core/backups/providers/base_cloud_provider.dart';
import 'package:spooky/core/db/databases/story_database.dart';
import 'package:spooky/core/models/cloud_file_list_model.dart';
import 'package:spooky/core/models/cloud_file_model.dart';
import 'package:spooky/core/services/messenger_service.dart';

abstract class BaseBackupDestination<T extends BaseCloudProvider> {
  CloudFileListModel? cloudFiles;

  String get cloudId;
  Future<CloudFileModel?> backup(FileSystemEntity file, BackupsModel backups);

  Future<void> _restore(BackupsModel backups, BuildContext context) async {
    await BackupsService.instance.restore(backups: backups);
    MessengerService.instance.showSnackBar("Restore", success: true, action: (color) {
      return SnackBarAction(
        label: "Go home",
        onPressed: () {
          Navigator.of(context).popUntil((route) => route.isFirst);
        },
      );
    });
  }

  Future<void> restore(BackupsModel backups, BuildContext context) async {
    // TODO: implement on all database instead
    int result = StoryDatabase.instance.getDocsCount(null);

    if (result > 0) {
      OkCancelResult result = await showOkCancelAlertDialog(
        context: context,
        title: "Notice",
        message: "Exist stories will be overrided by cloud stories. Are you sure to restore?",
        okLabel: "Restore",
        isDestructiveAction: true,
      );
      switch (result) {
        case OkCancelResult.ok:
          // ignore: use_build_context_synchronously
          return _restore(backups, context);
        case OkCancelResult.cancel:
          break;
      }
    } else {
      return _restore(backups, context);
    }
  }

  Future<CloudFileListModel?> fetchAll({
    Map<String, dynamic> params = const {},
  });

  List<CloudFileTuple> metaDatasFromCloudFiles(CloudFileListModel? cloudFiles) {
    List<CloudFileTuple> elements = [];
    List<CloudFileModel> files = cloudFiles?.files ?? [];

    for (CloudFileModel file in files) {
      String? fileName = file.fileName;
      BackupsMetadata? metaData = BackupsMetadata.fromFileName(fileName ?? "");
      if (metaData != null) {
        elements.add(
          CloudFileTuple(
            cloudFile: file,
            metadata: metaData,
          ),
        );
      }
    }

    elements.sort((a, b) => a.metadata.createdAt.compareTo(b.metadata.createdAt));
    return elements;
  }

  CloudFileTuple? lastSyncFromFile(CloudFileListModel? fileList) {
    List<CloudFileTuple> list = metaDatasFromCloudFiles(fileList);
    return list.isNotEmpty ? list.last : null;
  }

  /// only call from base class
  Future<String?> fetchContent(CloudFileModel file);

  Future<BackupsModel?> download(CloudFileModel file) async {
    String? content = await fetchContent(file);
    if (content != null) return fromJson(content);
    return null;
  }

  Future<BackupsModel?> fromJson(String content) async {
    BackupsModel? backups = await compute(_fromJson, content);
    return backups;
  }

  Widget buildWithConsumer({
    required Widget Function(BuildContext context, T value, Widget? child) builder,
    Widget? child,
  }) {
    return Consumer<T>(
      builder: builder,
      child: child,
    );
  }

  IconData get iconData;
}

BackupsModel? _fromJson(String content) {
  try {
    dynamic map = jsonDecode(content);
    if (map is Map<String, dynamic>) {
      return BackupsModel.fromJson(map);
    }
  } catch (e) {
    if (kDebugMode) print("ERROR: _fromJson $e");
  }
  return null;
}
