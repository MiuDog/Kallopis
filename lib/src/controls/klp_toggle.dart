import 'package:flutter/material.dart';

import '../foundation/klp_metrics.dart';
import '../theme/klp_theme.dart';
import '../typography/klp_text.dart';

class KlpToggle extends StatelessWidget {
  const KlpToggle({
    super.key,
    required this.value,
    required this.label,
    required this.onChanged,
    this.showLabel = true,
  });

  final bool value;
  final String label;
  final ValueChanged<bool>? onChanged;
  final bool showLabel;

  @override
  Widget build(BuildContext context) {
    final enabled = onChanged != null;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Semantics(
          button: true,
          enabled: enabled,
          label: label,
          toggled: value,
          child: Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(KlpRadius.full),
            child: InkWell(
              onTap: enabled ? () => onChanged!(!value) : null,
              borderRadius: BorderRadius.circular(KlpRadius.full),
              overlayColor: const WidgetStatePropertyAll(Colors.transparent),
              child: KlpToggleIndicator(value: value, enabled: enabled),
            ),
          ),
        ),
        if (showLabel) ...[
          const SizedBox(width: KlpSpace.sm),
          KlpText(
            label,
            tone: enabled ? KlpTextTone.primary : KlpTextTone.faint,
          ),
        ],
      ],
    );
  }
}

class KlpToggleIndicator extends StatelessWidget {
  const KlpToggleIndicator({
    super.key,
    required this.value,
    this.enabled = true,
  });

  final bool value;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final tokens = context.plnTheme;
    final trackColor = !enabled
        ? tokens.component
        : value
        ? tokens.selection
        : tokens.surfaceMuted;
    final thumbColor = !enabled
        ? tokens.textFaint
        : value
        ? tokens.onSelection
        : tokens.textMuted;

    return ExcludeSemantics(
      child: SizedBox(
        width: KlpFormMetrics.toggleWidth,
        height: KlpFormMetrics.toggleHeight,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: trackColor,
            borderRadius: BorderRadius.circular(KlpRadius.full),
          ),
          child: Padding(
            padding: const EdgeInsets.all(KlpFormMetrics.toggleInset),
            child: Align(
              alignment: value ? Alignment.centerRight : Alignment.centerLeft,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: thumbColor,
                  shape: BoxShape.circle,
                ),
                child: const SizedBox.square(
                  dimension: KlpFormMetrics.toggleThumb,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
