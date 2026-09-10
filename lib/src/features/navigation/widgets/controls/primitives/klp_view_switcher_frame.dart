part of '../klp_view_switcher.dart';

class _KlpViewSwitcherFrame extends StatelessWidget {
  const _KlpViewSwitcherFrame({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return KlpSurface(
      tone: KlpSurfaceTone.inset,
      radius: context.klp.shape.control,
      padding: EdgeInsets.all(context.klp.space.hairline),
      child: child,
    );
  }
}
