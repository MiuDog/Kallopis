part of '../klp_list_tile.dart';

/// 以一致的 Kallopis 視覺呈現可選取的單列資料或動作。
class KlpListTile extends StatelessWidget {
  const KlpListTile({
    super.key,
    required this.title,
    this.subtitle,
    this.icon,
    this.trailing,
    this.selected = false,
    this.onPressed,
    this.compact = false,
    this.tone,
  });

  final String title;
  final String? subtitle;
  final KlpIconData? icon;
  final Widget? trailing;
  final bool selected;
  final VoidCallback? onPressed;
  final bool compact;
  final KlpFeedbackTone? tone;

  @override
  Widget build(BuildContext context) {
    final colors = context.klpColors;
    final style = _KlpListTileFrameStyle.resolve(
      context,
      tone: tone,
      selected: selected,
      compact: compact,
    );

    return _KlpListTileFrame(
      onPressed: onPressed,
      selected: selected,
      style: style,
      child: KlpRow(
        children: [
          if (icon != null) ...[
            KlpIcon(
              icon!,
              size: context.klp.space.iconSmall,
              color: selected ? colors.selectionForeground : colors.textMuted,
            ),
            KlpGap.widthSize(
              compact ? KlpSpaceSize.tight : KlpSpaceSize.contentInline,
            ),
          ],
          KlpExpanded(
            child: KlpColumn(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                KlpText(
                  title,
                  role: compact ? KlpTextRole.sub : KlpTextRole.body,
                  tone: selected ? KlpTextTone.primary : KlpTextTone.muted,
                ),
                if (subtitle != null) ...[
                  const KlpGap.heightSize(KlpSpaceSize.tight),
                  KlpText(
                    subtitle!,
                    role: KlpTextRole.caption,
                    tone: selected ? KlpTextTone.muted : KlpTextTone.faint,
                  ),
                ],
              ],
            ),
          ),
          ?trailing,
        ],
      ),
    );
  }
}
