part of '../../databases/story_database.dart';

class _StoryFileDbAdapter extends BaseFileDbAdapter {
  _StoryFileDbAdapter(String tableName) : super(tableName);

  String dirPath({
    required String? type,
  }) {
    String prefix = "database/file";

    String path = [
      FileHelper.directory.absolute.path,
      prefix,
      tableName,
      if (type != null) type,
    ].join("/");

    return path;
  }

  Future<Directory> buildDir({
    required String? type,
  }) async {
    Directory directory = Directory(dirPath(type: type));
    await ensureDirExist(directory);
    return directory;
  }

  Future<File> buildFile({
    required String year,
    required String month,
    required String day,
    required String type,
    required DateTime createdAt,
  }) async {
    Directory prefix = await buildDir(type: type);

    String path = [
      prefix.path,
      year,
      month,
      day,
      createdAt.millisecondsSinceEpoch.toString() + ".json",
    ].join("/");

    File file = File(path);
    await ensureFileExist(file);
    return file;
  }

  @override
  Future<Map<String, dynamic>?> create({
    Map<String, dynamic> body = const {},
    Map<String, dynamic> params = const {},
  }) async {
    StoryDbModel story = StoryDbModel.fromJson(body);
    String json = AppHelper.prettifyJson(story.toJson());

    File file = await buildFile(
      year: story.year.toString(),
      month: story.month.toString(),
      day: story.day.toString(),
      type: story.type.name,
      createdAt: story.createdAt,
    );

    file = await file.writeAsString(json);
    return fetchOne(id: story.id.toString());
  }

  @override
  Future<Map<String, dynamic>?> delete({
    required String id,
    Map<String, dynamic> params = const {},
  }) async {
    Directory directory = await buildDir(type: null);
    List<FileSystemEntity> list = directory.listSync(recursive: true);
    for (FileSystemEntity element in list) {
      if (element.path.endsWith(id + ".json") && element is File) {
        await element.delete();
      }
    }
    return fetchOne(id: id);
  }

  @override
  Future<Map<String, dynamic>?> fetchAll({
    Map<String, dynamic>? params,
  }) async {
    String type = params?["type"];
    int? year = params?["year"];
    int? month = params?["month"];
    int? day = params?["day"];

    Directory prefix = await buildDir(type: type);

    List<String> paths = [
      prefix.path,
      if (year != null) "$year",
      if (month != null) "$month",
      if (day != null) "$day",
    ];

    String path = paths.join("/");
    Directory directory = Directory(path);

    if (directory.existsSync()) {
      List<FileSystemEntity> entities = directory.listSync(recursive: true);
      List<Map<String, dynamic>> docs = [];

      for (FileSystemEntity item in entities) {
        if (item is File && item.absolute.path.endsWith(".json")) {
          Map<String, dynamic>? json = await fetchOne(id: item.path, params: {"file": item});
          if (json != null) docs.add(json);
        }
      }

      return {
        "items": docs,
        "meta": MetaModel().toJson(),
        "links": MetaModel().toJson(),
      };
    }

    return null;
  }

  @override
  Future<Map<String, dynamic>?> fetchOne({
    required String id,
    Map<String, dynamic>? params,
  }) async {
    File? file = params?['file'];

    // id is unnecessary when file != null
    if (file != null) {
      String result = await file.readAsString();
      dynamic json = jsonDecode(result);
      if (json is Map<String, dynamic>) return json;
    } else {
      Directory directory = await buildDir(type: null);
      List<FileSystemEntity> list = directory.listSync(recursive: true);

      for (FileSystemEntity file in list) {
        if (file.path.endsWith(id + ".json") && file is File) {
          String result = await file.readAsString();
          dynamic json = jsonDecode(result);
          if (json is Map<String, dynamic>) return json;
        }
      }
    }

    return null;
  }

  @override
  Future<Map<String, dynamic>?> update({
    @Deprecated("ID is not neccessary in file") required String id,
    Map<String, dynamic> body = const {},
    Map<String, dynamic> params = const {},
  }) async {
    return create(body: body, params: params);
  }

  Future<Set<int>?> fetchYears() async {
    Directory docsPath = Directory(dirPath(type: PathType.docs.name));
    if (await docsPath.exists()) {
      await ensureDirExist(docsPath);

      List<FileSystemEntity> result = docsPath.listSync();
      Set<String> years = result.map((e) {
        return e.absolute.path.split("/").last;
      }).toSet();

      Set<int> yearsInt = {};
      for (String e in years) {
        int? y = int.tryParse(e);
        if (y != null) yearsInt.add(y);
      }

      return yearsInt;
    }
    return null;
  }

  int getDocsCount(int? year) {
    Directory docsPath = Directory(
      dirPath(type: year != null ? PathType.docs.name + "/$year" : PathType.docs.name),
    );

    if (docsPath.existsSync()) {
      List<FileSystemEntity> result = docsPath.listSync(recursive: true);
      return result.where((e) {
        return e is File && e.path.endsWith(AppConstant.documentExstension);
      }).length;
    }

    return 0;
  }
}
