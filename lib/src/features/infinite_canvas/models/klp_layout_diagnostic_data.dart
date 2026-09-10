part of '../klp_canvas_workspace.dart';

/// Layout Lens 的單一診斷項目。
@immutable
class KlpLayoutDiagnosticData {
  const KlpLayoutDiagnosticData({
    required this.label,
    required this.value,
    this.tone = KlpFeedbackTone.neutral,
  });

  final String label;
  final String value;
  final KlpFeedbackTone tone;
}
