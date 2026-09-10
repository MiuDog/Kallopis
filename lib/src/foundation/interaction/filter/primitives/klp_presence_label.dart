part of '../klp_presence_indicator.dart';

class _KlpPresenceLabel extends StatelessWidget {
  const _KlpPresenceLabel({required this.label, required this.active});

  final String label;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return KlpText(
      label,
      role: KlpTextRole.caption,
      color: active ? context.klpColors.success : context.klpColors.textFaint,
    );
  }
}
