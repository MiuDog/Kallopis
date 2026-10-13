/// Kallopis 專案模組。
library;

import 'package:flutter/widgets.dart';
import 'klp_window_header_slot.dart';

/// 視窗標題列 CustomMultiChildLayout 的佈局委派器。
class KlpWindowHeaderContentDelegate extends MultiChildLayoutDelegate {
  @override
  void performLayout(Size size) {
    var extrasWidth = 0.0;
    if (hasChild(KlpWindowHeaderSlot.extras)) {
      final extrasSize = layoutChild(
        KlpWindowHeaderSlot.extras,
        BoxConstraints.loose(size),
      );
      extrasWidth = extrasSize.width;
      positionChild(
        KlpWindowHeaderSlot.extras,
        Offset(size.width - extrasWidth, (size.height - extrasSize.height) / 2),
      );
    }

    final identityWidth = (size.width - extrasWidth).clamp(0.0, size.width);
    layoutChild(
      KlpWindowHeaderSlot.identity,
      BoxConstraints.tight(Size(identityWidth, size.height)),
    );
    positionChild(KlpWindowHeaderSlot.identity, Offset.zero);
  }

  @override
  bool shouldRelayout(KlpWindowHeaderContentDelegate oldDelegate) => false;
}
