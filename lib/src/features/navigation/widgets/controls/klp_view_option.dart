import 'package:flutter/widgets.dart';

import '../../../../foundation/klp_icon_data.dart';

/// 檢視切換器的一個識別、標籤與可選圖示。
@immutable
class KlpViewOption {
  const KlpViewOption({required this.id, required this.label, this.icon});

  final String id;
  final String label;
  final KlpIconData? icon;
}
