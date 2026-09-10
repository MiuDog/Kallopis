part of 'klp_finite_workflow.dart';

/// 一個具名稱的工作流階段，不使用虛構的時間估算。
@immutable
class KlpWorkflowStageData {
  const KlpWorkflowStageData({
    required this.label,
    required this.statusLabel,
    required this.complete,
    this.active = false,
  });

  final String label;
  final String statusLabel;
  final bool complete;
  final bool active;
}
