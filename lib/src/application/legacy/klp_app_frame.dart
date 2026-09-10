part of 'klp_app.dart';

/// 鋪設 App background，並以 appFrameInset 包住 Header 與產品主內容。
class _KlpAppFrame extends StatelessWidget {
  const _KlpAppFrame({
    required this.header,
    required this.body,
    required this.toolbarHeight,
    this.popup,
  });

  final Widget? header;
  final Widget body;
  final double toolbarHeight;
  final KlpPopupBackground? popup;

  @override
  Widget build(BuildContext context) {
    final headerHeight = toolbarHeight;

    return KlpSurface(
      key: const ValueKey('klp-app-frame-background'),
      tone: KlpSurfaceTone.app,
      child: KlpBox(
        insets: KlpBoxInsets.uniform(context.klp.space.appFrameInset),
        child: LayoutBuilder(
          builder: (context, constraints) {
            var effectiveHeaderHeight = headerHeight;
            if (constraints.hasBoundedHeight) {
              effectiveHeaderHeight = constraints.maxHeight
                  .clamp(0.0, headerHeight)
                  .toDouble();
            }

            if (!constraints.hasBoundedHeight) {
              return KlpColumn(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (header != null)
                    KlpBox(height: effectiveHeaderHeight, child: header),
                  body,
                ],
              );
            }

            return KlpPopupInteractionScope(
              topInset: effectiveHeaderHeight,
              child: KlpStack(
                clipBehavior: Clip.hardEdge,
                children: [
                  KlpDirectionalPositioned(
                    position: KlpDirectionalPosition.below(
                      top: effectiveHeaderHeight,
                    ),
                    child: body,
                  ),
                  if (header != null)
                    KlpDirectionalPositioned(
                      position: KlpDirectionalPosition.atTop(
                        height: effectiveHeaderHeight,
                      ),
                      child: header!,
                    ),
                  if (popup != null)
                    KlpDirectionalPositioned(
                      position: const KlpDirectionalPosition.fill(),
                      child: popup!,
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
