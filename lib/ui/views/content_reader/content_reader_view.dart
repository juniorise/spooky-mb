library content_reader_view;

import 'package:flutter/services.dart';
import 'package:page_turn/page_turn.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:spooky/core/models/story_content_model.dart';
import 'package:spooky/core/services/audio_service.dart';
import 'package:spooky/gen/assets.gen.dart';
import 'package:spooky/theme/m3/m3_color.dart';
import 'package:spooky/ui/views/content_reader/local_widgets/content_page_viewer.dart';
import 'package:spooky/ui/widgets/sp_animated_icon.dart';
import 'package:spooky/ui/widgets/sp_pop_button.dart';
import 'package:spooky/ui/widgets/sp_screen_type_layout.dart';
import 'package:spooky/utils/constants/config_constant.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';
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
    return ViewModelBuilder<ContentReaderViewModel>.reactive(
      viewModelBuilder: () => ContentReaderViewModel(content),
      onModelReady: (model) {},
      builder: (context, model, child) {
        return SpScreenTypeLayout(
          mobile: _ContentReaderMobile(model),
          desktop: _ContentReaderDesktop(model),
          tablet: _ContentReaderTablet(model),
        );
      },
    );
  }
}
