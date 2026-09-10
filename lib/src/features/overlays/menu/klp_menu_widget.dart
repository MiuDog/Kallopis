part of '../klp_menu.dart';

/// 彈出式選單面板：標題列加上一組 [KlpMenuItemData]。
///
/// 只畫面板本身（含陰影與圓角），不處理定位或觸發——插入 overlay 的位置請用
/// [KlpMenuLayout] 先算好，選單的顯示／關閉時機也由呼叫端控制。
class KlpMenu extends StatefulWidget {
  const KlpMenu({
    super.key,
    required this.label,
    required this.items,
    this.autofocus = true,
    this.onEscape,
  });

  final String label;
  final List<KlpMenuItemData> items;

  /// 是否在選單出現時自動取得鍵盤焦點，才能立刻用方向鍵操作。預設 `true`。
  final bool autofocus;

  /// 按下 `Escape` 時呼叫；未提供時不產生作用。
  final VoidCallback? onEscape;

  @override
  State<KlpMenu> createState() => _KlpMenuState();
}
