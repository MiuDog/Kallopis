part of '../klp_popup.dart';

/// Popup 的背景遮罩。點擊 panel 以外的可互動背景時呼叫 [onDismiss]。
///
/// 若位於 [KlpPopupInteractionScope] 之下，scope 的頂部範圍只負責顯示遮罩，
/// 不會接收 pointer，因此視窗標題列的拖動與雙擊事件優先。
class KlpPopupBackground extends StatelessWidget {
  const KlpPopupBackground({
    super.key,
    required this.child,
    required this.onDismiss,
  });

  final KlpPopupPanel child;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    final topInset = KlpPopupInteractionScope.topInsetOf(context);
    final scrim = context.klp.color.modalScrim.withValues(
      alpha: context.klp.surface.scrimOpacity,
    );

    return KlpStack(
      fit: StackFit.expand,
      children: [
        IgnorePointer(child: ColoredBox(color: scrim)),
        KlpPositioned(
          left: 0,
          top: topInset,
          right: 0,
          bottom: 0,
          child: KlpGestureRegion(
            behavior: HitTestBehavior.opaque,
            onTap: onDismiss,
            child: const KlpBox.expand(),
          ),
        ),
        KlpPositioned(
          left: 0,
          top: topInset,
          right: 0,
          bottom: 0,
          child: KlpCenter(child: child),
        ),
      ],
    );
  }
}
