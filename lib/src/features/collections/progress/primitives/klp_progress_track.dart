part of '../klp_progress.dart';

class _KlpProgressTrack extends StatelessWidget {
  const _KlpProgressTrack({required this.value, required this.state});

  final double? value;
  final KlpProgressState state;

  @override
  Widget build(BuildContext context) {
    final colors = context.klpColors;
    final fillColor = switch (state) {
      KlpProgressState.active => colors.text,
      KlpProgressState.paused => colors.warning,
      KlpProgressState.success => colors.success,
      KlpProgressState.failure => colors.danger,
    };

    return Container(
      height: context.klp.space.progressTrack,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: colors.surfaceMuted,
        borderRadius: BorderRadius.circular(context.klp.shape.pill),
      ),
      alignment: Alignment.centerLeft,
      child: FractionallySizedBox(
        widthFactor:
            value ?? context.klp.geometry.data.progressIndeterminateFraction,
        child: ColoredBox(color: fillColor),
      ),
    );
  }
}
