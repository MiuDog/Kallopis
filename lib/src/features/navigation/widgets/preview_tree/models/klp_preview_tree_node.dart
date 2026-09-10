import 'package:flutter/foundation.dart';

/// 尚未成為 canonical artifact 的預覽樹節點。
@immutable
class KlpPreviewTreeNode {
  const KlpPreviewTreeNode({
    required this.id,
    required this.label,
    required this.accessibilityLabel,
    this.children = const [],
    this.statusLabel,
  });

  final String id;
  final String label;
  final String accessibilityLabel;
  final List<KlpPreviewTreeNode> children;
  final String? statusLabel;
}
