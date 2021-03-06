import 'package:flutter/material.dart';
import 'package:spooky/core/db/models/story_content_db_model.dart';
import 'package:spooky/core/db/models/story_db_model.dart';
import 'package:spooky/core/base/base_view_model.dart';
import 'package:spooky/utils/helpers/story_db_constructor_helper.dart';

class ChangesHistoryViewModel extends BaseViewModel {
  StoryDbModel? story;
  final void Function(int contentId, StoryDbModel storyFromChangesView) onRestorePressed;
  final Future<StoryDbModel> Function(List<int> contentIds, StoryDbModel storyFromChangesView) onDeletePressed;

  bool _editing = false;
  bool get editing => _editing;

  toggleEditing() {
    _editing = !_editing;
    notifyListeners();
  }

  late final ValueNotifier<Set<int>> selectedNotifier;

  ChangesHistoryViewModel(
    StoryDbModel story,
    this.onRestorePressed,
    this.onDeletePressed,
  ) {
    selectedNotifier = ValueNotifier({});
    initStory(story);
  }

  void initStory(StoryDbModel story) {
    StoryDbConstructorHelper.loadChanges(story).then((value) {
      this.story = value;
      notifyListeners();
    });
  }

  void delele() async {
    if (story == null) return;
    StoryDbModel value = await onDeletePressed(selectedNotifier.value.toList(), story!);
    story = value;
    notifyListeners();
  }

  void restore(StoryContentDbModel content) {
    if (story == null) return;
    onRestorePressed(content.id, story!);
  }

  @override
  void notifyListeners() {
    super.notifyListeners();
    if (_editing == false) {
      Set<int> value = {...selectedNotifier.value}..clear();
      selectedNotifier.value = value;
    }

    // make sure select id is in story
    if (story == null) return;
    final list = story!.changes.map((e) => e.id);
    Set<int> value = selectedNotifier.value;
    value.removeWhere((e) => !list.contains(e));
    selectedNotifier.value = value;
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      selectedNotifier.dispose();
    });
  }
}
