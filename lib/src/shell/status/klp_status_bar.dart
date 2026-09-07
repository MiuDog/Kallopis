import 'package:flutter/widgets.dart';

import '../../feedback/klp_status_indicator.dart';
import '../../theme/klp_theme.dart';
import 'klp_status_data.dart';

class KlpStatusBar extends StatelessWidget {
  const KlpStatusBar({super.key, required this.data});

  final KlpStatusBarData data;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact =
            constraints.maxWidth <
            context.klp.geometry.layout.statusBarBreakpoint;

        return Row(
          children: [
            Expanded(
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

class _KlpStatusGroup extends StatelessWidget {
  const _KlpStatusGroup({required this.items, this.expanded = false});

  final List<KlpStatusItemData> items;
  final bool expanded;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: expanded ? MainAxisSize.max : MainAxisSize.min,
      children: [
        for (var index = 0; index < items.length; index++) ...[
          if (expanded)
            Flexible(
              child: KlpStatusIndicator(data: items[index], expanded: true),
            )
          else
            KlpStatusIndicator(data: items[index]),
          if (index < items.length - 1)
            SizedBox(width: context.klp.space.chromeToolbarGap),
        ],
      ],
    );
  }
}
