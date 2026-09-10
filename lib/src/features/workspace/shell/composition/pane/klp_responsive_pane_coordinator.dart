import 'package:flutter/widgets.dart';

import '../../../../../foundation/layout/klp_layout_builder.dart';
import 'klp_responsive_pane_breakpoint.dart';

/// 依可用寬度與 typed breakpoint 切換 Pane 呈現。
class KlpResponsivePaneCoordinator extends StatelessWidget {
  const KlpResponsivePaneCoordinator({
    super.key,
    required this.wide,
    required this.compact,
    this.breakpoint = KlpResponsivePaneBreakpoint.standard,
  });

  final Widget wide;
  final Widget compact;
  final KlpResponsivePaneBreakpoint breakpoint;

  @override
  Widget build(BuildContext context) => KlpLayoutBuilder(
    builder: (context, constraints) =>
        constraints.maxWidth >= breakpoint.resolve(context) ? wide : compact,
  );
}
