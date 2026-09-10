part of '../klp_message_thread.dart';

/// 訊息作者、時間與內容的通用呈現單元。
class KlpMessageBubble extends StatelessWidget {
  const KlpMessageBubble({
    super.key,
    required this.author,
    required this.timestamp,
    required this.child,
    this.emphasized = false,
    this.alignment = KlpMessageAlignment.leading,
    this.background,
    this.dense = false,
  });

  final String author;
  final String timestamp;
  final Widget child;
  final bool emphasized;
  final KlpMessageAlignment alignment;
  final bool? background;
  final bool dense;

  @override
  Widget build(BuildContext context) {
    final trailing = alignment == KlpMessageAlignment.trailing;
    final effectiveBackground = background ?? emphasized;
    final bubble = effectiveBackground
        ? KlpSurface(
            tone: KlpSurfaceTone.muted,
            child: KlpBox(
              insets: KlpBoxInsets.uniform(
                dense ? context.klp.space.contentInset : context.klp.space.base,
              ),
              child: child,
            ),
          )
        : child;

    return KlpAlign(
      alignment: trailing ? Alignment.centerRight : Alignment.centerLeft,
      child: KlpColumn(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: trailing
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          KlpRow(
            mainAxisSize: MainAxisSize.min,
            children: [
              KlpText(author, role: KlpTextRole.code),
              const KlpGap.widthSize(KlpSpaceSize.contentInline),
              KlpText(
                timestamp,
                role: KlpTextRole.code,
                tone: KlpTextTone.faint,
              ),
            ],
          ),
          const KlpGap.heightSize(KlpSpaceSize.contentStack),
          bubble,
        ],
      ),
    );
  }
}
