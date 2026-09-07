import 'package:flutter/widgets.dart';

/// 狀態語意種類。所有種類統一以純色圓點呈現，種類只負責解析預設顏色。
enum KlpStatusKind { dot, running, splitDot, check, cross, waiting, circle }

/// 一個可注入至側欄或狀態列的產品中立狀態項目。
@immutable
class KlpStatusItemData {
  const KlpStatusItemData({
    required this.label,
    this.kind = KlpStatusKind.dot,
    this.active = true,
    this.color,
    this.showsIndicator = true,
  });

  final String label;
  final KlpStatusKind kind;
  final bool active;
  final Color? color;
  final bool showsIndicator;
}

/// Stage 底部狀態列的資料模型。
///
/// 左右群組都可提供多個狀態項目；窄版會保留左側群組並隱藏右側群組。
@immutable
class KlpStatusBarData {
  const KlpStatusBarData({required this.leading, this.trailing = const []});

  final List<KlpStatusItemData> leading;
  final List<KlpStatusItemData> trailing;
}
