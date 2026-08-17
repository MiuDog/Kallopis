import 'package:flutter/widgets.dart';

import '../data/pln_badge.dart';
import '../feedback/pln_feedback_tone.dart';
import '../foundation/pln_metrics.dart';
import '../surface/pln_surface.dart';
import '../theme/pln_theme.dart';
import '../typography/pln_text.dart';

class PlnPageChrome extends StatelessWidget {
  const PlnPageChrome({
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
    final tokens = context.plnTheme;

    return PlnSurface(
      tone: PlnSurfaceTone.component,
      padding: const EdgeInsets.all(PlnSpace.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Wrap(
            spacing: PlnSpace.xs,
            runSpacing: PlnSpace.xs,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              PlnText(
                breadcrumb.join(' / '),
                role: PlnTextRole.code,
                tone: PlnTextTone.muted,
              ),
              if (status != null) ...[
                PlnText('•', color: tokens.text),
                PlnText(
                  status!,
                  role: PlnTextRole.caption,
                  tone: PlnTextTone.muted,
                ),
              ],
              if (collaborator != null) PlnBadge(label: collaborator!),
            ],
          ),
          const SizedBox(height: PlnSpace.md),
          PlnText(title, role: PlnTextRole.display),
        ],
      ),
    );
  }
}

@immutable
class PlnStatusMessageData {
  const PlnStatusMessageData({
    required this.label,
    this.tone = PlnFeedbackTone.neutral,
  });

  final String label;
  final PlnFeedbackTone tone;
}

class PlnSaveStatusCard extends StatelessWidget {
  const PlnSaveStatusCard({
    super.key,
    required this.savedAt,
    required this.messages,
  });

  final String savedAt;
  final List<PlnStatusMessageData> messages;

  @override
  Widget build(BuildContext context) {
    final tokens = context.plnTheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: tokens.component,
        borderRadius: BorderRadius.circular(PlnRadius.card),
      ),
      child: Padding(
        padding: const EdgeInsets.all(PlnSpace.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PlnText('Saved $savedAt', role: PlnTextRole.code),
            const SizedBox(height: PlnSpace.sm),
            for (final message in messages)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: PlnSpace.xs),
                child: PlnText(
                  message.label,
                  role: PlnTextRole.code,
                  color: message.tone == PlnFeedbackTone.neutral
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

class PlnPropertySummary extends StatelessWidget {
  const PlnPropertySummary({
    super.key,
    required this.badges,
    required this.tags,
    required this.metadata,
  });

  final List<PlnPropertyBadgeData> badges;
  final List<String> tags;
  final String metadata;

  @override
  Widget build(BuildContext context) {
    return PlnSurface(
      tone: PlnSurfaceTone.component,
      padding: const EdgeInsets.all(PlnSpace.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: PlnSpace.xs,
            runSpacing: PlnSpace.xs,
            children: [
              for (final badge in badges)
                PlnBadge(label: badge.label, tone: badge.tone, dot: badge.dot),
            ],
          ),
          const SizedBox(height: PlnSpace.sm),
          Wrap(
            spacing: PlnSpace.xs,
            runSpacing: PlnSpace.xs,
            children: [for (final tag in tags) PlnTag(label: tag)],
          ),
          const SizedBox(height: PlnSpace.sm),
          PlnText(metadata, role: PlnTextRole.caption, tone: PlnTextTone.muted),
        ],
      ),
    );
  }
}

@immutable
class PlnPropertyBadgeData {
  const PlnPropertyBadgeData({
    required this.label,
    this.tone = PlnFeedbackTone.neutral,
    this.dot = false,
  });

  final String label;
  final PlnFeedbackTone tone;
  final bool dot;
}
