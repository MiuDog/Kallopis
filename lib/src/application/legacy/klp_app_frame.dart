part of 'klp_app.dart';

/// 鋪設 App background，不帶預設 padding 與 header，由消費端或 Layout 自行負責排版。
class _KlpAppFrame extends StatelessWidget {
  const _KlpAppFrame({
    required this.body,
    this.popup,
  });

  final Widget body;
  final KlpPopupBackground? popup;

  @override
  Widget build(BuildContext context) {
    return KlpSurface(
      key: const ValueKey('klp-app-frame-background'),
      tone: KlpSurfaceTone.app,
      child: popup == null
          ? body
          : KlpPopupInteractionScope(
              topInset: 0.0,
              child: KlpStack(
                clipBehavior: Clip.hardEdge,
                children: [
                  KlpDirectionalPositioned(
                    position: const KlpDirectionalPosition.fill(),
                    child: body,
                  ),
                  KlpDirectionalPositioned(
                    position: const KlpDirectionalPosition.fill(),
                    child: popup!,
                  ),
                ],
              ),
            ),
    );
  }
}
