import 'dart:io';

import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:spooky/core/external_apis/cloud_storages/gdrive_backups_storage.dart';
import 'package:spooky/core/external_apis/cloud_storages/gdrive_spooky_folder_storage.dart';
import 'package:spooky/core/backups/destinations/base_backup_destination.dart';
import 'package:spooky/core/backups/providers/google_cloud_provider.dart';
import 'package:spooky/core/models/cloud_file_list_model.dart';
import 'package:spooky/core/models/cloud_file_model.dart';
import 'package:spooky/core/backups/models/backups_model.dart';
import 'package:spooky/core/services/messenger_service.dart';
import 'package:spooky/utils/helpers/app_helper.dart';
import 'package:googleapis/drive/v3.dart' as drive;

class GDriveBackupDestination extends BaseBackupDestination<GoogleCloudProvider> {
  final GDriveBackupsStorage cloudStorage = GDriveBackupsStorage();

  GDriveBackupDestination() {
    fetchAll();
  }

  @override
  String get cloudId => "google_drive";

  @override
  bool canLaunchSource() => true;

  @override
  Future<void>? viewSource(BuildContext context) async {
    String? storageId = await MessengerService.instance.showLoading(
      debugSource: "GDriveBackupDestination#viewSource",
      context: context,
      future: () async {
        drive.DriveApi? driveApi = await cloudStorage.driveClient;
        if (driveApi == null) return null;
        return GDriveSpookyFolderStorage().getFolderId(driveApi);
      },
    );

    if (storageId != null) {
      AppHelper.openLinkDialog("https://drive.google.com/drive/folders/$storageId?usp=sharing");
    }
  }

  @override
  Future<CloudFileModel?> backup(FileSystemEntity file, BackupsModel backups) async {
    CloudFileModel? cloudFile = await cloudStorage.execHandler(() {
      return cloudStorage.write({
        "file": file,
        "backups": backups,
      });
    });
    return cloudFile;
  }

  @override
  Future<String?> fetchContent(CloudFileModel file) async {
    String? content = await cloudStorage.execHandler(() => cloudStorage.get({"file": file}));
    return content;
  }

  @override
  Future<CloudFileListModel?> fetchAll({
    Map<String, dynamic> params = const {},
  }) async {
    cloudFiles = null;

    CloudFileListModel? list = await cloudStorage.execHandler(() {
      return cloudStorage.list({"next_token": params['next_token']});
    });

    List<CloudFileModel>? files = list?.files
        //.where((file) {
        //   return file.fileName?.startsWith(BackupsMetaData.prefix) == true;
        // }).toList()
        ;

    cloudFiles = list?.copyWith(files: files);
    return cloudFiles;
  }

  @override
  IconData get iconData => CommunityMaterialIcons.google_drive;

  @override
  Future<void> delete(CloudFileModel file) async {
    await cloudStorage.execHandler(() {
      return cloudStorage.delete({
        "file_id": file.id,
      });
    });
  }
}
