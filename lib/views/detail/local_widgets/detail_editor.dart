import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as editor;
import 'package:spooky/theme/m3/m3_color.dart';
import 'package:spooky/utils/constants/config_constant.dart';
import 'package:spooky/utils/mixins/stateful_mixin.dart';

class DetailEditor extends StatefulWidget {
  const DetailEditor({
    Key? key,
    required this.document,
    required this.readOnlyNotifier,
    required this.onControllerReady,
    required this.onFocusNodeReady,
    required this.onChange,
  }) : super(key: key);

  final List<dynamic>? document;
  final ValueNotifier<bool> readOnlyNotifier;
  final void Function(editor.QuillController controller) onControllerReady;
  final void Function(FocusNode focusNode) onFocusNodeReady;
  final void Function(editor.Document document) onChange;

  @override
  State<DetailEditor> createState() => _DetailEditorState();
}

class _DetailEditorState extends State<DetailEditor> with StatefulMixin, AutomaticKeepAliveClientMixin {
  late editor.QuillController controller;
  late ScrollController scrollController;
  late FocusNode focusNode;

  @override
  void initState() {
    controller = _getDocumentController();
    scrollController = ScrollController();
    focusNode = FocusNode();
    super.initState();

    widget.onControllerReady(controller);
    widget.onFocusNodeReady(focusNode);

    controller.addListener(() {
      if (mounted) {
        widget.onChange(controller.document);
      }
    });
  }

  editor.QuillController _getDocumentController() {
    try {
      if (widget.document != null && widget.document?.isNotEmpty == true) {
        return editor.QuillController(
          document: editor.Document.fromJson(widget.document!),
          selection: const TextSelection.collapsed(offset: 0),
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print("ERROR: _getDocumentController $e");
      }
    }
    return editor.QuillController.basic();
  }

  @override
  void dispose() {
    controller.dispose();
    scrollController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ValueListenableBuilder<bool>(
      valueListenable: widget.readOnlyNotifier,
      builder: (context, value, child) {
        return editor.QuillEditor(
          controller: controller,
          scrollController: scrollController,
          scrollable: true,
          focusNode: focusNode,
          autoFocus: false,
          readOnly: widget.readOnlyNotifier.value,
          expands: false,
          padding: const EdgeInsets.all(ConfigConstant.margin2).copyWith(
            top: ConfigConstant.margin2 + 8.0,
            bottom: kToolbarHeight + MediaQuery.of(context).viewPadding.bottom + ConfigConstant.margin2,
          ),
          keyboardAppearance: M3Color.keyboardAppearance(context),
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
