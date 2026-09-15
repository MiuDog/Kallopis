import 'package:flutter/widgets.dart';

import 'package:kallopis/src/foundation/layout/klp_box_insets.dart';
import 'package:kallopis/src/styling/legacy_theme/klp_theme.dart';

/// Primary Sidebar 的 header 與 navigation 區塊內縮。
enum KlpPrimarySidebarHeaderInset {
  navigation,
  none;

  KlpBoxInsets resolve(BuildContext context) {
    return switch (this) {
      KlpPrimarySidebarHeaderInset.navigation => KlpBoxInsets.directional(
        top: context.klp.space.navigationItemInset,
        bottom: context.klp.space.navigationItemInset,
      ),
      KlpPrimarySidebarHeaderInset.none => const KlpBoxInsets.directional(),
    };
  }
}
