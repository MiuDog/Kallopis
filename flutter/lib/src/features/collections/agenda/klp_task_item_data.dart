/// Kallopis 專案模組。
library;

import 'package:flutter/foundation.dart';

/// 待辦項目的視圖資料契約。
@immutable
class KlpTaskItemData {
  const KlpTaskItemData({
    this.id = '',
    required this.title,
    required this.detail,
    this.checked = false,
  });

  final String id;
  final String title;
  final String detail;
  final bool checked;
}
