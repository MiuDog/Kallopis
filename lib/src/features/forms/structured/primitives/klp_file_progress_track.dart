part of '../klp_file_dropzone_field.dart';

class _KlpFileProgressTrack extends StatelessWidget {
  const _KlpFileProgressTrack({required this.value});

  final double value;

  @override
  Widget build(BuildContext context) {
    final klp = context.klp;

    return ClipRRect(
      borderRadius: BorderRadius.circular(klp.shape.control),
      child: Container(
        height: klp.shape.stroke,
        color: klp.color.border,
        alignment: Alignment.centerLeft,
        child: FractionallySizedBox(
          widthFactor: value,
          child: ColoredBox(color: klp.color.interaction),
        ),
      ),
    );
  }
}
