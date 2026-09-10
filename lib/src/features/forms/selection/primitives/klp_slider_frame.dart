part of '../klp_slider.dart';

class _KlpSliderFrame extends StatelessWidget {
  const _KlpSliderFrame({
    required this.value,
    required this.min,
    required this.max,
    required this.divisions,
    required this.onChanged,
    required this.style,
  });

  final double value;
  final double min;
  final double max;
  final int? divisions;
  final ValueChanged<double>? onChanged;
  final _KlpSliderStyle style;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: SliderTheme(
        data: SliderThemeData(
          activeTrackColor: style.activeTrackColor,
          inactiveTrackColor: style.inactiveTrackColor,
          overlayColor: style.overlayColor,
          trackHeight: style.trackHeight,
          thumbShape: SliderComponentShape.noThumb,
          overlayShape: SliderComponentShape.noOverlay,
          trackShape: const RectangularSliderTrackShape(),
        ),
        child: Slider(
          value: value,
          min: min,
          max: max,
          divisions: divisions,
          onChanged: onChanged,
        ),
      ),
    );
  }
}
