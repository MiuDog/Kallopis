import 'package:flutter/material.dart';

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
            color: context.klpColors.clear,
            borderRadius: BorderRadius.circular(context.klp.shape.toggleTrack),
            child: InkWell(
              onTap: enabled ? () => onChanged!(!value) : null,
              borderRadius: BorderRadius.circular(
                context.klp.shape.toggleTrack,
              ),
              overlayColor: WidgetStatePropertyAll(context.klpColors.clear),
              child: KlpToggleIndicator(value: value, enabled: enabled),
            ),
          ),
        ),
        if (showLabel) ...[
          SizedBox(width: context.klp.space.compact),
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
    final tokens = context.klpColors;
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
        width: context.klp.geometry.control.toggleWidth,
        height: context.klp.geometry.control.toggleHeight,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: trackColor,
            borderRadius: BorderRadius.circular(context.klp.shape.toggleTrack),
          ),
          child: Padding(
            padding: EdgeInsets.all(context.klp.geometry.control.toggleInset),
            child: Align(
              alignment: value ? Alignment.centerRight : Alignment.centerLeft,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: thumbColor,
                  borderRadius: BorderRadius.circular(context.klp.shape.sm),
                ),
                child: SizedBox.square(
                  dimension: context.klp.geometry.control.toggleThumb,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
