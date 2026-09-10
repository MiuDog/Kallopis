part of '../klp_card.dart';

class _KlpMetricCardFrame extends StatelessWidget {
  const _KlpMetricCardFrame({required this.tone, required this.child});

  final KlpFeedbackTone tone;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final klp = context.klp;
    final tokens = context.klpColors;
    final borderColor = tone == KlpFeedbackTone.danger
        ? tokens.danger
        : tokens.divider;

    return ClipRRect(
      borderRadius: BorderRadius.circular(klp.shape.card),
      child: Container(
        padding: EdgeInsets.all(klp.space.comfortable),
        decoration: BoxDecoration(
          color: tokens.component,
          borderRadius: BorderRadius.circular(klp.shape.card),
          border: Border.all(color: borderColor, width: klp.shape.hairline),
        ),
        child: child,
      ),
    );
  }
}
