part of '../klp_artifact_workspace.dart';

/// 一個元件定義的產品中立預覽資料。
@immutable
class KlpComponentDefinitionData {
  const KlpComponentDefinitionData({
    required this.id,
    required this.name,
    required this.statusLabel,
    required this.preview,
    this.description,
  });

  final String id;
  final String name;
  final String statusLabel;
  final String? description;
  final Widget preview;
}
