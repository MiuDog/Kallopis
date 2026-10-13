import 'package:flutter/widgets.dart';

import 'package:kallopis/src/features/workspace/shell/panel/klp_panel_frame.dart';

/// Rail 的獨立表面相容配方。
class KlpNavigationRailFrame extends KlpPanelFrame {
  const KlpNavigationRailFrame({super.key, required Widget child})
    : super(content: child);
}
