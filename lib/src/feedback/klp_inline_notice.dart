import 'package:flutter/widgets.dart';

import '../foundation/klp_icon.dart';
import '../surface/klp_surface.dart';
import '../theme/klp_theme.dart';
import '../typography/klp_text.dart';
import 'klp_feedback_tone.dart';

class KlpInlineNotice extends StatelessWidget {
  const KlpInlineNotice({
    super.key,
    required this.title,
    this.message,
    this.tone = KlpFeedbackTone.info,
    this.action,
  });

  final String title;
  final String? message;
  final KlpFeedbackTone tone;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final tokens = context.klpColors;
    final toneColor = tone.color(tokens);

    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact = constraints.maxWidth < 480;
        final content = Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: context.klp.space.noticeIconSlot,
              height: context.klp.space.noticeIconSlot,
              child: Center(
                child: KlpIcon(
                  tone.icon,
                  size: context.klp.space.iconLarge,
                  color: toneColor,
                ),
              ),
            ),
            SizedBox(width: context.klp.space.base),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    key: const ValueKey('pln-inline-notice-header'),
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      KlpText(
                        tone.label,
                        role: KlpTextRole.label,
                        tone: KlpTextTone.muted,
                      ),
                      SizedBox(width: context.klp.space.compact),
                      Flexible(child: KlpText(title, role: KlpTextRole.body)),
                    ],
                  ),
                  if (message != null) ...[
                    SizedBox(height: context.klp.space.tight),
                    KlpText(
                      message!,
                      role: KlpTextRole.body,
                      tone: KlpTextTone.muted,
                    ),
                  ],
                ],
              ),
            ),
          ],
        );

        return KlpSurface(
          tone: KlpSurfaceTone.component,
          radius: context.klp.shape.control,
          padding: EdgeInsets.all(context.klp.space.base),
          child: isCompact && action != null
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    content,
                    SizedBox(height: context.klp.space.base),
                    Align(alignment: Alignment.centerRight, child: action),
                  ],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: content),
                    if (action != null) ...[
                      SizedBox(width: context.klp.space.base),
                      action!,
                    ],
                  ],
                ),
        );
      },
    );
  }
}
