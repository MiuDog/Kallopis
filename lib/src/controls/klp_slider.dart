import 'package:flutter/material.dart';

import '../foundation/klp_metrics.dart';
import '../theme/klp_theme.dart';
import '../typography/klp_text.dart';
import '../foundation/klp_palette.dart';

class KlpSlider extends StatelessWidget {
  const KlpSlider({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final double value;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    final tokens = context.klpColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(child: KlpText(label, role: KlpTextRole.caption)),
            KlpText(
              '${(value * 100).round()}%',
              role: KlpTextRole.code,
              tone: KlpTextTone.muted,
            ),
          ],
        ),
        SliderTheme(
          data: SliderThemeData(
            activeTrackColor: tokens.text,
            inactiveTrackColor: tokens.surfaceMuted,
            thumbColor: tokens.surfaceInset,
            overlayColor: KlpPalette.transparent,
            trackHeight: KlpLine.width,
            thumbShape: _KlpSliderThumb(tokens.borderStrong),
          ),
          child: Slider(value: value, onChanged: onChanged),
        ),
      ],
    );
  }
}

class _KlpSliderThumb extends SliderComponentShape {
  const _KlpSliderThumb(this.color);

  final Color color;

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return const Size.square(16);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    final fill = Paint()..color = sliderTheme.thumbColor!;
    final outline = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = KlpLine.width;

    context.canvas.drawCircle(center, 7, fill);
    context.canvas.drawCircle(center, 7, outline);
  }
}
