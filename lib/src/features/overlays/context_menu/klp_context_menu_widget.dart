part of '../klp_context_menu.dart';

/// 右鍵選單：掛在任意子樹上，滑鼠右鍵或觸控長按於指標位置彈出。
///
/// 選單本體重用既有的 [KlpMenu] 與 [KlpMenuItemData]——本元件只負責觸發時機、
/// 指標定位與點外部關閉，**不重新實作選單外觀**（一條規則只能有一個實作）。
/// 彈出位置沿用 [KlpMenuLayout.resolvePosition]，與 [KlpMenu] 在其他彈出場景
/// 使用同一套定位邏輯，才不會有兩份互相分岔的擺放規則。
class KlpContextMenu extends StatefulWidget {
  const KlpContextMenu({
    super.key,
    required this.child,
    required this.label,
    required this.items,
    this.controller,
  });

  /// 掛載右鍵選單行為的子樹。
  final Widget child;

  /// 選單標題。庫不替產品決定用什麼語言說明這組動作——呼叫端必須提供。
  final String label;

  /// 選單項目，重用 [KlpMenu] 既有的資料模型。
  final List<KlpMenuItemData> items;
  final KlpContextMenuController? controller;

  @override
  State<KlpContextMenu> createState() => _KlpContextMenuState();
}
