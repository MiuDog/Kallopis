part of '../klp_select_field.dart';

class _KlpSelectFieldChevron extends StatelessWidget {
  const _KlpSelectFieldChevron({required this.enabled});

  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final klp = context.klp;
    return KlpIcon(
      KlpIcons.chevronDown,
      size: klp.space.iconSmall,
      weight: KlpIconWeight.thin,
      color: enabled ? klp.color.textMuted : klp.color.textFaint,
    );
  }
}
