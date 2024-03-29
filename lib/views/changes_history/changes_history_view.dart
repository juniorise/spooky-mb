library changes_history_view;

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:community_material_icon/community_material_icon.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:spooky/core/base/view_model_provider.dart';
import 'package:spooky/core/db/models/story_content_db_model.dart';
import 'package:spooky/core/db/models/story_db_model.dart';
import 'package:spooky/core/routes/sp_router.dart';
import 'package:spooky/core/services/messenger_service.dart';
import 'package:spooky/theme/m3/m3_color.dart';
import 'package:spooky/theme/m3/m3_text_theme.dart';
import 'package:spooky/views/detail/detail_view.dart';
import 'package:spooky/widgets/sp_animated_icon.dart';
import 'package:spooky/widgets/sp_app_bar_title.dart';
import 'package:spooky/widgets/sp_cross_fade.dart';
import 'package:spooky/widgets/sp_icon_button.dart';
import 'package:spooky/widgets/sp_pop_button.dart';
import 'package:spooky/widgets/sp_pop_up_menu_button.dart';
import 'package:spooky/utils/constants/config_constant.dart';
import 'package:spooky/utils/helpers/date_format_helper.dart';
import 'package:flutter/material.dart';
import 'package:spooky/widgets/sp_small_chip.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';
import 'changes_history_view_model.dart';

part 'changes_history_mobile.dart';

class ChangesHistoryView extends StatelessWidget {
  const ChangesHistoryView({
    Key? key,
    required this.story,
    required this.onRestorePressed,
    required this.onDeletePressed,
  }) : super(key: key);

  final StoryDbModel story;
  final void Function(int contentId, StoryDbModel storyFromChangesView) onRestorePressed;
  final Future<StoryDbModel> Function(List<int> contentIds, StoryDbModel storyFromChangesView) onDeletePressed;

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<ChangesHistoryViewModel>(
      create: (BuildContext context) => ChangesHistoryViewModel(story, onRestorePressed, onDeletePressed),
      builder: (context, viewModel, child) {
        return _ChangesHistoryMobile(viewModel);
      },
    );
  }
}
