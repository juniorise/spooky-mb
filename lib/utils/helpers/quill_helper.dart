// ignore_for_file: implementation_imports

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/src/models/documents/attribute.dart' as attribute;
import 'package:flutter_quill/src/models/documents/nodes/block.dart' as block;
import 'package:flutter_quill/src/models/documents/nodes/node.dart' as node;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_quill/src/widgets/embeds/image.dart';
import 'dart:convert';

class QuillHelper {
  static List<String> imagesFromJson(List document) {
    List<String> images = [];
    try {
      for (dynamic e in document) {
        final insert = e['insert'];
        if (insert is Map) {
          for (MapEntry<dynamic, dynamic> e in insert.entries) {
            if (e.value != null && e.value.isNotEmpty) {
              images.add(e.value);
            }
          }
        }
      }
    } catch (e) {
      if (kDebugMode) {
        rethrow;
      }
    }
    return images;
  }

  static String toPlainText(node.Root root) {
    String plainText = root.children.map((node.Node e) {
      final atts = e.style.attributes;
      attribute.Attribute? att = atts['list'] ?? atts['blockquote'] ?? atts['code-block'];

      if (e is block.Block) {
        int index = 0;
        String result = "";
        for (node.Node entry in e.children) {
          if (att?.key == "blockquote") {
            String text = entry.toPlainText();
            text = text.replaceFirst(RegExp('\n'), '', text.length - 1);
            result += "\n> $text";
          } else if (att?.key == "code-block") {
            result += '```\n${entry.toPlainText()}\n```';
          } else {
            if (att?.value == "checked") {
              result += '- [x] ${entry.toPlainText()}';
            } else if (att?.value == "unchecked") {
              result += "- [ ] ${entry.toPlainText()}";
            } else if (att?.value == "ordered") {
              index++;
              result += "$index. ${entry.toPlainText()}";
            } else if (att?.value == "bullet") {
              result += "- ${entry.toPlainText()}";
            }
          }
        }
        return result;
      } else {
        return e.toPlainText();
      }
    }).join();

    // replace all image object to empty
    plainText = plainText.replaceAll("\uFFFC", "");
    return plainText.length > 200 ? "${plainText.substring(0, 200)}..." : plainText;
  }

  static ImageProvider? imageByUrl(String imageUrl) {
    if (isImageBase64(imageUrl)) return MemoryImage(base64.decode(imageUrl));
    if (imageUrl.startsWith('http')) return CachedNetworkImageProvider(imageUrl);
    if (File(imageUrl).existsSync()) return FileImage(File(imageUrl));
    return null;
  }
}
