library content_reader_view;

import 'package:provider/provider.dart';
import 'package:spooky/core/models/story_content_model.dart';
import 'package:spooky/theme/m3/m3_color.dart';
import 'package:spooky/views/content_reader/local_widgets/content_page_viewer.dart';
import 'package:spooky/views/detail/local_widgets/page_indicator_button.dart';
import 'package:spooky/widgets/sp_page_view/sp_page_view.dart';
import 'package:spooky/widgets/sp_pop_button.dart';
import 'package:spooky/widgets/sp_screen_type_layout.dart';

import 'package:flutter/material.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';
import 'content_reader_view_model.dart';

part 'content_reader_mobile.dart';
part 'content_reader_tablet.dart';
part 'content_reader_desktop.dart';

class ContentReaderView extends StatelessWidget {
  const ContentReaderView({
    Key? key,
    required this.content,
  }) : super(key: key);

  final StoryContentModel content;

  @override
  Widget build(BuildContext context) {
    return ListenableProvider(
      create: (BuildContext context) => ContentReaderViewModel(content),
      builder: (context, child) {
        ContentReaderViewModel model = Provider.of<ContentReaderViewModel>(context);
        return SpScreenTypeLayout(
          mobile: _ContentReaderMobile(model),
          desktop: _ContentReaderDesktop(model),
          tablet: _ContentReaderTablet(model),
        );
      },
    );
  }
}
