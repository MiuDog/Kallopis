import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import 'package:kallopis/src/foundation/klp_icon.dart';
import 'package:kallopis/src/foundation/interaction/klp_pressable.dart';
import 'package:kallopis/src/styling/legacy_theme/klp_theme.dart';
import 'package:kallopis/src/foundation/content/klp_text.dart';
import 'klp_navigation_icon_box_key.dart';

export 'klp_navigation_icon_box_key.dart';

part 'internal/klp_sidebar_navigation_button_state.dart';
part 'primitives/klp_sidebar_navigation_button_frame.dart';

/// Primary Sidebar 內的全寬導覽按鈕。
///
/// 消費者只提供圖示、標籤、選取狀態與事件；高度、內距、圓角、圖示尺寸、
/// hover 與選取色全部由 Kallopis theme 決定。
class KlpSidebarNavigationButton extends StatefulWidget {
  const KlpSidebarNavigationButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
    this.selected = false,
  });

  final KlpIconData icon;
  final String label;
  final VoidCallback? onPressed;
  final bool selected;

  @override
  State<KlpSidebarNavigationButton> createState() =>
      _KlpSidebarNavigationButtonState();
}
