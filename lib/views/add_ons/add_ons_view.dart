library add_ons_view;

import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:flutter/material.dart';
import 'package:spooky/core/base/view_model_provider.dart';
import 'package:spooky/providers/google_pay_provider.dart';
import 'package:spooky/utils/extensions/string_extension.dart';
import 'package:spooky/utils/helpers/app_helper.dart';
import 'package:spooky/widgets/sp_app_bar_title.dart';
import 'package:spooky/widgets/sp_button.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';
import 'add_ons_view_model.dart';

part 'add_ons_mobile.dart';
part 'add_ons_tablet.dart';
part 'add_ons_desktop.dart';

class AddOnsView extends StatelessWidget {
  const AddOnsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<AddOnsViewModel>(
      create: (_) => AddOnsViewModel(),
      builder: (context, viewModel, child) {
        return ScreenTypeLayout(
          mobile: _AddOnsMobile(viewModel),
          desktop: _AddOnsDesktop(viewModel),
          tablet: _AddOnsTablet(viewModel),
        );
      },
    );
  }
}
