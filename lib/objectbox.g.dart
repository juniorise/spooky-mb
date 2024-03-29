// GENERATED CODE - DO NOT MODIFY BY HAND
// This code was generated by ObjectBox. To update it run the generator again:
// With a Flutter package, run `flutter pub run build_runner build`.
// With a Dart package, run `dart run build_runner build`.
// See also https://docs.objectbox.io/getting-started#generate-objectbox-code

// ignore_for_file: camel_case_types
// coverage:ignore-file

import 'dart:typed_data';

import 'package:flat_buffers/flat_buffers.dart' as fb;
import 'package:objectbox/internal.dart'; // generated code can access "internal" functionality
import 'package:objectbox/objectbox.dart';
import 'package:objectbox_flutter_libs/objectbox_flutter_libs.dart';

import 'core/db/adapters/objectbox/entities.dart';

export 'package:objectbox/objectbox.dart'; // so that callers only have to import this file

final _entities = <ModelEntity>[
  ModelEntity(
      id: const IdUid(1, 2962579780537594759),
      name: 'StoryObjectBox',
      lastPropertyId: const IdUid(20, 4113637293536721721),
      flags: 0,
      properties: <ModelProperty>[
        ModelProperty(
            id: const IdUid(1, 97606503289813034),
            name: 'id',
            type: 6,
            flags: 129),
        ModelProperty(
            id: const IdUid(2, 6285480559740659261),
            name: 'version',
            type: 6,
            flags: 0),
        ModelProperty(
            id: const IdUid(3, 1455186831852939171),
            name: 'type',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(4, 4895366266528452927),
            name: 'year',
            type: 6,
            flags: 0),
        ModelProperty(
            id: const IdUid(5, 3493347036869873160),
            name: 'month',
            type: 6,
            flags: 0),
        ModelProperty(
            id: const IdUid(6, 3490487563053838054),
            name: 'day',
            type: 6,
            flags: 0),
        ModelProperty(
            id: const IdUid(7, 6774169397346542505),
            name: 'starred',
            type: 1,
            flags: 0),
        ModelProperty(
            id: const IdUid(8, 7221060550241170408),
            name: 'feeling',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(9, 4952094039664744075),
            name: 'createdAt',
            type: 10,
            flags: 0),
        ModelProperty(
            id: const IdUid(10, 4961981479060558999),
            name: 'updatedAt',
            type: 10,
            flags: 0),
        ModelProperty(
            id: const IdUid(11, 9125848120865526787),
            name: 'movedToBinAt',
            type: 10,
            flags: 0),
        ModelProperty(
            id: const IdUid(12, 5871534476772289101),
            name: 'changes',
            type: 30,
            flags: 0),
        ModelProperty(
            id: const IdUid(13, 6005849190320169908),
            name: 'tags',
            type: 30,
            flags: 0),
        ModelProperty(
            id: const IdUid(17, 8623820136669220816),
            name: 'metadata',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(18, 1429297690659026930),
            name: 'hour',
            type: 6,
            flags: 0),
        ModelProperty(
            id: const IdUid(19, 862060011000399226),
            name: 'minute',
            type: 6,
            flags: 0),
        ModelProperty(
            id: const IdUid(20, 4113637293536721721),
            name: 'second',
            type: 6,
            flags: 0)
      ],
      relations: <ModelRelation>[],
      backlinks: <ModelBacklink>[]),
  ModelEntity(
      id: const IdUid(2, 5548558812249966101),
      name: 'TagObjectBox',
      lastPropertyId: const IdUid(8, 6011272584059291333),
      flags: 0,
      properties: <ModelProperty>[
        ModelProperty(
            id: const IdUid(1, 5046052891972916251),
            name: 'id',
            type: 6,
            flags: 129),
        ModelProperty(
            id: const IdUid(2, 8744880092533568590),
            name: 'title',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(3, 7863427692914238443),
            name: 'version',
            type: 6,
            flags: 0),
        ModelProperty(
            id: const IdUid(4, 6417690656797806340),
            name: 'starred',
            type: 1,
            flags: 0),
        ModelProperty(
            id: const IdUid(5, 3138951263147849158),
            name: 'emoji',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(6, 3746821438504660808),
            name: 'createdAt',
            type: 10,
            flags: 0),
        ModelProperty(
            id: const IdUid(7, 4116584270770327746),
            name: 'updatedAt',
            type: 10,
            flags: 0),
        ModelProperty(
            id: const IdUid(8, 6011272584059291333),
            name: 'index',
            type: 6,
            flags: 0)
      ],
      relations: <ModelRelation>[],
      backlinks: <ModelBacklink>[])
];

/// Open an ObjectBox store with the model declared in this file.
Future<Store> openStore(
        {String? directory,
        int? maxDBSizeInKB,
        int? fileMode,
        int? maxReaders,
        bool queriesCaseSensitiveDefault = true,
        String? macosApplicationGroup}) async =>
    Store(getObjectBoxModel(),
        directory: directory ?? (await defaultStoreDirectory()).path,
        maxDBSizeInKB: maxDBSizeInKB,
        fileMode: fileMode,
        maxReaders: maxReaders,
        queriesCaseSensitiveDefault: queriesCaseSensitiveDefault,
        macosApplicationGroup: macosApplicationGroup);

/// ObjectBox model definition, pass it to [Store] - Store(getObjectBoxModel())
ModelDefinition getObjectBoxModel() {
  final model = ModelInfo(
      entities: _entities,
      lastEntityId: const IdUid(2, 5548558812249966101),
      lastIndexId: const IdUid(0, 0),
      lastRelationId: const IdUid(0, 0),
      lastSequenceId: const IdUid(0, 0),
      retiredEntityUids: const [],
      retiredIndexUids: const [],
      retiredPropertyUids: const [
        7351525936100002271,
        3655265263412929559,
        4968158570417504072
      ],
      retiredRelationUids: const [],
      modelVersion: 5,
      modelVersionParserMinimum: 5,
      version: 1);

  final bindings = <Type, EntityDefinition>{
    StoryObjectBox: EntityDefinition<StoryObjectBox>(
        model: _entities[0],
        toOneRelations: (StoryObjectBox object) => [],
        toManyRelations: (StoryObjectBox object) => {},
        getId: (StoryObjectBox object) => object.id,
        setId: (StoryObjectBox object, int id) {
          object.id = id;
        },
        objectToFB: (StoryObjectBox object, fb.Builder fbb) {
          final typeOffset = fbb.writeString(object.type);
          final feelingOffset =
              object.feeling == null ? null : fbb.writeString(object.feeling!);
          final changesOffset = fbb.writeList(
              object.changes.map(fbb.writeString).toList(growable: false));
          final tagsOffset = object.tags == null
              ? null
              : fbb.writeList(
                  object.tags!.map(fbb.writeString).toList(growable: false));
          final metadataOffset = object.metadata == null
              ? null
              : fbb.writeString(object.metadata!);
          fbb.startTable(21);
          fbb.addInt64(0, object.id);
          fbb.addInt64(1, object.version);
          fbb.addOffset(2, typeOffset);
          fbb.addInt64(3, object.year);
          fbb.addInt64(4, object.month);
          fbb.addInt64(5, object.day);
          fbb.addBool(6, object.starred);
          fbb.addOffset(7, feelingOffset);
          fbb.addInt64(8, object.createdAt.millisecondsSinceEpoch);
          fbb.addInt64(9, object.updatedAt.millisecondsSinceEpoch);
          fbb.addInt64(10, object.movedToBinAt?.millisecondsSinceEpoch);
          fbb.addOffset(11, changesOffset);
          fbb.addOffset(12, tagsOffset);
          fbb.addOffset(16, metadataOffset);
          fbb.addInt64(17, object.hour);
          fbb.addInt64(18, object.minute);
          fbb.addInt64(19, object.second);
          fbb.finish(fbb.endTable());
          return object.id;
        },
        objectFromFB: (Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);
          final movedToBinAtValue =
              const fb.Int64Reader().vTableGetNullable(buffer, rootOffset, 24);
          final object = StoryObjectBox(
              id: const fb.Int64Reader().vTableGet(buffer, rootOffset, 4, 0),
              version:
                  const fb.Int64Reader().vTableGet(buffer, rootOffset, 6, 0),
              type: const fb.StringReader(asciiOptimization: true)
                  .vTableGet(buffer, rootOffset, 8, ''),
              year: const fb.Int64Reader().vTableGet(buffer, rootOffset, 10, 0),
              month:
                  const fb.Int64Reader().vTableGet(buffer, rootOffset, 12, 0),
              day: const fb.Int64Reader().vTableGet(buffer, rootOffset, 14, 0),
              hour: const fb.Int64Reader()
                  .vTableGetNullable(buffer, rootOffset, 38),
              minute: const fb.Int64Reader()
                  .vTableGetNullable(buffer, rootOffset, 40),
              second: const fb.Int64Reader()
                  .vTableGetNullable(buffer, rootOffset, 42),
              starred: const fb.BoolReader()
                  .vTableGetNullable(buffer, rootOffset, 16),
              feeling: const fb.StringReader(asciiOptimization: true)
                  .vTableGetNullable(buffer, rootOffset, 18),
              createdAt: DateTime.fromMillisecondsSinceEpoch(
                  const fb.Int64Reader().vTableGet(buffer, rootOffset, 20, 0)),
              updatedAt: DateTime.fromMillisecondsSinceEpoch(
                  const fb.Int64Reader().vTableGet(buffer, rootOffset, 22, 0)),
              movedToBinAt: movedToBinAtValue == null ? null : DateTime.fromMillisecondsSinceEpoch(movedToBinAtValue),
              changes: const fb.ListReader<String>(fb.StringReader(asciiOptimization: true), lazy: false).vTableGet(buffer, rootOffset, 26, []),
              tags: const fb.ListReader<String>(fb.StringReader(asciiOptimization: true), lazy: false).vTableGetNullable(buffer, rootOffset, 28),
              metadata: const fb.StringReader(asciiOptimization: true).vTableGetNullable(buffer, rootOffset, 36));

          return object;
        }),
    TagObjectBox: EntityDefinition<TagObjectBox>(
        model: _entities[1],
        toOneRelations: (TagObjectBox object) => [],
        toManyRelations: (TagObjectBox object) => {},
        getId: (TagObjectBox object) => object.id,
        setId: (TagObjectBox object, int id) {
          object.id = id;
        },
        objectToFB: (TagObjectBox object, fb.Builder fbb) {
          final titleOffset = fbb.writeString(object.title);
          final emojiOffset =
              object.emoji == null ? null : fbb.writeString(object.emoji!);
          fbb.startTable(9);
          fbb.addInt64(0, object.id);
          fbb.addOffset(1, titleOffset);
          fbb.addInt64(2, object.version);
          fbb.addBool(3, object.starred);
          fbb.addOffset(4, emojiOffset);
          fbb.addInt64(5, object.createdAt.millisecondsSinceEpoch);
          fbb.addInt64(6, object.updatedAt.millisecondsSinceEpoch);
          fbb.addInt64(7, object.index);
          fbb.finish(fbb.endTable());
          return object.id;
        },
        objectFromFB: (Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);

          final object = TagObjectBox(
              id: const fb.Int64Reader().vTableGet(buffer, rootOffset, 4, 0),
              title: const fb.StringReader(asciiOptimization: true)
                  .vTableGet(buffer, rootOffset, 6, ''),
              index: const fb.Int64Reader()
                  .vTableGetNullable(buffer, rootOffset, 18),
              version:
                  const fb.Int64Reader().vTableGet(buffer, rootOffset, 8, 0),
              starred: const fb.BoolReader()
                  .vTableGetNullable(buffer, rootOffset, 10),
              emoji: const fb.StringReader(asciiOptimization: true)
                  .vTableGetNullable(buffer, rootOffset, 12),
              createdAt: DateTime.fromMillisecondsSinceEpoch(
                  const fb.Int64Reader().vTableGet(buffer, rootOffset, 14, 0)),
              updatedAt: DateTime.fromMillisecondsSinceEpoch(
                  const fb.Int64Reader().vTableGet(buffer, rootOffset, 16, 0)));

          return object;
        })
  };

  return ModelDefinition(model, bindings);
}

/// [StoryObjectBox] entity fields to define ObjectBox queries.
class StoryObjectBox_ {
  /// see [StoryObjectBox.id]
  static final id =
      QueryIntegerProperty<StoryObjectBox>(_entities[0].properties[0]);

  /// see [StoryObjectBox.version]
  static final version =
      QueryIntegerProperty<StoryObjectBox>(_entities[0].properties[1]);

  /// see [StoryObjectBox.type]
  static final type =
      QueryStringProperty<StoryObjectBox>(_entities[0].properties[2]);

  /// see [StoryObjectBox.year]
  static final year =
      QueryIntegerProperty<StoryObjectBox>(_entities[0].properties[3]);

  /// see [StoryObjectBox.month]
  static final month =
      QueryIntegerProperty<StoryObjectBox>(_entities[0].properties[4]);

  /// see [StoryObjectBox.day]
  static final day =
      QueryIntegerProperty<StoryObjectBox>(_entities[0].properties[5]);

  /// see [StoryObjectBox.starred]
  static final starred =
      QueryBooleanProperty<StoryObjectBox>(_entities[0].properties[6]);

  /// see [StoryObjectBox.feeling]
  static final feeling =
      QueryStringProperty<StoryObjectBox>(_entities[0].properties[7]);

  /// see [StoryObjectBox.createdAt]
  static final createdAt =
      QueryIntegerProperty<StoryObjectBox>(_entities[0].properties[8]);

  /// see [StoryObjectBox.updatedAt]
  static final updatedAt =
      QueryIntegerProperty<StoryObjectBox>(_entities[0].properties[9]);

  /// see [StoryObjectBox.movedToBinAt]
  static final movedToBinAt =
      QueryIntegerProperty<StoryObjectBox>(_entities[0].properties[10]);

  /// see [StoryObjectBox.changes]
  static final changes =
      QueryStringVectorProperty<StoryObjectBox>(_entities[0].properties[11]);

  /// see [StoryObjectBox.tags]
  static final tags =
      QueryStringVectorProperty<StoryObjectBox>(_entities[0].properties[12]);

  /// see [StoryObjectBox.metadata]
  static final metadata =
      QueryStringProperty<StoryObjectBox>(_entities[0].properties[13]);

  /// see [StoryObjectBox.hour]
  static final hour =
      QueryIntegerProperty<StoryObjectBox>(_entities[0].properties[14]);

  /// see [StoryObjectBox.minute]
  static final minute =
      QueryIntegerProperty<StoryObjectBox>(_entities[0].properties[15]);

  /// see [StoryObjectBox.second]
  static final second =
      QueryIntegerProperty<StoryObjectBox>(_entities[0].properties[16]);
}

/// [TagObjectBox] entity fields to define ObjectBox queries.
class TagObjectBox_ {
  /// see [TagObjectBox.id]
  static final id =
      QueryIntegerProperty<TagObjectBox>(_entities[1].properties[0]);

  /// see [TagObjectBox.title]
  static final title =
      QueryStringProperty<TagObjectBox>(_entities[1].properties[1]);

  /// see [TagObjectBox.version]
  static final version =
      QueryIntegerProperty<TagObjectBox>(_entities[1].properties[2]);

  /// see [TagObjectBox.starred]
  static final starred =
      QueryBooleanProperty<TagObjectBox>(_entities[1].properties[3]);

  /// see [TagObjectBox.emoji]
  static final emoji =
      QueryStringProperty<TagObjectBox>(_entities[1].properties[4]);

  /// see [TagObjectBox.createdAt]
  static final createdAt =
      QueryIntegerProperty<TagObjectBox>(_entities[1].properties[5]);

  /// see [TagObjectBox.updatedAt]
  static final updatedAt =
      QueryIntegerProperty<TagObjectBox>(_entities[1].properties[6]);

  /// see [TagObjectBox.index]
  static final index =
      QueryIntegerProperty<TagObjectBox>(_entities[1].properties[7]);
}
