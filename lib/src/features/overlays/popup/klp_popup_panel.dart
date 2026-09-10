part of '../klp_popup.dart';

/// Popup 的固定尺寸 surface。內容內距由 [child] 自己擁有。
class KlpPopupPanel extends StatelessWidget {
  const KlpPopupPanel({super.key, required this.kind, required this.child});

  /// 普通表單面板固定為 600×816，對應建立頻道等完整輸入流程。
  static const Size standardSize = Size(600, 816);
  static const Size largeSize = Size(1064, 880);

  final KlpPopupPanelKind kind;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return KlpLayoutBuilder(
      builder: (context, constraints) {
        final size = kind == KlpPopupPanelKind.large ? largeSize : standardSize;
        final isFullPage =
            kind == KlpPopupPanelKind.large &&
            (constraints.maxWidth < size.width ||
                constraints.maxHeight < size.height);
        final surface = isFullPage
            ? ColoredBox(color: context.klp.color.overlay, child: child)
            : KlpSurface(
                tone: KlpSurfaceTone.overlay,
                radius: context.klp.shape.panel,
                child: child,
              );

        return isFullPage
            ? KlpBox.expand(child: surface)
            : KlpBox(width: size.width, height: size.height, child: surface);
      },
    );
  }
}
