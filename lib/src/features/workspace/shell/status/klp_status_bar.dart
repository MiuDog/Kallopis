import 'package:flutter/widgets.dart';

import '../../../feedback/klp_status_indicator.dart';
import '../../../../foundation/layout/klp_layout.dart';
import '../../../../styling/legacy_theme/klp_theme.dart';
import 'klp_status_data.dart';

part 'internal/klp_status_group.dart';

/// 狀態列元件。內部指示器使用 [KlpTextRole.status]。
class KlpStatusBar extends StatelessWidget {
  const KlpStatusBar({super.key, required this.data});

  final KlpStatusBarData data;

  @override
  Widget build(BuildContext context) {
    return KlpLayoutBuilder(
      builder: (context, constraints) {
        final compact =
            constraints.maxWidth <
            context.klp.geometry.layout.statusBarBreakpoint;

        return KlpRow(
          children: [
            KlpExpanded(
              child: _KlpStatusGroup(items: data.leading, expanded: true),
            ),
            if (!compact && data.trailing.isNotEmpty)
              _KlpStatusGroup(items: data.trailing),
          ],
        );
      },
    );
  }
}
