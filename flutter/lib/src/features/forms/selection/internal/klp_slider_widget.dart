part of '../klp_slider.dart';

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
    return KlpColumn(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        KlpRow(
          children: [
            KlpExpanded(child: KlpText(label, role: KlpTextRole.caption)),
            KlpText(
              displayValue ?? '${(value * 100).round()}%',
              role: KlpTextRole.code,
              tone: KlpTextTone.muted,
            ),
          ],
        ),
        _KlpSliderFrame(
          value: value.clamp(min, max),
          min: min,
          max: max,
          divisions: divisions,
          onChanged: onChanged,
          style: _KlpSliderStyle.resolve(context.klp),
        ),
        if (marks != null && marks!.isNotEmpty)
          KlpRow(
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
    );
  }
}
