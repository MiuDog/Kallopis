import 'package:flutter/material.dart';

import '../shell/status/klp_status_data.dart';
import '../theme/klp_theme.dart';
import '../typography/klp_text.dart';

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

    final dot = Container(
      width: context.klp.space.indicatorDot,
      height: context.klp.space.indicatorDot,
      decoration: BoxDecoration(color: effectiveColor, shape: BoxShape.circle),
    );

    final labelWidget = KlpText(
      data.label,
      role: KlpTextRole.status,
      tone: KlpTextTone.muted,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );

    return Row(
      mainAxisSize: expanded ? MainAxisSize.max : MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (data.showsIndicator) ...[
          dot,
          SizedBox(width: context.klp.space.contentInlineGap),
        ],
        if (expanded)
          Expanded(child: labelWidget)
        else
          Flexible(child: labelWidget),
      ],
    );
  }
}
