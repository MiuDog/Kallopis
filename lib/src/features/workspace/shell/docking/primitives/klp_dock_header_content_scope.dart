part of '../klp_dock_layout.dart';

class _KlpDockHeaderContentScope extends StatelessWidget {
  const _KlpDockHeaderContentScope({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final type = context.klp.type;
    final definition = KlpTextStyles.definitionOf(KlpTextRole.code, type);
    final color = KlpTextStyles.colorFor(
      context.klpColors,
      role: KlpTextRole.code,
    );

    return DefaultTextStyle(
      style: definition.toTextStyle(type).copyWith(color: color),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      child: child,
    );
  }
}
