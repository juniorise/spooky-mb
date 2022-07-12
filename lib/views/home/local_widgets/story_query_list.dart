import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:spooky/app.dart';
import 'package:spooky/core/db/databases/story_database.dart';
import 'package:spooky/core/db/models/story_db_model.dart';
import 'package:spooky/core/models/story_query_options_model.dart';
import 'package:spooky/core/services/messenger_service.dart';
import 'package:spooky/core/storages/local_storages/last_update_story_list_hash_storage.dart';
import 'package:spooky/widgets/sp_story_list/sp_story_list.dart';

class StoryQueryList extends StatefulWidget {
  const StoryQueryList({
    Key? key,
    required this.queryOptions,
    this.overridedLayout,
    this.showLoadingAfterInit = false,
  }) : super(key: key);

  final StoryQueryOptionsModel queryOptions;
  final SpListLayoutType? overridedLayout;
  final bool showLoadingAfterInit;

  @override
  State<StoryQueryList> createState() => _StoryListState();
}

class _StoryListState extends State<StoryQueryList> with AutomaticKeepAliveClientMixin, RouteAware {
  final StoryDatabase database = StoryDatabase.instance;
  final LastUpdateStoryListHashStorage hashStorage = LastUpdateStoryListHashStorage();
  List<StoryDbModel>? stories;

  // this just to prevent from load multiple time
  // not for UI
  bool? loadingFlag;
  int? hash;

  @override
  void initState() {
    super.initState();
    load();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ModalRoute? modalRoute = ModalRoute.of(context);
      if (modalRoute != null) App.storyQueryListObserver.subscribe(this, modalRoute);
    });
  }

  @override
  void dispose() {
    super.dispose();
    App.storyQueryListObserver.unsubscribe(this);
  }

  Future<void> loadHash() async {
    try {
      hash = await hashStorage.read();
    } catch (e) {
      hashStorage.remove();
      if (kDebugMode) {
        print("ERROR: loadHash $e");
      }
    }
  }

  Future<List<StoryDbModel>> _fetchStory() async {
    final list = await database.fetchAll(params: widget.queryOptions.toJson());
    List<StoryDbModel> result = list?.items ?? [];
    loadHash();
    return result;
  }

  Future<void> load([bool callFromRefresh = false]) async {
    if (loadingFlag == true) return;

    final completer = Completer();
    if (stories != null && (!callFromRefresh || widget.showLoadingAfterInit)) {
      loadingFlag = true;
      MessengerService.instance
          .showLoading(
            future: () => completer.future,
            context: context,
            debugSource: "StoryQueryList#load",
          )
          .then((value) => loadingFlag = false);
    }

    final result = await _fetchStory();
    if (result != stories) {
      setState(() {
        stories = result;
      });
    }

    completer.complete(1);
  }

  @override
  void didUpdateWidget(covariant StoryQueryList oldWidget) {
    super.didUpdateWidget(oldWidget);
    _checkUpdatation(oldWidget);
  }

  void _checkUpdatation(StoryQueryList? oldWidget) {
    bool didUpdateQueries = oldWidget != null && oldWidget.queryOptions.join() != widget.queryOptions.join();
    hashStorage.read().then((hash) {
      if (this.hash != hash || didUpdateQueries) {
        load(true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (kDebugMode) {
      print("BUILD: StoryQueryList");
    }

    return SpStoryList(
      onRefresh: () => load(true),
      overridedLayout: widget.overridedLayout,
      stories: stories,
    );
  }

  @override
  void didPopNext() {
    super.didPopNext();
    _checkUpdatation(null);
  }

  @override
  void didPushNext() {
    super.didPushNext();
    _checkUpdatation(null);
  }

  @override
  bool get wantKeepAlive => true;
}
