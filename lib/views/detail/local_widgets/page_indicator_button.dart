import 'package:community_material_icon/community_material_icon.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:spooky/theme/m3/m3_text_theme.dart';
import 'package:spooky/widgets/sp_animated_icon.dart';
import 'package:spooky/widgets/sp_cross_fade.dart';
import 'package:spooky/widgets/sp_pop_up_menu_button.dart';
import 'package:spooky/widgets/sp_tap_effect.dart';
import 'package:spooky/utils/constants/config_constant.dart';

class PageIndicatorButton extends StatefulWidget {
  const PageIndicatorButton({
    Key? key,
    required this.controller,
    required this.pagesCount,
    required this.quillControllerGetter,
  }) : super(key: key);

  final PageController controller;
  final int pagesCount;
  final QuillController? Function(int page) quillControllerGetter;

  @override
  State<PageIndicatorButton> createState() => _PageIndicatorButtonState();
}

class _PageIndicatorButtonState extends State<PageIndicatorButton> {
  int lastReportedPage = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      lastReportedPage = widget.controller.page?.toInt() ?? 0;
      widget.controller.addListener(listener);
    });
  }

  void listener() {
    int currentPage = widget.controller.page?.round() ?? 0;
    if (lastReportedPage != currentPage) {
      setState(() {
        lastReportedPage = currentPage;
      });
    }
  }

  @override
  void dispose() {
    if (widget.controller.hasClients) widget.controller.removeListener(listener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SpPopupMenuButton(
      fromAppBar: true,
      items: (BuildContext context) {
        return [
          SpPopMenuItem(
            title: tr("title.page.title"),
            subtitle: "${lastReportedPage + 1}",
            leadingIconData: Icons.pageview,
          ),
          SpPopMenuItem(
            title: tr("title.characters.title"),
            subtitle: widget.quillControllerGetter(lastReportedPage)?.document.toPlainText().length.toString(),
            leadingIconData: Icons.text_snippet,
          ),
          SpPopMenuItem(
            title: tr("title.words.title"),
            subtitle:
                widget.quillControllerGetter(lastReportedPage)?.document.toPlainText().split(" ").length.toString(),
            leadingIconData: Icons.text_format,
          ),
        ];
      },
      builder: (void Function() callback) {
        return SpTapEffect(
          onTap: callback,
          child: SpCrossFade(
            showFirst: widget.pagesCount > 1,
            firstChild: buildAnimated(context),
            secondChild: buildAnimated(context),
          ),
        );
      },
    );
  }

  Widget buildAnimated(BuildContext context) {
    return Container(
      height: kToolbarHeight,
      alignment: Alignment.center,
      child: SpAnimatedIcons(
        showFirst: widget.pagesCount > 1,
        secondChild: AnimatedContainer(
          width: ConfigConstant.objectHeight1,
          duration: ConfigConstant.fadeDuration,
          alignment: Alignment.center,
          child: const Icon(CommunityMaterialIcons.book_multiple),
        ),
        firstChild: Container(
          height: ConfigConstant.iconSize3,
          alignment: Alignment.center,
          padding: const EdgeInsets.only(left: 12.0, right: 4.0),
          child: buildPageNumber(context),
        ),
      ),
    );
  }

  Widget buildPageNumber(BuildContext context) {
    return RichText(
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      text: TextSpan(
        style: M3TextTheme.of(context).bodyMedium,
        children: [
          TextSpan(text: "${lastReportedPage + 1}", style: M3TextTheme.of(context).titleLarge),
          TextSpan(text: "/${widget.pagesCount}"),
        ],
      ),
    );
  }
}
