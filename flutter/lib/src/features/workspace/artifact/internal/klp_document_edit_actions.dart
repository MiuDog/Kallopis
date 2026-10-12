part of '../klp_artifact_workspace.dart';

/// 文件的進入編輯、儲存與取消動作組。
class KlpDocumentEditActions extends StatelessWidget {
  const KlpDocumentEditActions({
    super.key,
    required this.editing,
    required this.editLabel,
    required this.saveLabel,
    required this.cancelLabel,
    this.onEdit,
    this.onSave,
    this.onCancel,
  });

  final bool editing;
  final String editLabel;
  final String saveLabel;
  final String cancelLabel;
  final VoidCallback? onEdit;
  final VoidCallback? onSave;
  final VoidCallback? onCancel;

  @override
  Widget build(BuildContext context) {
    return KlpWrap(
      spacingSize: KlpSpaceSize.tight,
      children: editing
          ? [
              KlpButton(label: saveLabel, onPressed: onSave),
              KlpButton(
                label: cancelLabel,
                tone: KlpButtonTone.ghost,
                onPressed: onCancel,
              ),
            ]
          : [KlpButton(label: editLabel, onPressed: onEdit)],
    );
  }
}
