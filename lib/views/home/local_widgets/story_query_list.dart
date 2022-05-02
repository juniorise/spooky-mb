import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spooky/core/db/databases/story_database.dart';
import 'package:spooky/core/db/models/base/base_db_list_model.dart';
import 'package:spooky/core/db/models/story_db_model.dart';
import 'package:spooky/core/models/story_query_options_model.dart';
import 'package:spooky/core/services/messenger_service.dart';
import 'package:spooky/core/storages/local_storages/sort_type_storage.dart';
import 'package:spooky/core/types/sort_type.dart';
import 'package:spooky/providers/priority_starred_provider.dart';
import 'package:spooky/utils/helpers/date_format_helper.dart';
import 'package:spooky/views/home/local_widgets/story_list.dart';

class StoryQueryList extends StatefulWidget {
  const StoryQueryList({
    Key? key,
    required this.queryOptions,
    required this.onListReloaderReady,
  }) : super(key: key);

  final StoryQueryOptionsModel queryOptions;
  final void Function(void Function() callback) onListReloaderReady;

  @override
  State<StoryQueryList> createState() => _StoryListState();
}

class _StoryListState extends State<StoryQueryList> with AutomaticKeepAliveClientMixin {
  final StoryDatabase database = StoryDatabase();
  List<StoryDbModel>? stories;

  @override
  void initState() {
    super.initState();

    load();
    setDayColors();

    widget.onListReloaderReady(load);
  }

  void setDayColors() {
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {});
  }

  DateTime dateForCompare(StoryDbModel story) {
    return story.toDateTime();
  }

  Future<void> load() async {
    SortType? sortType = await SortTypeStorage().readEnum();
    BaseDbListModel<StoryDbModel>? list = await database.fetchAll(params: widget.queryOptions.toJson());
    List<StoryDbModel> result = list?.items ?? [];

    switch (sortType) {
      case SortType.oldToNew:
      case null:
        result.sort((a, b) => (dateForCompare(a)).compareTo(dateForCompare(b)));
        break;
      case SortType.newToOld:
        result.sort((a, b) => (dateForCompare(a)).compareTo(dateForCompare(b)));
        result = result.reversed.toList();
        break;
    }

    final provider = context.read<PriorityStarredProvider>();
    if (provider.prioritied) {
      result.sort(((a, b) => b.starred == true ? 1 : -1));
    }

    if (result != stories) {
      setState(() {
        stories = result;
      });
    }
  }

  @override
  void didUpdateWidget(covariant StoryQueryList oldWidget) {
    super.didUpdateWidget(oldWidget);
    setDayColors();
    if (oldWidget.queryOptions.toPath() != widget.queryOptions.toPath()) load();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setDayColors();
  }

  Future<bool> onDelete(StoryDbModel story) async {
    OkCancelResult result = await showOkCancelAlertDialog(
      context: context,
      title: "Are you sure to delete?",
      message: "You can't undo this action",
      okLabel: "Delete",
      isDestructiveAction: true,
    );
    switch (result) {
      case OkCancelResult.ok:
        await database.deleteDocument(story);
        bool success = database.error == null;
        String message = success ? "Delete successfully!" : "Delete unsuccessfully!";
        MessengerService.instance.showSnackBar(message);
        return success;
      case OkCancelResult.cancel:
        return false;
    }
  }

  Future<bool> onToggleArchive(
    StoryDbModel story, {
    required bool archived,
  }) async {
    String? date = DateFormatHelper.yM().format(story.toDateTime());
    String title, message, label;

    if (archived) {
      title = "Are you sure to unarchive?";
      message = "Document will be move to:\n" + date;
      label = "Unarchive";
    } else {
      title = "Are you sure to archive?";
      message = "You can unarchive later.";
      label = "Archive";
    }

    OkCancelResult result = await showOkCancelAlertDialog(
      context: context,
      title: title,
      message: message,
      okLabel: label,
    );

    switch (result) {
      case OkCancelResult.ok:
        archived ? await database.unarchiveDocument(story) : await database.archiveDocument(story);
        bool success = database.error == null;
        String message = success ? "Successfully!" : "Unsuccessfully!";
        MessengerService.instance.showSnackBar(message, success: success);
        return success;
      case OkCancelResult.cancel:
        return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return StoryList(
      onRefresh: () => load(),
      stories: stories,
      emptyMessage: "Empty",
      onDelete: (story) async {
        bool success = await onDelete(story);
        if (success) await load();
        return success;
      },
      onArchive: (story) async {
        bool success = await onToggleArchive(story, archived: false);
        if (success) await load();
        return success;
      },
      onUnarchive: (story) async {
        bool success = await onToggleArchive(story, archived: true);
        if (success) await load();
        return success;
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
