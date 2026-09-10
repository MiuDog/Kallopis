import 'package:flutter/widgets.dart';

import '../../../../foundation/klp_icon.dart';
import '../../../../styling/legacy_theme/klp_theme.dart';
import 'klp_sidebar_navigation_button.dart';

/// Sidebar 按鈕群組中的單一呈現資料。
final class KlpSidebarButtonData {
  final String label;
  final KlpIconData icon;
  final VoidCallback? onPressed;
  final bool selected;

  const KlpSidebarButtonData({
    required this.label,
    required this.icon,
    required this.onPressed,
    this.selected = false,
  });
}

/// 使用 Sidebar chrome 留白與按鈕樣式呈現一組動作。
///
/// 消費端只注入資料與事件；群組負責邊界留白、滿寬排列及共通按鈕外觀。
final class KlpSidebarButtonGroup extends StatelessWidget {
  final List<KlpSidebarButtonData> items;
  final EdgeInsetsGeometry? padding;

  const KlpSidebarButtonGroup({super.key, required this.items, this.padding});

  @override
  Widget build(BuildContext context) {
    final resolvedPadding =
        padding ?? EdgeInsets.all(context.klp.space.chromePanelInset);

    return Padding(padding: resolvedPadding, child: _buildButtons());
  }

  Widget _buildButtons() {
    if (items.isEmpty) return const SizedBox.shrink();
    if (items.length == 1) return _buildButton(items.single);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [for (final item in items) _buildButton(item)],
    );
  }

  Widget _buildButton(KlpSidebarButtonData item) {
    return KlpSidebarNavigationButton(
      label: item.label,
      icon: item.icon,
      onPressed: item.onPressed,
      selected: item.selected,
    );
  }
}
