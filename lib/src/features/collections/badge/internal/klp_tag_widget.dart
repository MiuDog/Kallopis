part of '../klp_badge.dart';

/// 可移除或可點擊的分類標籤。
class KlpTag extends StatelessWidget {
  const KlpTag({super.key, required this.label, this.prefix, this.onRemove});

  /// 標籤文字。
  final String label;

  /// 前綴符號，例如 `#`。
  final String? prefix;

  /// 移除標籤的回呼。
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    return _KlpTagFrame(
      child: KlpRow(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (prefix != null) ...[
            KlpText(
              prefix!,
              role: KlpTextRole.caption,
              tone: KlpTextTone.muted,
            ),
            const KlpGap.widthSize(KlpSpaceSize.xxs),
          ],
          KlpFlexible(
            child: KlpText(
              label,
              role: KlpTextRole.caption,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (onRemove != null) ...[
            const KlpGap.widthSize(KlpSpaceSize.tight),
            KlpGestureRegion(
              onTap: onRemove,
              behavior: HitTestBehavior.opaque,
              child: const KlpText('×', role: KlpTextRole.bodyStrong),
            ),
          ],
        ],
      ),
    );
  }
}
