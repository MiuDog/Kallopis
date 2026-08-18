import 'package:flutter/material.dart';

import '../controls/klp_button.dart';
import '../foundation/klp_icon.dart';
import '../theme/klp_theme.dart';
import '../typography/klp_text.dart';
import 'klp_feedback_tone.dart';

class KlpToast extends StatelessWidget {
  const KlpToast({
    super.key,
    required this.title,
    this.message,
    this.tone = KlpFeedbackTone.info,
    this.actionLabel,
    this.onAction,
    this.onClose,
  });

  final String title;
  final String? message;
  final KlpFeedbackTone tone;
  final String? actionLabel;
  final VoidCallback? onAction;
  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) {
    final tokens = context.klpColors;
    final toneColor = tone.color(tokens);

    return Semantics(
      liveRegion: true,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 360),
        child: Container(
          padding: EdgeInsets.all(context.klp.space.base),
          decoration: BoxDecoration(
            color: tokens.surfaceInset,
            borderRadius: BorderRadius.circular(context.klp.shape.card),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 22,
                    height: 22,
                    child: Center(
                      child: KlpIcon(
                        tone.icon,
                        size: context.klp.space.icon,
                        color: toneColor,
                      ),
                    ),
                  ),
                  SizedBox(width: context.klp.space.compact),
                  Expanded(
                    child: KlpText(
                      tone.label,
                      role: KlpTextRole.label,
                      color: toneColor,
                    ),
                  ),
                  const KlpText(
                    'NOW',
                    role: KlpTextRole.label,
                    tone: KlpTextTone.faint,
                  ),
                ],
              ),
              SizedBox(height: context.klp.space.base),
              KlpText(title, role: KlpTextRole.bodyStrong),
              if (message != null) ...[
                SizedBox(height: context.klp.space.tight),
                KlpText(
                  message!,
                  role: KlpTextRole.caption,
                  tone: KlpTextTone.muted,
                ),
              ],
              if (actionLabel != null || onClose != null) ...[
                SizedBox(height: context.klp.space.base),
                Wrap(
                  alignment: WrapAlignment.end,
                  spacing: context.klp.space.tight,
                  runSpacing: context.klp.space.tight,
                  children: [
                    if (onClose != null)
                      KlpButton(
                        label: '關閉',
                        onPressed: onClose,
                        tone: KlpButtonTone.ghost,
                        compact: true,
                      ),
                    if (actionLabel != null && onAction != null)
                      KlpButton(
                        label: actionLabel!,
                        onPressed: onAction,
                        tone: KlpButtonTone.primary,
                        compact: true,
                      ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class KlpToastStack extends StatelessWidget {
  const KlpToastStack({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        for (var index = 0; index < children.length; index++) ...[
          children[index],
          if (index < children.length - 1) SizedBox(height: context.klp.space.compact),
        ],
      ],
    );
  }
}
