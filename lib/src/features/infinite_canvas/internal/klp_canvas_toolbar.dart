part of '../klp_canvas_workspace.dart';

/// 畫布上的有限動作工具列；動作能力由呼叫端決定。
class KlpCanvasToolbar extends StatelessWidget {
  const KlpCanvasToolbar({super.key, required this.actions});

  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    return KlpBox(
      tone: KlpSurfaceTone.raised,
      paddingSize: KlpSpaceSize.tight,
      child: KlpWrap(
        spacingSize: KlpSpaceSize.tight,
        runSpacingSize: KlpSpaceSize.tight,
        children: actions,
      ),
    );
  }
}
