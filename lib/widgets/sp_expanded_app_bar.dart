import 'package:flutter/material.dart';
import 'package:spooky/utils/constants/config_constant.dart';
import 'package:spooky/widgets/sp_pop_button.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';

class SpExpandedAppBar extends StatelessWidget {
  const SpExpandedAppBar({
    Key? key,
    required this.expandedHeight,
    required this.title,
    required this.subtitle,
    required this.actions,
    this.backgroundColor,
  }) : super(key: key);

  final double expandedHeight;
  final String title;
  final String subtitle;
  final List<Widget> actions;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return MorphingSliverAppBar(
      expandedHeight: expandedHeight,
      backgroundColor: backgroundColor,
      leading: SpPopButton(),
      pinned: true,
      floating: true,
      stretch: true,
      title: Text(""),
      elevation: Theme.of(context).appBarTheme.elevation,
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.none,
        background: TweenAnimationBuilder<int>(
          duration: ConfigConstant.fadeDuration,
          tween: IntTween(begin: 0, end: 1),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0).copyWith(top: 72.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: Theme.of(context).appBarTheme.titleTextStyle,
                  textAlign: TextAlign.center,
                ),
                ConfigConstant.sizedBoxH1,
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          builder: (context, value, child) {
            return AnimatedOpacity(
              opacity: value == 1 ? 1.0 : 0.0,
              duration: ConfigConstant.fadeDuration,
              child: child,
            );
          },
        ),
      ),
      actions: actions,
    );
  }
}
