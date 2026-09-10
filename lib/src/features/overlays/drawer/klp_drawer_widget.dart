part of '../klp_drawer.dart';

/// 從邊緣滑入的面板：側邊欄、篩選面板，或（[KlpDrawerEdge.bottom] 方向）行動裝置
/// 常見的 sheet。
///
/// **不負責彈出**——呼叫端決定用什麼容器承載這個 widget（例如
/// `KlpOverlayHost`、`KlpStack` 或 `Overlay`），並透過 [open] 驅動顯示與否；
/// 本元件只負責滑入滑出的動畫、遮罩與「點遮罩關閉」這個互動。呼叫端持有
/// [open] 的狀態，本元件本身不追蹤開關。
class KlpDrawer extends StatelessWidget {
  const KlpDrawer({
    super.key,
    required this.open,
    required this.child,
    this.edge = KlpDrawerEdge.right,
    this.size,
    this.onScrimTap,
    this.barrierDismissible = true,
  });

  /// 是否展開。
  final bool open;

  /// 面板內容。
  final Widget child;

  /// 從哪個邊緣滑入。`bottom` 即一般所稱的 sheet。
  final KlpDrawerEdge edge;

  /// 面板尺寸：[KlpDrawerEdge.left]／[KlpDrawerEdge.right] 為寬度，
  /// [KlpDrawerEdge.top]／[KlpDrawerEdge.bottom] 為高度。
  /// `null` 表示沿用 theme 的預設面板尺寸。
  final double? size;

  /// 點遮罩時呼叫，用於關閉面板。
  final VoidCallback? onScrimTap;

  /// 點遮罩是否關閉——即遮罩是否攔截點擊事件。收合時遮罩一律不攔截，
  /// 不受此旗標影響。
  final bool barrierDismissible;

  @override
  Widget build(BuildContext context) {
    final klp = context.klp;
    final isHorizontal =
        edge == KlpDrawerEdge.left || edge == KlpDrawerEdge.right;
    final resolvedSize =
        size ??
        (isHorizontal
            ? klp.geometry.layout.drawerWidth
            : klp.geometry.layout.drawerHeight);
    final alignment = switch (edge) {
      KlpDrawerEdge.left => Alignment.centerLeft,
      KlpDrawerEdge.right => Alignment.centerRight,
      KlpDrawerEdge.top => Alignment.topCenter,
      KlpDrawerEdge.bottom => Alignment.bottomCenter,
    };
    final hiddenOffset = switch (edge) {
      KlpDrawerEdge.left => const Offset(-1, 0),
      KlpDrawerEdge.right => const Offset(1, 0),
      KlpDrawerEdge.top => const Offset(0, -1),
      KlpDrawerEdge.bottom => const Offset(0, 1),
    };
    final transitionDuration = open
        ? klp.motion.overlayEnter
        : klp.motion.overlayExit;

    return IgnorePointer(
      ignoring: !open,
      child: KlpStack(
        children: [
          AnimatedOpacity(
            opacity: open ? klp.surface.scrimOpacity : 0,
            duration: transitionDuration,
            curve: klp.motion.standard,
            child: KlpGestureRegion(
              behavior: HitTestBehavior.opaque,
              onTap: barrierDismissible ? onScrimTap : null,
              child: ColoredBox(
                color: klp.color.modalScrim,
                child: const KlpBox.expand(),
              ),
            ),
          ),
          KlpAlign(
            alignment: alignment,
            child: AnimatedSlide(
              offset: open ? Offset.zero : hiddenOffset,
              duration: transitionDuration,
              curve: open ? klp.motion.standard : klp.motion.emphasized,
              child: KlpBox(
                width: isHorizontal ? resolvedSize : null,
                height: isHorizontal ? null : resolvedSize,
                child: KlpSurface(
                  tone: KlpSurfaceTone.overlay,
                  radius: klp.shape.panel,
                  child: child,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
