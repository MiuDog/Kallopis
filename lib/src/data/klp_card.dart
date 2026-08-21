import 'package:flutter/material.dart';

import '../feedback/klp_feedback_tone.dart';
import '../theme/klp_theme.dart';
import '../typography/klp_text.dart';

/// 內容卡片。
class KlpCard extends StatelessWidget {
  const KlpCard({
    super.key,
    required this.title,
    required this.child,
    this.label,
    this.leading,
    this.trailing,
    this.footer,
    this.selected = false,
    this.backgroundColor,
  });

  final String title;
  final String? label;
  final Widget? leading;
  final Widget? trailing;
  final Widget child;
  final Widget? footer;
  final bool selected;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final klp = context.klp;
    final tokens = context.klpColors;
    final effectiveBackground = backgroundColor ?? tokens.component;

    final card = DecoratedBox(
      decoration: BoxDecoration(
        color: selected
            ? Color.alphaBlend(klp.selectionWash, effectiveBackground)
            : effectiveBackground,
        borderRadius: BorderRadius.circular(klp.cardRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.all(klp.cardPadding),
            child: Row(
              children: [
                if (leading != null) ...[
                  leading!,
                  SizedBox(width: klp.space.compact),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (label != null)
                        KlpText(label!, role: KlpTextRole.label),
                      KlpText(title, role: KlpTextRole.bodyStrong),
                    ],
                  ),
                ),
                trailing ?? const SizedBox.shrink(),
              ],
            ),
          ),
          Padding(padding: EdgeInsets.all(klp.cardPadding), child: child),
          if (footer != null)
            Padding(padding: EdgeInsets.all(klp.space.compact), child: footer!),
        ],
      ),
    );

    return card;
  }
}

/// 指標呈現卡片 (Metric Card)。
///
/// 呈現標籤、核心數值、單位、趨勢箭頭、狀態說明或迷你進度長條。
/// 支援正常（neutral/success）與違規告警（danger 具備紅色外框與文字）。
class KlpMetricCard extends StatelessWidget {
  const KlpMetricCard({
    super.key,
    required this.label,
    this.value,
    this.unit,
    this.trend,
    this.subtitle,
    this.tone = KlpFeedbackTone.neutral,
    this.child,
  });

  /// 指標標籤（如 'PASS RATE', 'P95 LATENCY'）。
  final String label;

  /// 數值（如 '98.2', '1420'）。
  final String? value;

  /// 數值單位（如 '%', 'ms'）。
  final String? unit;

  /// 趨勢或指標符號（如 '↑', '↓'）。
  final String? trend;

  /// 底部說明（如 'Threshold 95%', 'Breached · threshold 800ms'）。
  final String? subtitle;

  /// 狀態語意色調。為 danger 時卡片邊框與數值呈現紅色。
  final KlpFeedbackTone tone;

  /// 自訂內容（如進度條）。
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final klp = context.klp;
    final tokens = context.klpColors;
    final isDanger = tone == KlpFeedbackTone.danger;

    final borderColor = isDanger ? tokens.danger : tokens.divider;
    final valueColor = isDanger ? tokens.danger : tokens.text;
    final subtitleColor = isDanger ? tokens.danger : tokens.textMuted;

    return ClipRRect(
      borderRadius: BorderRadius.circular(klp.shape.card),
      child: Container(
        padding: EdgeInsets.all(klp.space.comfortable),
        decoration: BoxDecoration(
          color: tokens.component,
          borderRadius: BorderRadius.circular(klp.shape.card),
          border: Border.all(color: borderColor, width: klp.shape.hairline),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            KlpText(
              label.toUpperCase(),
              role: KlpTextRole.caption,
              tone: KlpTextTone.muted,
            ),
            SizedBox(height: klp.space.compact),
            if (value != null) ...[
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    KlpText(value!, role: KlpTextRole.title, color: valueColor),
                    if (unit != null) ...[
                      SizedBox(width: klp.space.tight),
                      KlpText(unit!, role: KlpTextRole.body, color: valueColor),
                    ],
                    if (trend != null) ...[
                      SizedBox(width: klp.space.tight),
                      KlpText(
                        trend!,
                        role: KlpTextRole.code,
                        color: valueColor,
                      ),
                    ],
                  ],
                ),
              ),
            ],
            if (child != null) ...[SizedBox(height: klp.space.compact), child!],
            if (subtitle != null) ...[
              SizedBox(height: klp.space.compact),
              KlpText(
                subtitle!,
                role: KlpTextRole.caption,
                color: subtitleColor,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
