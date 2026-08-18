import 'package:flutter/widgets.dart';

import '../feedback/klp_feedback_tone.dart';
import '../theme/klp_theme.dart';
import '../typography/klp_text.dart';

class KlpBadge extends StatelessWidget {
  const KlpBadge({
    super.key,
    required this.label,
    this.tone = KlpFeedbackTone.neutral,
    this.dot = false,
  });

  final String label;
  final KlpFeedbackTone tone;
  final bool dot;

  @override
  Widget build(BuildContext context) {
    final tokens = context.klpColors;
    final toneColor = tone.color(tokens);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.klp.space.compact,
        vertical: context.klp.space.tight,
      ),
      decoration: BoxDecoration(
        color: tokens.component,
        borderRadius: BorderRadius.circular(context.klp.shape.control),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (dot) ...[
            Container(
              width: 6,
              height: 6,
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
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class KlpTag extends StatelessWidget {
  const KlpTag({super.key, required this.label, this.onRemove});

  final String label;
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
        color: tokens.surfaceMuted,
        borderRadius: BorderRadius.circular(context.klp.shape.control),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
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
              child: const KlpText('×', role: KlpTextRole.bodyStrong),
            ),
          ],
        ],
      ),
    );
  }
}
