import 'package:flutter/widgets.dart';

import '../../foundation/klp_icon.dart';
import '../../foundation/layout/klp_layout.dart';
import '../../foundation/surface/klp_surface.dart';
import '../../styling/legacy_theme/klp_theme.dart';
import '../../foundation/content/klp_text.dart';
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
    final iconSize = KlpTextStyles.definitionOf(
      KlpTextRole.body,
      context.klp.type,
    ).fontSize;

    return KlpLayoutBuilder(
      builder: (context, constraints) {
        final isCompact =
            constraints.maxWidth <
            context.klp.geometry.layout.inlineNoticeBreakpoint;
        final content = KlpColumn(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            KlpRow(
              key: const ValueKey('pln-inline-notice-header'),
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                KlpIcon(tone.icon, size: iconSize, color: toneColor),
                const KlpGap.widthSize(KlpSpaceSize.contentInline),
                KlpText(
                  tone.label,
                  role: KlpTextRole.label,
                  tone: KlpTextTone.muted,
                ),
                const KlpGap.widthSize(KlpSpaceSize.contentInline),
                KlpFlexible(child: KlpText(title, role: KlpTextRole.body)),
              ],
            ),
            if (message != null) ...[
              const KlpGap.heightSize(KlpSpaceSize.tight),
              KlpText(
                message!,
                role: KlpTextRole.body,
                tone: KlpTextTone.muted,
              ),
            ],
          ],
        );
        late final Widget layout;
        if (isCompact && action != null) {
          layout = KlpColumn(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              content,
              const KlpGap.heightSize(KlpSpaceSize.base),
              KlpAlign(alignment: Alignment.centerRight, child: action!),
            ],
          );
        } else {
          layout = KlpRow(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              KlpExpanded(child: content),
              if (action != null) ...[
                const KlpGap.widthSize(KlpSpaceSize.base),
                action!,
              ],
            ],
          );
        }

        return KlpSurface(
          tone: KlpSurfaceTone.component,
          radius: context.klp.shape.control,
          child: KlpBox(paddingSize: KlpSpaceSize.base, child: layout),
        );
      },
    );
  }
}
