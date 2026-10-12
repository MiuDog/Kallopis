part of '../klp_panel_header.dart';

/// 解析面板標題列的外殼內距。
class _KlpPanelHeaderFrame extends StatelessWidget {
  const _KlpPanelHeaderFrame({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: context.klp.space.chromePanelInset,
        vertical: context.klp.space.tight,
      ),
      child: child,
    );
  }
}
