/// Kallopis 專案模組。
library;

import 'package:flutter/widgets.dart';
import 'klp_status_kind.dart';

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
