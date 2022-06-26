import 'package:json_annotation/json_annotation.dart';
import 'package:spooky/core/models/base_model.dart';
import 'package:spooky/utils/mixins/comparable_mixin.dart';
import 'package:copy_with_extension/copy_with_extension.dart';

part 'story_content_db_model.g.dart';

@CopyWith()
@JsonSerializable()
class StoryContentDbModel extends BaseModel with ComparableMixin {
  final int id;
  final String? title;
  final String? plainText;
  final DateTime createdAt;
  final bool? draft;

  // List: Returns JSON-serializable version of quill delta.
  List<List<dynamic>>? pages;

  StoryContentDbModel({
    required this.id,
    required this.title,
    required this.plainText,
    required this.createdAt,
    required this.pages,
    this.draft = false,
  });

  void addPage() {
    if (pages != null) {
      pages?.add([]);
    } else {
      pages = [[]];
    }
  }

  StoryContentDbModel restore(StoryContentDbModel oldContent) {
    DateTime now = DateTime.now();
    return oldContent.copyWith(
      id: now.millisecondsSinceEpoch,
      createdAt: now,
    );
  }

  StoryContentDbModel.create({
    required this.createdAt,
    required this.id,
  })  : plainText = null,
        title = null,
        pages = [[]],
        draft = true;

  @override
  Map<String, dynamic> toJson() => _$StoryContentDbModelToJson(this);
  factory StoryContentDbModel.fromJson(Map<String, dynamic> json) => _$StoryContentDbModelFromJson(json);

  @override
  String? get objectId => id.toString();

  // avoid save without add anythings
  bool hasDataWritten(StoryContentDbModel content) {
    List<List<dynamic>> pagesClone = content.pages ?? [];
    List<List<dynamic>> pages = [...pagesClone];

    pages.removeWhere((items) {
      bool empty = items.isEmpty;
      if (items.length == 1) {
        dynamic first = items.first;
        if (first is Map) {
          dynamic insert = items.first['insert'];
          if (insert is String) return insert.trim().isEmpty;
        }
      }
      return empty;
    });

    bool emptyPages = pages.isEmpty;
    String title = content.title ?? "";

    bool hasNoDataWritten = emptyPages && title.trim().isEmpty;
    return !hasNoDataWritten;
  }

  @override
  List<String> get excludeCompareKeys {
    return [
      'id',
      'plain_text',
      'created_at',
      'draft',
    ];
  }
}
