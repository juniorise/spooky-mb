part of manage_pages_view;

class _ManagePagesMobile extends StatelessWidget {
  final ManagePagesViewModel viewModel;
  const _ManagePagesMobile(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => onWillPop(context),
      child: Scaffold(
        appBar: AppBar(
          leading: const SpPopButton(),
          title: Text("Manage Page", style: Theme.of(context).appBarTheme.titleTextStyle),
          actions: buildActionsButton(context),
        ),
        body: buildPagesList(),
      ),
    );
  }

  Future<bool> onWillPop(BuildContext context) async {
    if (viewModel.hasChangeNotifier.value) {
      OkCancelResult result = await showOkCancelAlertDialog(
        context: context,
        title: "Discard changes?",
        message: "All changes will be lost",
        isDestructiveAction: false,
        barrierDismissible: true,
      );
      switch (result) {
        case OkCancelResult.ok:
          return true;
        case OkCancelResult.cancel:
          return false;
      }
    }
    return true;
  }

  List<Widget> buildActionsButton(BuildContext context) {
    return [
      ValueListenableBuilder(
        valueListenable: viewModel.hasChangeNotifier,
        builder: (context, value, child) {
          return SpAnimatedIcons(
            showFirst: viewModel.hasChangeNotifier.value,
            firstChild: Center(
              key: ValueKey(Icons.refresh_outlined),
              child: SpIconButton(
                icon: Icon(Icons.refresh_outlined),
                onPressed: () => viewModel.reload(),
              ),
            ),
            secondChild: SizedBox.shrink(key: ValueKey("SizeBox")),
          );
        },
      ),
      ValueListenableBuilder(
        valueListenable: viewModel.hasChangeNotifier,
        builder: (context, value, child) {
          return SpAnimatedIcons(
            firstChild: Center(
              key: ValueKey(Icons.save),
              child: SpIconButton(
                icon: Icon(Icons.save),
                onPressed: () async {
                  bool hasDeleteSomePage = viewModel.content.pages?.length != viewModel.documents.length;
                  OkCancelResult result = await showOkCancelAlertDialog(
                    context: context,
                    title: "Are you sure to save changes?",
                    message: hasDeleteSomePage ? "You can't undo this action" : null,
                    barrierDismissible: true,
                    isDestructiveAction: hasDeleteSomePage,
                    okLabel: MaterialLocalizations.of(context).saveButtonLabel.toLowerCase().capitalize,
                  );
                  switch (result) {
                    case OkCancelResult.ok:
                      WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
                        context.router.popForced(viewModel.save());
                      });
                      break;
                    case OkCancelResult.cancel:
                      break;
                  }
                },
              ),
            ),
            secondChild: SizedBox.shrink(key: ValueKey("SizeBox")),
            showFirst: viewModel.hasChangeNotifier.value,
          );
        },
      ),
    ];
  }

  Widget buildPagesList() {
    return ReorderableListView.builder(
      itemCount: viewModel.documents.length,
      onReorder: viewModel.reordered,
      itemBuilder: (context, index) {
        DocumentKeyModel? item = AppHelper.listItem(viewModel.documents, index);
        if (item == null) return SizedBox.shrink(key: ValueKey(item?.key));
        return buildDimssiableItem(
          item: item,
          context: context,
          index: index,
          child: buildChild(item),
        );
      },
    );
  }

  Widget buildChild(DocumentKeyModel item) {
    String text = item.document.toPlainText().trim();
    return Column(
      children: [
        ListTile(
          title: Text(item.key.toString()),
          subtitle: text.isEmpty ? null : Text(text, maxLines: 1),
          trailing: Icon(Icons.reorder),
        ),
        const Divider(height: 0)
      ],
    );
  }

  Widget buildDimssiableItem({
    required DocumentKeyModel item,
    required BuildContext context,
    required int index,
    required Widget child,
  }) {
    return Dismissible(
      key: ValueKey(item.key),
      secondaryBackground: SpDimissableBackground(
        alignment: Alignment.centerRight,
        backgroundColor: M3Color.of(context).error,
        foregroundColor: M3Color.of(context).onError,
        iconData: Icons.delete,
        iconSize: ConfigConstant.iconSize2,
        shouldAnimatedIcon: false,
      ),
      onDismissed: (direction) => viewModel.updateUnfinishState(),
      background: SpDimissableBackground(
        alignment: Alignment.centerLeft,
        backgroundColor: M3Color.of(context).error,
        foregroundColor: M3Color.of(context).onError,
        iconData: Icons.delete,
        iconSize: ConfigConstant.iconSize2,
        shouldAnimatedIcon: false,
      ),
      confirmDismiss: (direction) async {
        bool success = viewModel.deleteAt(index);
        if (!success) App.of(context)?.showSpSnackBar("Pages can't be less than 1");
        return success;
      },
      child: child,
    );
  }
}