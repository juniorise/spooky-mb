import 'dart:io';
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/foundation.dart';
import 'package:spooky/core/file_managers/story_file_manager.dart';
import 'package:spooky/core/models/story_model.dart';
import 'package:spooky/core/notification/channels/base_notification_channel.dart';
import 'package:spooky/core/types/notification_channel_types.dart';
import 'package:spooky/core/notification/payloads/auto_save_payload.dart';
import 'package:spooky/utils/helpers/date_format_helper.dart';

export 'package:spooky/core/notification/payloads/auto_save_payload.dart';

class AutoSaveChannel extends BaseNotificationChannel<AutoSavePayload> {
  @override
  NotificationChannelTypes get channelKey => NotificationChannelTypes.autoSave;

  @override
  String get channelName => 'Auto Save Notification';

  @override
  String get channelDescription => 'Show notification when stories is auto saved on app inactive.';

  @override
  List<NotificationActionButton>? get actionButtons => null;

  @override
  Future<void> triggered({
    String? buttonKey,
    Map<String, String>? payload,
  }) async {
    if (payload == null) return;
    AutoSavePayload? object;

    try {
      object = AutoSavePayload.fromJson(payload);
    } catch (e) {
      if (kDebugMode) {
        print("ERROR: $e");
      }
    }

    String? path = object?.path;
    if (path == null) return;

    File file = File(path);
    if (!file.existsSync()) return;

    StoryModel? story = await StoryFileManager().fetchOne(file);
    if (story == null) return;

    String? message;
    if (story.changes.isNotEmpty) {
      message = DateFormatHelper.yM().format(story.changes.last.createdAt);
    }

    if (context == null) return;
    showOkAlertDialog(
      context: context!,
      title: "Your document is saved",
      message: message != null ? "Document will be move to:\n" + message : null,
    );
  }
}
