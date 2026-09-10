import 'package:flutter/foundation.dart';

/// 日期格內容；只描述顯示資料，不擁有行事曆領域規則。
@immutable
class KlpDateGridItem {
  const KlpDateGridItem({
    required this.label,
    this.lines = const [],
    this.selected = false,
  });

  final String label;
  final List<String> lines;
  final bool selected;
}
