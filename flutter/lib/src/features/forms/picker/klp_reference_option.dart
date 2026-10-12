import 'package:flutter/foundation.dart';

/// 參照選擇器投影的一筆中性選項資料。
@immutable
class KlpReferenceOption {
  const KlpReferenceOption({
    required this.id,
    required this.label,
    this.kind,
    this.metadata,
    this.disabled = false,
  });

  final String id;
  final String label;
  final String? kind;
  final String? metadata;
  final bool disabled;
}
