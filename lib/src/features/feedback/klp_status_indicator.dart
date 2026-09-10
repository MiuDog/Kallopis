import 'package:flutter/widgets.dart';

import '../../foundation/layout/klp_layout.dart';
import '../workspace/shell/status/klp_status_data.dart';
import '../../styling/legacy_theme/klp_theme.dart';
import '../../foundation/content/klp_text.dart';

part 'primitives/klp_status_dot.dart';

/// 狀態指示標記與文字。
class KlpStatusIndicator extends StatelessWidget {
  const KlpStatusIndicator({
    super.key,
    required this.data,
    this.expanded = false,
  });

  /// 由容器注入的狀態資料。
  final KlpStatusItemData data;

  /// 是否占滿可用寬度，並讓標籤在空間不足時省略。
  final bool expanded;

  @override
  Widget build(BuildContext context) {
    final tokens = context.klpColors;
    final defaultColor = switch (data.kind) {
      KlpStatusKind.running || KlpStatusKind.splitDot => tokens.info,
      KlpStatusKind.check => tokens.success,
      KlpStatusKind.cross => tokens.danger,
      KlpStatusKind.waiting => tokens.warning,
      KlpStatusKind.circle => tokens.textMuted,
      KlpStatusKind.dot => data.active ? tokens.success : tokens.textFaint,
    };
    final effectiveColor = data.color ?? defaultColor;
    final labelWidget = KlpText(
      data.label,
      role: KlpTextRole.status,
      tone: KlpTextTone.muted,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );

    return KlpRow(
      mainAxisSize: expanded ? MainAxisSize.max : MainAxisSize.min,
      children: [
        if (data.showsIndicator) ...[
          _KlpStatusDot(color: effectiveColor),
          const KlpGap.widthSize(KlpSpaceSize.contentInline),
        ],
        if (expanded)
          KlpExpanded(child: labelWidget)
        else
          KlpFlexible(child: labelWidget),
      ],
    );
  }
}
