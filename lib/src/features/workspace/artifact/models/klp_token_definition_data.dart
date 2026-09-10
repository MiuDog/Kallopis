part of '../klp_artifact_workspace.dart';

/// 一筆產品中立的 Token 呈現資料。
@immutable
class KlpTokenDefinitionData {
  const KlpTokenDefinitionData({
    required this.name,
    required this.typeLabel,
    required this.valueLabel,
    required this.statusLabel,
    this.referenceLabel,
    this.preview,
  });

  final String name;
  final String typeLabel;
  final String valueLabel;
  final String statusLabel;
  final String? referenceLabel;
  final Widget? preview;
}
