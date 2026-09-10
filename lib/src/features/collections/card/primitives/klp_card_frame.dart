part of '../klp_card.dart';

class _KlpCardFrame extends StatelessWidget {
  const _KlpCardFrame({
    required this.tone,
    required this.selected,
    required this.child,
  });

  final KlpCardTone tone;
  final bool selected;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final klp = context.klp;
    final tokens = context.klpColors;
    final background = switch (tone) {
      KlpCardTone.component => tokens.component,
      KlpCardTone.surface => tokens.surface,
      KlpCardTone.muted => tokens.surfaceMuted,
      KlpCardTone.raised => tokens.surfaceRaised,
    };
    final effectiveBackground = selected
        ? Color.alphaBlend(klp.selectionWash, background)
        : background;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: effectiveBackground,
        borderRadius: BorderRadius.circular(klp.cardRadius),
      ),
      child: child,
    );
  }
}
