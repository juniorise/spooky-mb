import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:spooky/theme/m3/m3_color.dart';
import 'package:spooky/theme/m3/m3_text_theme.dart';
import 'package:spooky/utils/constants/config_constant.dart';
import 'package:spooky/utils/helpers/date_format_helper.dart';
import 'package:spooky/views/detail/quill_renderer_helper/date_block_embed.dart';
import 'package:spooky/widgets/sp_animated_icon.dart';

class CustomDateBlockRenderer extends StatelessWidget {
  const CustomDateBlockRenderer({
    Key? key,
    required this.block,
    required this.readOnly,
    required this.controller,
  }) : super(key: key);

  final quill.CustomBlockEmbed block;
  final bool readOnly;
  final quill.QuillController controller;

  @override
  Widget build(BuildContext context) {
    final document = DateBlockEmbed(block.data).document;
    final date = DateTime.tryParse(document.toPlainText().trim()) ?? DateTime.now();

    final onTap = readOnly
        ? null
        : () => DateBlockEmbed.update(
              controller: controller,
              initDate: date,
              context: context,
              document: document,
            );

    return Row(
      children: [
        InkWell(
          onTap: onTap,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(
                date.day.toString().padLeft(2, '0'),
                style: M3TextTheme.of(context).headlineLarge?.copyWith(color: M3Color.of(context).primary),
              ),
              ConfigConstant.sizedBoxW0,
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(getDayOfMonthSuffix(date.day).toLowerCase(), style: M3TextTheme.of(context).labelSmall),
                  Text(
                    DateFormatHelper.yM().format(date).toUpperCase(),
                    style: M3TextTheme.of(context).labelMedium,
                  ),
                ],
              ),
              ConfigConstant.sizedBoxW0,
              SpAnimatedIcons(
                showFirst: !readOnly,
                secondChild: const SizedBox.shrink(),
                firstChild: const Icon(Icons.arrow_drop_down),
              ),
            ],
          ),
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
