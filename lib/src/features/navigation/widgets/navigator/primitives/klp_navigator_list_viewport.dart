part of '../klp_navigator.dart';

class _KlpNavigatorListViewport extends StatelessWidget {
  const _KlpNavigatorListViewport({
    super.key,
    required this.controller,
    required this.children,
  });

  final ScrollController? controller;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return ListView(
      controller: controller,
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      padding: EdgeInsets.zero,
      children: children,
    );
  }
}
