part of '../klp_command_menu.dart';

class _KlpCommandMenuSurfaceFrame extends StatelessWidget {
  const _KlpCommandMenuSurfaceFrame({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.klpColors.component,
        borderRadius: BorderRadius.circular(context.klp.shape.card),
      ),
      child: child,
    );
  }
}
