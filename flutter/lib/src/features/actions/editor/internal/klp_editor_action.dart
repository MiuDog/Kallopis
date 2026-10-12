part of '../klp_editor_action_bars.dart';

/// 僅供編輯器動作列組裝使用的單一動作。
class _KlpEditorAction extends StatelessWidget {
  const _KlpEditorAction({required this.data});

  final KlpEditorActionData data;

  @override
  Widget build(BuildContext context) {
    final tone = data.danger
        ? KlpTextTone.danger
        : data.onPressed == null
        ? KlpTextTone.faint
        : KlpTextTone.primary;

    return _KlpEditorActionFrame(
      selected: data.selected,
      onPressed: data.onPressed,
      child: KlpText(data.label, role: KlpTextRole.code, tone: tone),
    );
  }
}
