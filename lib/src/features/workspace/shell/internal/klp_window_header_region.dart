/// Kallopis 專案模組。
library;

import 'package:flutter/widgets.dart';
import '../../../../foundation/layout/klp_row.dart';

/// 建立可保留自然寬度，並在空間不足時依方向裁切的標題列區域。
Widget buildKlpWindowHeaderRegion({
  required List<Widget> children,
  required AlignmentGeometry alignment,
}) {
  return ClipRect(
    child: IntrinsicWidth(
      child: OverflowBox(
        alignment: alignment,
        maxWidth: double.infinity,
        child: KlpRow(mainAxisSize: MainAxisSize.min, children: children),
      ),
    ),
  );
}
