part of '../klp_file_explorer.dart';

class _KlpFileExplorerListViewport extends StatelessWidget {
  const _KlpFileExplorerListViewport({
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
      padding: EdgeInsets.symmetric(
        horizontal: context.klp.space.chromePanelInset,
      ),
      children: children,
    );
  }
}
