part of '../klp_advanced_data.dart';

class _KlpTreeDisclosure extends StatelessWidget {
  const _KlpTreeDisclosure({required this.expanded, required this.child});

  final bool expanded;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return RotatedBox(quarterTurns: expanded ? 0 : 3, child: child);
  }
}
