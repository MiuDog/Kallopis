import 'package:flutter/widgets.dart';

import '../foundation/pln_icon.dart';
import '../foundation/pln_metrics.dart';
import '../surface/pln_surface.dart';
import '../theme/pln_theme.dart';
import '../typography/pln_text.dart';
import 'pln_feedback_tone.dart';

class PlnInlineNotice extends StatelessWidget {
  const PlnInlineNotice({
    super.key,
    required this.title,
    this.message,
    this.tone = PlnFeedbackTone.info,
    this.action,
  });

  final String title;
  final String? message;
  final PlnFeedbackTone tone;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final tokens = context.plnTheme;
    final toneColor = tone.color(tokens);

    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact = constraints.maxWidth < 480;
        final content = Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 28,
              height: 28,
              child: Center(
                child: PlnIcon(
                  tone.icon,
                  size: PlnSize.iconLarge,
                  color: toneColor,
                ),
              ),
            ),
            const SizedBox(width: PlnSpace.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    key: const ValueKey('pln-inline-notice-header'),
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      PlnText(
                        tone.label,
                        role: PlnTextRole.label,
                        color: toneColor,
                      ),
                      const SizedBox(width: PlnSpace.sm),
                      Flexible(child: PlnText(title, role: PlnTextRole.body)),
                    ],
                  ),
                  if (message != null) ...[
                    const SizedBox(height: PlnSpace.xs),
                    PlnText(
                      message!,
                      role: PlnTextRole.body,
                      tone: PlnTextTone.muted,
                    ),
                  ],
                ],
              ),
            ),
          ],
        );

        return PlnSurface(
          tone: PlnSurfaceTone.component,
          radius: PlnRadius.control,
          padding: const EdgeInsets.all(PlnSpace.md),
          child: isCompact && action != null
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    content,
                    const SizedBox(height: PlnSpace.md),
                    Align(alignment: Alignment.centerRight, child: action),
                  ],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: content),
                    if (action != null) ...[
                      const SizedBox(width: PlnSpace.md),
                      action!,
                    ],
                  ],
                ),
        );
      },
    );
  }
}
