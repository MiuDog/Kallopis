part of '../klp_card.dart';

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
		this.tone = KlpCardTone.component,
	});

	final String title;
	final String? label;
	final Widget? leading;
	final Widget? trailing;
	final Widget child;
	final Widget? footer;
	final bool selected;
	final KlpCardTone tone;

	@override
	Widget build(BuildContext context) {
		final klp = context.klp;

		return _KlpCardFrame(
			tone: tone,
			selected: selected,
			child: KlpColumn(
				crossAxisAlignment: CrossAxisAlignment.stretch,
				children: [
					KlpBox(
						insets: KlpBoxInsets.uniform(klp.cardPadding),
						child: KlpRow(
							children: [
								if (leading != null) ...[
									leading!,
									const KlpGap.widthSize(KlpSpaceSize.contentInline),
								],
								KlpExpanded(
									child: KlpColumn(
										crossAxisAlignment: CrossAxisAlignment.start,
										children: [
											if (label != null)
												KlpText(label!, role: KlpTextRole.label),
											KlpText(title, role: KlpTextRole.bodyStrong),
										],
									),
								),
								trailing ?? const KlpBox.shrink(),
							],
						),
					),
					KlpBox(
						insets: KlpBoxInsets.uniform(klp.cardPadding),
						child: child,
					),
					if (footer != null)
						KlpBox(
							insets: KlpBoxInsets.uniform(klp.space.contentInset),
							child: footer,
						),
				],
			),
		);
	}
}
