import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import '../../../../foundation/layout/klp_directional_position.dart';
import '../../../../foundation/layout/klp_directional_positioned.dart';
import '../../../../foundation/layout/klp_gap.dart';
import '../../../../foundation/layout/klp_row.dart';
import '../../../../foundation/layout/klp_space_size.dart';
import '../../../../foundation/layout/klp_stack.dart';
import '../../../../styling/legacy_theme/klp_theme.dart';

export 'klp_stage_tab.dart';

/// 位於 Workbench window header 中央 Stage 區域的分頁與動作列。
class KlpStageTopBar extends StatelessWidget {
  const KlpStageTopBar({super.key, required this.tab, this.actions = const []});

  final Widget tab;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    final space = context.klp.space;
    final actionHeight = math.max(space.chromeTab, space.controlHeightXSmall);

    return KlpStack(
      children: [
        KlpDirectionalPositioned(
          position: const KlpDirectionalPosition(start: 0, top: 0, bottom: 0),
          child: tab,
        ),
        if (actions.isNotEmpty)
          KlpDirectionalPositioned(
            position: KlpDirectionalPosition(
              end: 0,
              top: 0,
              height: actionHeight,
            ),
            child: KlpRow(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (var index = 0; index < actions.length; index++) ...[
                  if (index > 0) const KlpGap.widthSize(KlpSpaceSize.tight),
                  actions[index],
                ],
              ],
            ),
          ),
      ],
    );
  }
}
