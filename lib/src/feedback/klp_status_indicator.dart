import 'package:flutter/material.dart';

import '../foundation/klp_icon.dart';
import '../foundation/klp_icons.dart';
import '../theme/klp_theme.dart';
import '../typography/klp_text.dart';

/// 狀態指示樣式：圓點 (dot)、運行中 (running)、雙色分割圓點 (splitDot)、核取勾 (check)、叉號 (cross)、等待計時 (waiting)、空心圓 (circle)。
enum KlpStatusKind {
  /// 實心圓點。
  dot,

  /// 運行中指示（Loader 弧線）。
  running,

  /// 雙色分割圓點（如藍/青色運行中）。
  splitDot,

  /// 核取勾標記 (✓)。
  check,

  /// 叉號標記 (✕)。
  cross,

  /// 等待／計時器標記 (⏱)。
  waiting,

  /// 空心圓標記 (○)。
  circle,
}

/// 狀態指示標記與文字。
class KlpStatusIndicator extends StatelessWidget {
  const KlpStatusIndicator({
    super.key,
    required this.label,
    this.active = true,
    this.kind = KlpStatusKind.dot,
    this.color,
    this.expanded = false,
  });

  /// 狀態標籤文字。
  final String label;

  /// 是否處於啟用或活動狀態。
  final bool active;

  /// 指示圖示種類。
  final KlpStatusKind kind;

  /// 自訂狀態標記顏色；標籤仍沿用狀態列的 muted 文字語意。
  final Color? color;

  /// 是否占滿可用寬度，並讓標籤在空間不足時省略。
  final bool expanded;

  @override
  Widget build(BuildContext context) {
    final tokens = context.klpColors;
    final defaultColor = switch (kind) {
      KlpStatusKind.running || KlpStatusKind.splitDot => tokens.info,
      KlpStatusKind.check => tokens.success,
      KlpStatusKind.cross => tokens.danger,
      KlpStatusKind.waiting => tokens.warning,
      KlpStatusKind.circle => tokens.textMuted,
      KlpStatusKind.dot => active ? tokens.success : tokens.textFaint,
    };
    final effectiveColor = color ?? defaultColor;

    final Widget iconWidget = switch (kind) {
      KlpStatusKind.running => KlpIcon(
        KlpIcons.loader,
        size: context.klp.space.iconMicro,
        color: effectiveColor,
      ),
      KlpStatusKind.splitDot => KlpIcon(
        KlpIcons.loader,
        size: context.klp.space.iconMicro,
        color: effectiveColor,
      ),
      KlpStatusKind.check => KlpIcon(
        KlpIcons.check,
        size: context.klp.space.iconMicro,
        color: effectiveColor,
      ),
      KlpStatusKind.cross => KlpIcon(
        KlpIcons.x,
        size: context.klp.space.iconMicro,
        color: effectiveColor,
      ),
      KlpStatusKind.waiting => KlpIcon(
        KlpIcons.timer,
        size: context.klp.space.iconMicro,
        color: effectiveColor,
      ),
      KlpStatusKind.circle => KlpIcon(
        KlpIcons.circle,
        size: context.klp.space.iconTiny,
        color: effectiveColor,
      ),
      KlpStatusKind.dot => Container(
        width: context.klp.space.indicatorDot,
        height: context.klp.space.indicatorDot,
        decoration: BoxDecoration(
          color: effectiveColor,
          shape: BoxShape.circle,
        ),
      ),
    };

    final labelWidget = KlpText(
      label,
      role: KlpTextRole.code,
      tone: KlpTextTone.muted,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );

    return Row(
      mainAxisSize: expanded ? MainAxisSize.max : MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Transform.translate(
          offset: Offset(0, context.klp.geometry.optical.statusIconOffsetY),
          child: iconWidget,
        ),
        SizedBox(width: context.klp.space.compact),
        if (expanded) Expanded(child: labelWidget) else labelWidget,
      ],
    );
  }
}
