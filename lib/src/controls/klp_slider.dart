import 'package:flutter/material.dart';

import '../theme/klp_theme.dart';
import '../typography/klp_text.dart';

class KlpSlider extends StatelessWidget {
  const KlpSlider({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.min = 0.0,
    this.max = 1.0,
    this.divisions,
    this.displayValue,
    this.marks,
  });

  final String label;
  final double value;
  final ValueChanged<double>? onChanged;
  final double min;
  final double max;
  final int? divisions;
  final String? displayValue;
  final List<String>? marks;

  @override
  Widget build(BuildContext context) {
    final tokens = context.klpColors;
    final klp = context.klp;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(child: KlpText(label, role: KlpTextRole.caption)),
            KlpText(
              displayValue ?? '${(value * 100).round()}%',
              role: KlpTextRole.code,
              tone: KlpTextTone.muted,
            ),
          ],
        ),
        Material(
          type: MaterialType.transparency,
          child: SliderTheme(
            data: SliderThemeData(
              activeTrackColor: tokens.interaction,
              inactiveTrackColor: tokens.surfaceInset,
              overlayColor: Colors.transparent,
              trackHeight: klp.shape.stroke * 2,
              thumbShape: SliderComponentShape.noThumb,
              overlayShape: SliderComponentShape.noOverlay,
              trackShape: const RectangularSliderTrackShape(),
            ),
            child: Slider(
              value: value.clamp(min, max),
              min: min,
              max: max,
              divisions: divisions,
              onChanged: onChanged,
            ),
          ),
        ),
        if (marks != null && marks!.isNotEmpty) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              for (final mark in marks!)
                KlpText(
                  mark,
                  role: KlpTextRole.caption,
                  tone: KlpTextTone.faint,
                ),
            ],
          ),
        ],
      ],
    );
  }
}
