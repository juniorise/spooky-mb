library main_view;

import 'package:flutter/rendering.dart';
import 'package:spooky/core/models/story_model.dart';
import 'package:spooky/core/routes/sp_route_config.dart';
import 'package:spooky/theme/m3/m3_color.dart';
import 'package:spooky/ui/views/detail/detail_view_model.dart';
import 'package:spooky/ui/views/explore/explore_view.dart';
import 'package:spooky/ui/views/home/home_view.dart';
import 'package:spooky/ui/views/main/main_view_item.dart';
import 'package:spooky/ui/views/setting/setting_view.dart';
import 'package:spooky/ui/widgets/sp_animated_icon.dart';
import 'package:spooky/ui/widgets/sp_bottom_navaigation_bar.dart';
import 'package:spooky/ui/widgets/sp_cross_fade.dart';
import 'package:spooky/ui/widgets/sp_screen_type_layout.dart';
import 'package:spooky/ui/widgets/sp_show_hide_animator.dart';
import 'package:spooky/ui/widgets/sp_tap_effect.dart';
import 'package:spooky/utils/constants/config_constant.dart';
import 'package:spooky/utils/util_widgets/measure_size.dart';
import 'package:spooky/utils/util_widgets/sp_date_picker.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';
import 'main_view_model.dart';

part 'main_mobile.dart';
part 'main_tablet.dart';
part 'main_desktop.dart';

class MainView extends StatelessWidget {
  const MainView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<MainViewModel>.reactive(
      viewModelBuilder: () => MainViewModel(),
      onModelReady: (model) {},
      disposeViewModel: false,
      builder: (context, model, child) {
        return SpScreenTypeLayout(
          listener: (info) {
            if (info.isSmall) {
              model.setShouldHideBottomNav(false, true);
            } else {
              model.setShouldHideBottomNav(true, true);
            }
          },
          mobile: _MainMobile(model),
          desktop: _MainDesktop(model),
          tablet: _MainTablet(model),
        );
      },
    );
  }
}
