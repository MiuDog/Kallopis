import 'package:flutter/widgets.dart';

import '../data/klp_badge.dart';
import '../feedback/klp_feedback_tone.dart';
import '../foundation/klp_metrics.dart';
import '../surface/klp_surface.dart';
import '../theme/klp_theme.dart';
import '../typography/klp_text.dart';

class KlpPageChrome extends StatelessWidget {
  const KlpPageChrome({
    super.key,
    required this.breadcrumb,
    required this.title,
    this.status,
    this.collaborator,
  });

  final List<String> breadcrumb;
  final String title;
  final String? status;
  final String? collaborator;

  @override
  Widget build(BuildContext context) {
    final tokens = context.klpColors;

    return KlpSurface(
      tone: KlpSurfaceTone.component,
      padding: const EdgeInsets.all(KlpSpace.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Wrap(
            spacing: KlpSpace.xs,
            runSpacing: KlpSpace.xs,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              KlpText(
                breadcrumb.join(' / '),
                role: KlpTextRole.code,
                tone: KlpTextTone.muted,
              ),
              if (status != null) ...[
                KlpText('•', color: tokens.text),
                KlpText(
                  status!,
                  role: KlpTextRole.caption,
                  tone: KlpTextTone.muted,
                ),
              ],
              if (collaborator != null) KlpBadge(label: collaborator!),
            ],
          ),
          const SizedBox(height: KlpSpace.md),
          KlpText(title, role: KlpTextRole.display),
        ],
      ),
    );
  }
}

@immutable
class KlpStatusMessageData {
  const KlpStatusMessageData({
    required this.label,
    this.tone = KlpFeedbackTone.neutral,
  });

  final String label;
  final KlpFeedbackTone tone;
}

class KlpSaveStatusCard extends StatelessWidget {
  const KlpSaveStatusCard({
    super.key,
    required this.savedAt,
    required this.messages,
  });

  final String savedAt;
  final List<KlpStatusMessageData> messages;

  @override
  Widget build(BuildContext context) {
    final tokens = context.klpColors;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: tokens.component,
        borderRadius: BorderRadius.circular(KlpRadius.card),
      ),
      child: Padding(
        padding: const EdgeInsets.all(KlpSpace.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            KlpText('Saved $savedAt', role: KlpTextRole.code),
            const SizedBox(height: KlpSpace.sm),
            for (final message in messages)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: KlpSpace.xs),
                child: KlpText(
                  message.label,
                  role: KlpTextRole.code,
                  color: message.tone == KlpFeedbackTone.neutral
                      ? tokens.textMuted
                      : message.tone.color(tokens),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class KlpPropertySummary extends StatelessWidget {
  const KlpPropertySummary({
    super.key,
    required this.badges,
    required this.tags,
    required this.metadata,
  });

  final List<KlpPropertyBadgeData> badges;
  final List<String> tags;
  final String metadata;

  @override
  Widget build(BuildContext context) {
    return KlpSurface(
      tone: KlpSurfaceTone.component,
      padding: const EdgeInsets.all(KlpSpace.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: KlpSpace.xs,
            runSpacing: KlpSpace.xs,
            children: [
              for (final badge in badges)
                KlpBadge(label: badge.label, tone: badge.tone, dot: badge.dot),
            ],
          ),
          const SizedBox(height: KlpSpace.sm),
          Wrap(
            spacing: KlpSpace.xs,
            runSpacing: KlpSpace.xs,
            children: [for (final tag in tags) KlpTag(label: tag)],
          ),
          const SizedBox(height: KlpSpace.sm),
          KlpText(metadata, role: KlpTextRole.caption, tone: KlpTextTone.muted),
        ],
      ),
    );
  }
}

@immutable
class KlpPropertyBadgeData {
  const KlpPropertyBadgeData({
    required this.label,
    this.tone = KlpFeedbackTone.neutral,
    this.dot = false,
  });

  final String label;
  final KlpFeedbackTone tone;
  final bool dot;
}
