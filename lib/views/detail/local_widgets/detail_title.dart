import 'package:flutter/material.dart';
import 'package:spooky/core/db/models/story_db_model.dart';
import 'package:spooky/theme/m3/m3_color.dart';
import 'package:spooky/theme/m3/m3_text_theme.dart';
import 'package:spooky/utils/helpers/date_format_helper.dart';
import 'package:spooky/utils/util_widgets/sp_date_picker.dart';
import 'package:spooky/widgets/sp_animated_icon.dart';
import 'package:spooky/utils/constants/config_constant.dart';
import 'package:spooky/widgets/sp_tap_effect.dart';

class DetailTitle extends StatelessWidget {
  const DetailTitle({
    Key? key,
    required this.readOnlyNotifier,
    required this.currentStory,
    required this.setPathDate,
  }) : super(key: key);

  final ValueNotifier<bool> readOnlyNotifier;
  final StoryDbModel currentStory;
  final Future<void> Function(DateTime newPathDate) setPathDate;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: ValueListenableBuilder<bool>(
        valueListenable: readOnlyNotifier,
        child: buildTitle(context),
        builder: (context, readOnly, child) {
          return SpTapEffect(
            onTap: readOnly ? null : () => onUpdate(context),
            child: child!,
          );
        },
      ),
    );
  }

  Future<void> onUpdate(BuildContext context) async {
    DateTime? pathDate = await SpDatePicker.showDatePicker(
      context,
      currentStory.displayPathDate,
    );
    if (pathDate != null) {
      setPathDate(pathDate);
    }
  }

  Widget buildTitle(BuildContext context) {
    return Row(
      children: [
        Text(
          currentStory.day.toString(),
          style: M3TextTheme.of(context).headlineLarge?.copyWith(color: M3Color.of(context).primary),
        ),
        ConfigConstant.sizedBoxW0,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(getDayOfMonthSuffix(currentStory.day).toLowerCase(), style: M3TextTheme.of(context).labelSmall),
            Text(
              DateFormatHelper.yM().format(currentStory.displayPathDate).toUpperCase(),
              style: M3TextTheme.of(context).labelMedium,
            ),
          ],
        ),
        ConfigConstant.sizedBoxW0,
        ValueListenableBuilder<bool>(
          valueListenable: readOnlyNotifier,
          child: const Icon(Icons.arrow_drop_down),
          builder: (context, value, child) {
            return SpAnimatedIcons(
              showFirst: !readOnlyNotifier.value,
              secondChild: const SizedBox.shrink(),
              firstChild: child!,
            );
          },
        ),
      ],
    );
  }

  String getDayOfMonthSuffix(int dayNum) {
    if (!(dayNum >= 1 && dayNum <= 31)) {
      throw Exception('Invalid day of month');
    }

    if (dayNum >= 11 && dayNum <= 13) {
      return 'th';
    }

    switch (dayNum % 10) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return 'th';
    }
  }
}
