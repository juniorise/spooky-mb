import 'dart:convert';

import 'package:flutter_quill/flutter_quill.dart';

class DateBlockEmbed extends CustomBlockEmbed {
  static const String blockType = 'date';

  const DateBlockEmbed(String value) : super(blockType, value);
  static DateBlockEmbed fromDocument(Document document) {
    return DateBlockEmbed(
      jsonEncode(document.toDelta().toJson()),
    );
  }

  Document get document {
    return Document.fromJson(jsonDecode(data));
  }
}
