import 'package:flutter/material.dart';
import 'package:spooky/core/storages/local_storages/list_layout_type.dart';
import 'package:spooky/core/types/list_layout_type.dart';

typedef _SpListLayoutBuilder = Widget Function(BuildContext context, ListLayoutType type, bool loaded);

class SpListLayoutBuilder extends StatelessWidget {
  const SpListLayoutBuilder({
    Key? key,
    required this.builder,
  }) : super(key: key);

  final _SpListLayoutBuilder builder;

  static ListLayoutStorage get storage => ListLayoutStorage();
  static ListLayoutType get defaultLayout => ListLayoutType.tabs;

  static Future<ListLayoutType> get() async {
    return await storage.readEnum() ?? defaultLayout;
  }

  static Future<void> set(ListLayoutType type) async {
    return await storage.writeEnum(type);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ListLayoutType>(
      future: get(),
      builder: (context, snapshot) {
        return builder(
          context,
          snapshot.data ?? defaultLayout,
          snapshot.hasData,
        );
      },
    );
  }
}
