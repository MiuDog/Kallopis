import 'package:flutter/widgets.dart';

import '../feedback/klp_feedback_tone.dart';
import '../theme/klp_theme.dart';
import '../typography/klp_text.dart';

/// 標記視覺樣式：柔和填色 (filled)、外框 (outline)、深黑高對比填色 (solid)。
enum KlpBadgeVariant {
  /// 柔和填色底。
  filled,

  /// 外框無填色（外框與文字同色）。
  outline,

  /// 純深色底與高對比文字。
  solid,
}

/// 狀態標記 (Badge)。
class KlpBadge extends StatelessWidget {
  const KlpBadge({
    super.key,
    required this.label,
    this.tone = KlpFeedbackTone.neutral,
    this.variant = KlpBadgeVariant.filled,
    this.dot = false,
  });

  /// 標籤文字。
  final String label;

  /// 語意色調。
  final KlpFeedbackTone tone;

  /// 視覺樣式（填色、外框或純深色）。
  final KlpBadgeVariant variant;

  /// 是否顯示狀態圓點。
  final bool dot;

  @override
  Widget build(BuildContext context) {
    final tokens = context.klpColors;
    final toneColor = tone == KlpFeedbackTone.neutral
        ? tokens.textMuted
        : tone.color(tokens);

    final (bgColor, borderColor, textColor) = switch (variant) {
      KlpBadgeVariant.outline => (null, toneColor, toneColor),
      KlpBadgeVariant.solid => (tokens.text, null, tokens.stageSurface),
      KlpBadgeVariant.filled => (tokens.component, tokens.divider, tokens.text),
    };

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.klp.space.compact,
        vertical: context.klp.space.tight,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(context.klp.shape.control),
        border: borderColor != null
            ? Border.all(color: borderColor, width: context.klp.shape.hairline)
            : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (dot) ...[
            Container(
              width: context.klp.space.indicatorDot,
              height: context.klp.space.indicatorDot,
              decoration: BoxDecoration(
                color: toneColor,
                shape: BoxShape.circle,
              ),
            ),
            SizedBox(width: context.klp.space.tight),
          ],
          Flexible(
            child: KlpText(
              label.toUpperCase(),
              role: KlpTextRole.label,
              color: textColor,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

/// 可移除或可點擊的分類標籤 (Tag)。
class KlpTag extends StatelessWidget {
  const KlpTag({super.key, required this.label, this.prefix, this.onRemove});

  /// 標籤文字。
  final String label;

  /// 前綴符號（如 '#'）。
  final String? prefix;

  /// 移除標籤的回呼。
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    final tokens = context.klpColors;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.klp.space.compact,
        vertical: context.klp.space.tight,
      ),
      decoration: BoxDecoration(
        color: tokens.surfaceInset,
        borderRadius: BorderRadius.circular(context.klp.shape.control),
        border: Border.all(
          color: tokens.divider,
          width: context.klp.shape.hairline,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (prefix != null) ...[
            KlpText(
              prefix!,
              role: KlpTextRole.caption,
              tone: KlpTextTone.muted,
            ),
            SizedBox(width: context.klp.space.xxs),
          ],
          Flexible(
            child: KlpText(
              label,
              role: KlpTextRole.caption,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (onRemove != null) ...[
            SizedBox(width: context.klp.space.tight),
            GestureDetector(
              onTap: onRemove,
              behavior: HitTestBehavior.opaque,
              child: const KlpText('×', role: KlpTextRole.bodyStrong),
            ),
          ],
        ],
      ),
    );
  }
}
