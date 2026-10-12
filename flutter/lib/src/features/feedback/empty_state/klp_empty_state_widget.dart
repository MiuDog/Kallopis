part of '../klp_empty_state.dart';

class KlpEmptyState extends StatelessWidget {
  const KlpEmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.action,
  });

  final KlpIconData icon;
  final String title;
  final String message;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final tokens = context.klpColors;
    final klp = context.klp;

    return KlpDashedBorder(
      radius: klp.shape.card,
      child: KlpBox(
        width: double.infinity,
        paddingSize: KlpSpaceSize.section,
        child: KlpColumn(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            KlpIcon(icon, size: klp.space.iconLarge, color: tokens.textMuted),
            const KlpGap.heightSize(KlpSpaceSize.comfortable),
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
