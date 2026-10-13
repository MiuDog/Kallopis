part of '../klp_stage_frame.dart';

/// 解析舞台 status 區域的語意高度。
class _KlpStageStatusSlot extends StatelessWidget {
  const _KlpStageStatusSlot({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: context.klp.space.chromeStatusBar, child: child);
  }
}
