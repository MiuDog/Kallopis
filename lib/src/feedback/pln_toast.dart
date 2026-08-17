import 'package:flutter/material.dart';

import '../controls/pln_button.dart';
import '../foundation/pln_icon.dart';
import '../foundation/pln_metrics.dart';
import '../theme/pln_theme.dart';
import '../typography/pln_text.dart';
import 'pln_feedback_tone.dart';

class PlnToast extends StatelessWidget {
  const PlnToast({
    super.key,
    required this.title,
    this.message,
    this.tone = PlnFeedbackTone.info,
    this.actionLabel,
    this.onAction,
    this.onClose,
  });

  final String title;
  final String? message;
  final PlnFeedbackTone tone;
  final String? actionLabel;
  final VoidCallback? onAction;
  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) {
    final tokens = context.plnTheme;
    final toneColor = tone.color(tokens);

    return Semantics(
      liveRegion: true,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 360),
        child: Container(
          padding: const EdgeInsets.all(PlnSpace.md),
          decoration: BoxDecoration(
            color: tokens.surfaceInset,
            borderRadius: BorderRadius.circular(PlnRadius.card),
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
                      child: PlnIcon(
                        tone.icon,
                        size: PlnSize.icon,
                        color: toneColor,
                      ),
                    ),
                  ),
                  const SizedBox(width: PlnSpace.sm),
                  Expanded(
                    child: PlnText(
                      tone.label,
                      role: PlnTextRole.label,
                      color: toneColor,
                    ),
                  ),
                  const PlnText(
                    'NOW',
                    role: PlnTextRole.label,
                    tone: PlnTextTone.faint,
                  ),
                ],
              ),
              const SizedBox(height: PlnSpace.md),
              PlnText(title, role: PlnTextRole.bodyStrong),
              if (message != null) ...[
                const SizedBox(height: PlnSpace.xs),
                PlnText(
                  message!,
                  role: PlnTextRole.caption,
                  tone: PlnTextTone.muted,
                ),
              ],
              if (actionLabel != null || onClose != null) ...[
                const SizedBox(height: PlnSpace.md),
                Wrap(
                  alignment: WrapAlignment.end,
                  spacing: PlnSpace.xs,
                  runSpacing: PlnSpace.xs,
                  children: [
                    if (onClose != null)
                      PlnButton(
                        label: '關閉',
                        onPressed: onClose,
                        tone: PlnButtonTone.ghost,
                        compact: true,
                      ),
                    if (actionLabel != null && onAction != null)
                      PlnButton(
                        label: actionLabel!,
                        onPressed: onAction,
                        tone: PlnButtonTone.primary,
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

class PlnToastStack extends StatelessWidget {
  const PlnToastStack({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        for (var index = 0; index < children.length; index++) ...[
          children[index],
          if (index < children.length - 1) const SizedBox(height: PlnSpace.sm),
        ],
      ],
    );
  }
}
