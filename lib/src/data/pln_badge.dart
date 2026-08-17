import 'package:flutter/widgets.dart';

import '../feedback/pln_feedback_tone.dart';
import '../foundation/pln_metrics.dart';
import '../theme/pln_theme.dart';
import '../typography/pln_text.dart';

class PlnBadge extends StatelessWidget {
  const PlnBadge({
    super.key,
    required this.label,
    this.tone = PlnFeedbackTone.neutral,
    this.dot = false,
  });

  final String label;
  final PlnFeedbackTone tone;
  final bool dot;

  @override
  Widget build(BuildContext context) {
    final tokens = context.plnTheme;
    final toneColor = tone.color(tokens);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: PlnSpace.sm,
        vertical: PlnSpace.xs,
      ),
      decoration: BoxDecoration(
        color: tokens.component,
        borderRadius: BorderRadius.circular(PlnRadius.control),
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
            const SizedBox(width: PlnSpace.xs),
          ],
          Flexible(
            child: PlnText(
              label.toUpperCase(),
              role: PlnTextRole.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class PlnTag extends StatelessWidget {
  const PlnTag({super.key, required this.label, this.onRemove});

  final String label;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    final tokens = context.plnTheme;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: PlnSpace.sm,
        vertical: PlnSpace.xs,
      ),
      decoration: BoxDecoration(
        color: tokens.surfaceMuted,
        borderRadius: BorderRadius.circular(PlnRadius.control),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: PlnText(
              label,
              role: PlnTextRole.caption,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (onRemove != null) ...[
            const SizedBox(width: PlnSpace.xs),
            GestureDetector(
              onTap: onRemove,
              child: const PlnText('×', role: PlnTextRole.bodyStrong),
            ),
          ],
        ],
      ),
    );
  }
}
