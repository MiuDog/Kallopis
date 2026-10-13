part of '../klp_stage_frame.dart';

/// 解析舞台 header 的語意最小高度。
class _KlpStageHeaderSlot extends StatelessWidget {
  const _KlpStageHeaderSlot({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: context.klp.space.chromeHeader),
      child: child,
    );
  }
}
