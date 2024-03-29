part of security_service;

abstract class _BaseLockService<T extends _BaseLockOptions> {
  Future<bool> unlock(T option);
  Future<bool> set(T option);
  Future<bool> remove(T option);

  Widget buildFooter(BuildContext context) {
    return Theme(
      data: Theme.of(App.navigatorKey.currentContext ?? context),
      child: Padding(
        padding: const EdgeInsets.only(top: 16.0),
        child: SpButton(
          backgroundColor: M3Color.of(context).readOnly.surface1,
          foregroundColor: M3Color.of(context).onSurface,
          label: tr("button.no_longer_access"),
          onTap: () => clearLockWithSecurityQuestions(context),
        ),
      ),
    );
  }

  Future<void> clearLockWithSecurityQuestions(BuildContext context) async {
    SecurityQuestionListModel? result = await SecurityQuestionsStorage().readObject();
    List<SecurityQuestionModel> items = result?.items ?? [];
    items = items.where((element) => element.answer != null).toList();

    if (items.isEmpty) {
      MessengerService.instance.showSnackBar(
        tr("msg.no_security_questions"),
        success: false,
      );
      return;
    }

    String? questionKey = await showModalActionSheet(
      context: context,
      title: tr("alert.answer_to_unlock.title"),
      cancelLabel: tr("button.cancel"),
      actions: items.map((e) {
        return SheetAction(
          label: e.question,
          key: e.key,
          icon: CommunityMaterialIcons.lock_question,
        );
      }).toList(),
    );

    if (questionKey == null) return;
    SecurityQuestionModel question = items.where((element) => questionKey == element.key).first;
    List<String>? answers = await showTextInputDialog(
      context: context,
      title: question.question,
      okLabel: tr("button.ok"),
      cancelLabel: tr("button.cancel"),
      textFields: const [
        DialogTextField(),
      ],
    );

    if (answers == null || answers.isEmpty) return;
    String answer = answers[0];
    double similarity = answer.toLowerCase().similarityTo(question.answer?.toLowerCase());

    if (similarity > 0.8) {
      SecurityService._lockInfo.clear();
      MessengerService.instance.showSnackBar(
        tr("msg.security.match_cleared", args: [(similarity * 100).toStringAsFixed(2)]),
        success: true,
      );
      Navigator.of(context).pop(true);
    } else {
      MessengerService.instance.showSnackBar(
        tr("msg.security.incorrect_answer"),
        success: false,
      );
    }
  }
}
