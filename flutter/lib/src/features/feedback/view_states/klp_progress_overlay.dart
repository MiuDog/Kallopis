part of 'klp_view_states.dart';

class KlpProgressOverlay extends StatelessWidget {
  const KlpProgressOverlay({
    super.key,
    required this.child,
    required this.visible,
    required this.label,
  });

  final Widget child;
  final bool visible;
  final String label;

  @override
  Widget build(BuildContext context) {
    return KlpStack(
      children: [
        child,
        if (visible)
          KlpPositioned.fill(
            child: KlpVeil(
              child: KlpCenter(child: KlpLoadingState(label: label)),
            ),
          ),
      ],
    );
  }
}
