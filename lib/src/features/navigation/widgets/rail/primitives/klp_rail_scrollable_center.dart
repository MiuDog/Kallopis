part of '../klp_navigation_rail.dart';

class _KlpRailScrollableCenter extends StatelessWidget {
  const _KlpRailScrollableCenter({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return ScrollConfiguration(
          behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Align(alignment: Alignment.topCenter, child: child),
            ),
          ),
        );
      },
    );
  }
}
