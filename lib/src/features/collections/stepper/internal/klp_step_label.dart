part of '../klp_stepper.dart';

class _KlpStepLabel extends StatelessWidget {
  const _KlpStepLabel({
    required this.step,
    required this.status,
    required this.direction,
  });

  final KlpStepData step;
  final KlpStepStatus status;
  final KlpStepperDirection direction;

  @override
  Widget build(BuildContext context) {
    final emphasized = status != KlpStepStatus.upcoming;
    final horizontal = direction == KlpStepperDirection.horizontal;
    final alignment = horizontal ? TextAlign.center : TextAlign.start;

    return KlpColumn(
      crossAxisAlignment: horizontal
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        KlpText(
          step.label,
          role: KlpTextRole.bodyStrong,
          tone: emphasized ? KlpTextTone.primary : KlpTextTone.faint,
          textAlign: alignment,
        ),
        if (step.description != null) ...[
          KlpBox(height: context.klp.space.tight),
          KlpText(
            step.description!,
            role: KlpTextRole.caption,
            tone: KlpTextTone.muted,
            textAlign: alignment,
          ),
        ],
      ],
    );
  }
}
