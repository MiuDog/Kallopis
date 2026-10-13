part of '../klp_timeline.dart';

class _KlpTimelineIntrinsicHeight extends StatelessWidget {
  const _KlpTimelineIntrinsicHeight({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => IntrinsicHeight(child: child);
}
