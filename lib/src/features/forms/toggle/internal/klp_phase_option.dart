part of '../klp_phase_toggle.dart';

/// 階段選項資料。包含選項值、文字標籤或圖示，與啟用時的語意色調。
@immutable
class KlpPhaseOption<T> {
  const KlpPhaseOption({
    required this.value,
    this.label,
    this.icon,
    this.activeTone,
  }) : assert(label != null || icon != null, 'Must provide label or icon');

  final T value;
  final String? label;
  final KlpIconData? icon;
  final KlpFeedbackTone? activeTone;
}
