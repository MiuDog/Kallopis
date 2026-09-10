part of 'klp_view_states.dart';

class _KlpViewState extends StatelessWidget {
  const _KlpViewState({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.message,
    required this.action,
  });

  final KlpIconData? icon;
  final Color iconColor;
  final String title;
  final String message;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return KlpDashedBorder(
      radius: context.klp.shape.card,
      child: KlpBox(
        width: double.infinity,
        paddingSize: KlpSpaceSize.loose,
        child: KlpColumn(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (icon != null) ...[
              KlpIcon(
                icon!,
                size: context.klp.space.iconLarge,
                color: iconColor,
              ),
              const KlpGap.heightSize(KlpSpaceSize.base),
            ],
            KlpText(
              title,
              role: KlpTextRole.section,
              textAlign: TextAlign.center,
            ),
            const KlpGap.heightSize(KlpSpaceSize.tight),
            KlpText(
              message,
              role: KlpTextRole.caption,
              tone: KlpTextTone.muted,
              textAlign: TextAlign.center,
            ),
            if (action != null) ...[
              const KlpGap.heightSize(KlpSpaceSize.comfortable),
              action!,
            ],
          ],
        ),
      ),
    );
  }
}
