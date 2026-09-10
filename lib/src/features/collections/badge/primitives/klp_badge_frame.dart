part of '../klp_badge.dart';

class _KlpBadgeFrame extends StatelessWidget {
  const _KlpBadgeFrame({
    required this.tone,
    required this.variant,
    required this.builder,
  });

  final KlpFeedbackTone tone;
  final KlpBadgeVariant variant;
  final Widget Function(BuildContext context, _KlpBadgeStyle style) builder;

  @override
  Widget build(BuildContext context) {
    final colors = context.klpColors;
    final theme = context.klp;
    final toneColor = tone == KlpFeedbackTone.neutral
        ? colors.textMuted
        : tone.color(colors);
    final isNeutral = tone == KlpFeedbackTone.neutral;
    final (background, border, text) = switch (variant) {
      KlpBadgeVariant.outline => (null, toneColor, toneColor),
      KlpBadgeVariant.solid => (colors.text, null, colors.stageSurface),
      KlpBadgeVariant.filled when isNeutral => (
        colors.component,
        colors.divider,
        colors.text,
      ),
      KlpBadgeVariant.filled => (
        toneColor.withValues(alpha: theme.surface.statusFillOpacity),
        toneColor,
        colors.text,
      ),
    };

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: theme.badgePaddingX,
        vertical: theme.space.xxs,
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(theme.badgeRadius),
        border: border == null
            ? null
            : Border.all(color: border, width: theme.shape.hairline),
      ),
      child: builder(context, _KlpBadgeStyle(text: text, dot: toneColor)),
    );
  }
}
