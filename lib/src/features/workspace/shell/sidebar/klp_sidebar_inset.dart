import 'package:flutter/widgets.dart';

import '../../../../foundation/layout/klp_box_insets.dart';
import '../../../../styling/legacy_theme/klp_theme.dart';

/// Sidebar 內容區的語意內縮。
enum KlpSidebarInset {
  chromePanel,
  content;

  KlpBoxInsets resolve(BuildContext context) {
    final space = context.klp.space;

    return switch (this) {
      KlpSidebarInset.chromePanel => KlpBoxInsets.directional(
        start: space.chromePanelInset,
        end: space.chromePanelInset,
      ),
      KlpSidebarInset.content => KlpBoxInsets.directional(
        start: space.contentInset,
        end: space.contentInset,
      ),
    };
  }
}
