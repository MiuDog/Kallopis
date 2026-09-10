/// Kallopis 專案模組。
library;

import 'package:flutter/widgets.dart';
import 'klp_window_header_content_delegate.dart';
import 'klp_window_header_slot.dart';

/// 先配置右側次要內容，再把剩餘空間完整交給標題識別區。
Widget buildKlpWindowHeaderContent({required Widget identity, Widget? extras}) {
  return CustomMultiChildLayout(
    delegate: KlpWindowHeaderContentDelegate(),
    children: [
      LayoutId(id: KlpWindowHeaderSlot.identity, child: identity),
      if (extras != null)
        LayoutId(id: KlpWindowHeaderSlot.extras, child: extras),
    ],
  );
}
