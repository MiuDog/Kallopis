import 'package:flutter/material.dart';

import '../foundation/pln_metrics.dart';
import '../theme/pln_theme.dart';
import '../typography/pln_text.dart';

class PlnSlider extends StatelessWidget {
  const PlnSlider({
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
    final tokens = context.plnTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(child: PlnText(label, role: PlnTextRole.caption)),
            PlnText(
              '${(value * 100).round()}%',
              role: PlnTextRole.code,
              tone: PlnTextTone.muted,
            ),
          ],
        ),
        SliderTheme(
          data: SliderThemeData(
            activeTrackColor: tokens.text,
            inactiveTrackColor: tokens.surfaceMuted,
            thumbColor: tokens.surfaceInset,
            overlayColor: const Color(0x00000000),
            trackHeight: PlnLine.width,
            thumbShape: _PlnSliderThumb(tokens.borderStrong),
          ),
          child: Slider(value: value, onChanged: onChanged),
        ),
      ],
    );
  }
}

class _PlnSliderThumb extends SliderComponentShape {
  const _PlnSliderThumb(this.color);

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
      ..strokeWidth = PlnLine.width;

    context.canvas.drawCircle(center, 7, fill);
    context.canvas.drawCircle(center, 7, outline);
  }
}
