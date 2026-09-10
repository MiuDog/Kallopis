part of '../klp_tabs.dart';

/// 解析分頁列高度與水平捲動行為。
class _KlpTabsViewport extends StatelessWidget {
  const _KlpTabsViewport({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.klp.space.chromeTab,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: child,
      ),
    );
  }
}
