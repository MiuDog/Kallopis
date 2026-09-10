part of '../klp_navigator.dart';

class _KlpNavigatorInteractiveRow extends StatelessWidget {
  const _KlpNavigatorInteractiveRow({
    required this.onHoverChanged,
    required this.onTap,
    required this.child,
  });

  final ValueChanged<bool> onHoverChanged;
  final VoidCallback onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final inset = context.klp.space.navigationItemInset;
    return MouseRegion(
      onEnter: (_) => onHoverChanged(true),
      onExit: (_) => onHoverChanged(false),
      child: KlpGestureRegion(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: KlpBox(
          insets: KlpBoxInsets.directional(
            start: inset,
            top: context.klp.space.hairline,
            end: inset,
            bottom: context.klp.space.hairline,
          ),
          child: child,
        ),
      ),
    );
  }
}
