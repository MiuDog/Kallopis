/// Kallopis 專案模組。
library;

import 'package:flutter/widgets.dart';
import 'klp_status_item_data.dart';

/// Stage 底部狀態列的資料模型。
///
/// 左右群組都可提供多個狀態項目；窄版會保留左側群組並隱藏右側群組。
@immutable
class KlpStatusBarData {
  const KlpStatusBarData({required this.leading, this.trailing = const []});

  final List<KlpStatusItemData> leading;
  final List<KlpStatusItemData> trailing;
}
