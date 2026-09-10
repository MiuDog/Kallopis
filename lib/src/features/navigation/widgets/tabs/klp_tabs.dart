import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../foundation/interaction/klp_focus_region.dart';
import '../../../../foundation/interaction/klp_roving_index.dart';
import '../../../../foundation/layout/klp_layout.dart';
import '../../../../styling/legacy_theme/klp_theme.dart';
import '../../../../foundation/content/klp_text.dart';

part 'internal/klp_tab.dart';
part 'primitives/klp_tab_frame.dart';
part 'primitives/klp_tabs_viewport.dart';

/// 分頁列。`selected` 是索引，`tabs` 是顯示文字；本元件不持有狀態。
///
/// **鍵盤**：任一分頁取得焦點後，`←`／`→` 會在分頁之間移動並直接切換選取
/// （在頭尾之間循環），沿用 [KlpRovingIndex]，與 [KlpMenu]、[KlpCombobox] 共用
/// 同一套索引移動規則。
class KlpTabs extends StatelessWidget {
  const KlpTabs({
    super.key,
    required this.tabs,
    required this.selected,
    required this.onSelected,
  });

  final List<String> tabs;
  final int selected;
  final ValueChanged<int> onSelected;

  KeyEventResult _handleKey(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;
    if (tabs.isEmpty) return KeyEventResult.ignored;

    if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
      onSelected(
        KlpRovingIndex.move(
          current: selected,
          count: tabs.length,
          forward: true,
        ),
      );
      return KeyEventResult.handled;
    }
    if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
      onSelected(
        KlpRovingIndex.move(
          current: selected,
          count: tabs.length,
          forward: false,
        ),
      );
      return KeyEventResult.handled;
    }

    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    return KlpFocusRegion(
      onKeyEvent: _handleKey,
      child: _KlpTabsViewport(
        child: KlpRow(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var index = 0; index < tabs.length; index++) ...[
              _KlpTab(
                label: tabs[index],
                selected: selected == index,
                onPressed: () => onSelected(index),
              ),
              if (index < tabs.length - 1)
                const KlpGap.widthSize(KlpSpaceSize.tight),
            ],
          ],
        ),
      ),
    );
  }
}
