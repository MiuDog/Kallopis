import 'package:flutter/widgets.dart';

import '../typography/klp_text.dart';
import '../theme/klp_theme.dart';

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
      spacing: context.klp.space.compact,
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
