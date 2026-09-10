part of '../klp_radio_group.dart';

class _KlpRadioItem extends StatelessWidget {
  const _KlpRadioItem({
    required this.label,
    this.description,
    required this.selected,
    required this.onPressed,
  });

  final String label;
  final String? description;
  final bool selected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final style = _KlpRadioItemStyle.resolve(context.klp, selected: selected);
    return _KlpRadioItemFrame(
      label: label,
      onPressed: onPressed,
      style: style,
      child: KlpRow(
        mainAxisSize: MainAxisSize.min,
        children: [
          _KlpRadioIndicatorFrame(
            label: label,
            selected: selected,
            style: style,
          ),
          const KlpGap.widthSize(KlpSpaceSize.contentInline),
          KlpExpanded(
            child: KlpColumn(
              mainAxisSize: MainAxisSize.min,
              children: [
                KlpText(label, role: KlpTextRole.bodyStrong),
                if (description != null) ...[
                  const KlpGap.heightSize(KlpSpaceSize.tight),
                  KlpText(
                    description!,
                    role: KlpTextRole.caption,
                    tone: KlpTextTone.muted,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
