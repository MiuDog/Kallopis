part of '../klp_shortcut_hint.dart';

class _KlpShortcutHintFrame extends StatelessWidget {
  const _KlpShortcutHintFrame({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return KlpSurface(
      tone: KlpSurfaceTone.muted,
      radius: context.klp.shape.control,
      padding: EdgeInsets.symmetric(
        horizontal: context.klp.space.tight,
        vertical: context.klp.space.hairline,
      ),
      child: child,
    );
  }
}
