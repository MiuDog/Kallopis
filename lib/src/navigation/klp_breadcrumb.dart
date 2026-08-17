import 'package:flutter/widgets.dart';

import '../foundation/klp_metrics.dart';
import '../typography/klp_text.dart';

class KlpBreadcrumb extends StatelessWidget {
  const KlpBreadcrumb({
    super.key,
    required this.segments,
    required this.onSelected,
  });

  final List<String> segments;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: KlpSpace.sm,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        for (var index = 0; index < segments.length; index++) ...[
          GestureDetector(
            onTap: () => onSelected(index),
            child: KlpText(
              segments[index],
              role: KlpTextRole.body,
              tone: index == segments.length - 1
                  ? KlpTextTone.primary
                  : KlpTextTone.muted,
            ),
          ),
          if (index < segments.length - 1)
            const KlpText('/', tone: KlpTextTone.faint),
        ],
      ],
    );
  }
}
