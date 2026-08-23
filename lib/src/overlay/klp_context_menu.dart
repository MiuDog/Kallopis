import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';

import '../theme/klp_theme.dart';
import 'klp_menu.dart';

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
  });

  /// 掛載右鍵選單行為的子樹。
  final Widget child;

  /// 選單標題。庫不替產品決定用什麼語言說明這組動作——呼叫端必須提供。
  final String label;

  /// 選單項目，重用 [KlpMenu] 既有的資料模型。
  final List<KlpMenuItemData> items;

  @override
  State<KlpContextMenu> createState() => _KlpContextMenuState();
}

class _KlpContextMenuState extends State<KlpContextMenu> {
  final OverlayPortalController _controller = OverlayPortalController();
  Offset _anchor = Offset.zero;

  void _openAt(Offset globalPosition) {
    setState(() => _anchor = globalPosition);
    _controller.show();
  }

  void _close() {
    if (_controller.isShowing) _controller.hide();
  }

  /// 包一層 `onPressed`：選到項目後先關閉選單再執行原本的動作，
  /// 呼叫端不需要自己記得關閉時機。
  List<KlpMenuItemData> _dismissingItems() => [
    for (final item in widget.items)
      KlpMenuItemData(
        key: item.key,
        label: item.label,
        icon: item.icon,
        shortcut: item.shortcut,
        toggleValue: item.toggleValue,
        hasSubmenu: item.hasSubmenu,
        danger: item.danger,
        separatedBefore: item.separatedBefore,
        selected: item.selected,
        enabled: item.enabled,
        onPressed: () {
          _close();
          item.onPressed();
        },
      ),
  ];

  @override
  Widget build(BuildContext context) {
    final separatorCount = widget.items
        .where((item) => item.separatedBefore)
        .length;

    return OverlayPortal(
      controller: _controller,
      overlayChildBuilder: (overlayContext) {
        final viewport = MediaQuery.sizeOf(overlayContext);
        final position = KlpMenuLayout.resolvePosition(
          anchor: _anchor,
          viewport: viewport,
          context: overlayContext,
          itemCount: widget.items.length,
          separatorCount: separatorCount,
        );

        return Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: _close,
                onSecondaryTap: _close,
                child: const SizedBox.expand(),
              ),
            ),
            Positioned(
              left: position.dx,
              top: position.dy,
              child: KlpMenu(
                label: widget.label,
                items: _dismissingItems(),
                onEscape: _close,
              ),
            ),
          ],
        );
      },
      child: GestureDetector(
        onSecondaryTapDown: (details) => _openAt(details.globalPosition),
        child: RawGestureDetector(
          gestures: {
            LongPressGestureRecognizer:
                GestureRecognizerFactoryWithHandlers<
                  LongPressGestureRecognizer
                >(
                  () => LongPressGestureRecognizer(
                    duration: context.klp.motion.longPressThreshold,
                  ),
                  (recognizer) =>
                      recognizer.onLongPressStart = (details) =>
                          _openAt(details.globalPosition),
                ),
          },
          child: widget.child,
        ),
      ),
    );
  }
}
