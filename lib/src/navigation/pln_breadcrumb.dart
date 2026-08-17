import 'package:flutter/widgets.dart';

import '../foundation/pln_metrics.dart';
import '../typography/pln_text.dart';

class PlnBreadcrumb extends StatelessWidget {
  const PlnBreadcrumb({
    super.key,
    required this.segments,
    required this.onSelected,
  });

  final List<String> segments;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: PlnSpace.sm,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        for (var index = 0; index < segments.length; index++) ...[
          GestureDetector(
            onTap: () => onSelected(index),
            child: PlnText(
              segments[index],
              role: PlnTextRole.body,
              tone: index == segments.length - 1
                  ? PlnTextTone.primary
                  : PlnTextTone.muted,
            ),
          ),
          if (index < segments.length - 1)
            const PlnText('/', tone: PlnTextTone.faint),
        ],
      ],
    );
  }
}
