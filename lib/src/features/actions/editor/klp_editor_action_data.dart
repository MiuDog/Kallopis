part of 'klp_editor_action_bars.dart';

/// 編輯器動作列投影的一筆中性動作資料。
@immutable
class KlpEditorActionData {
  const KlpEditorActionData({
    required this.label,
    required this.onPressed,
    this.selected = false,
    this.danger = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool selected;
  final bool danger;
}
