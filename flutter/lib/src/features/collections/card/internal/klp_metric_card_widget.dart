part of '../klp_card.dart';

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
    final isDanger = tone == KlpFeedbackTone.danger;
    final valueTone = isDanger ? KlpTextTone.danger : KlpTextTone.primary;
    final subtitleTone = isDanger ? KlpTextTone.danger : KlpTextTone.muted;

    return _KlpMetricCardFrame(
      tone: tone,
      child: KlpColumn(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          KlpText(
            label.toUpperCase(),
            role: KlpTextRole.caption,
            tone: KlpTextTone.muted,
          ),
          const KlpGap.heightSize(KlpSpaceSize.contentStack),
          if (value != null)
            _KlpMetricCardValueFit(
              child: KlpRow(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  KlpText(value!, role: KlpTextRole.title, tone: valueTone),
                  if (unit != null) ...[
                    const KlpGap.widthSize(KlpSpaceSize.tight),
                    KlpText(unit!, role: KlpTextRole.body, tone: valueTone),
                  ],
                  if (trend != null) ...[
                    const KlpGap.widthSize(KlpSpaceSize.tight),
                    KlpText(trend!, role: KlpTextRole.code, tone: valueTone),
                  ],
                ],
              ),
            ),
          if (child != null) ...[
            const KlpGap.heightSize(KlpSpaceSize.contentStack),
            child!,
          ],
          if (subtitle != null) ...[
            const KlpGap.heightSize(KlpSpaceSize.contentStack),
            KlpText(subtitle!, role: KlpTextRole.caption, tone: subtitleTone),
          ],
        ],
      ),
    );
  }
}
