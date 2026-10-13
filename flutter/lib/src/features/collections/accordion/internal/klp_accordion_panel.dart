part of '../klp_accordion.dart';

class _KlpAccordionPanel extends StatelessWidget {
  const _KlpAccordionPanel({
    required this.item,
    required this.expanded,
    required this.onToggle,
  });

  final KlpAccordionItemData item;
  final bool expanded;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return KlpColumn(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _KlpAccordionHeaderFrame(
          expanded: expanded,
          onTap: onToggle,
          child: KlpRow(
            children: [
              KlpExpanded(
                child: KlpColumn(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    KlpText(item.title, role: KlpTextRole.bodyStrong),
                    if (item.subtitle case final subtitle?) ...[
                      const KlpGap.heightSize(KlpSpaceSize.tight),
                      KlpText(
                        subtitle,
                        role: KlpTextRole.caption,
                        tone: KlpTextTone.muted,
                      ),
                    ],
                  ],
                ),
              ),
              const KlpGap.widthSize(KlpSpaceSize.contentInline),
              _KlpAccordionChevron(expanded: expanded),
            ],
          ),
        ),
        _KlpAccordionBody(expanded: expanded, child: item.child),
      ],
    );
  }
}
