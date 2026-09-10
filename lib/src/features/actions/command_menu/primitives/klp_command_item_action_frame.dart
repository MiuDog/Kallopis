part of '../klp_command_menu.dart';

class _KlpCommandItemActionFrame extends StatelessWidget {
  const _KlpCommandItemActionFrame({
    required this.onPressed,
    required this.selected,
    required this.highlighted,
    required this.child,
  });

  final VoidCallback? onPressed;
  final bool selected;
  final bool highlighted;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      enabled: onPressed != null,
      selected: selected,
      child: Material(
        color: highlighted
            ? context.klpColors.surfaceMuted
            : context.klpColors.clear,
        borderRadius: BorderRadius.circular(context.klp.shape.control),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(context.klp.shape.control),
          child: child,
        ),
      ),
    );
  }
}
