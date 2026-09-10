part of '../klp_button.dart';

class _KlpButtonContent extends StatelessWidget {
  const _KlpButtonContent({
    required this.label,
    required this.leading,
    required this.trailing,
    required this.style,
  });

  final String label;
  final Widget? leading;
  final Widget? trailing;
  final KlpButtonStyle style;

  @override
  Widget build(BuildContext context) {
    return KlpRow(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (leading != null) ...[
          leading!,
          const KlpGap.widthSize(KlpSpaceSize.controlContent),
        ],
        KlpFlexible(
          child: KlpText(
            label,
            role: style.labelRole,
            color: style.foreground,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (trailing != null) ...[
          const KlpGap.widthSize(KlpSpaceSize.controlContent),
          trailing!,
        ],
      ],
    );
  }
}
