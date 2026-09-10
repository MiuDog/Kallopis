part of '../klp_navigator.dart';

class _KlpNavigatorCategoryView extends StatelessWidget {
	const _KlpNavigatorCategoryView({required this.category});

	final KlpNavigatorCategory category;

	@override
	Widget build(BuildContext context) {
		final klp = context.klp;
		final scope = _KlpNavigatorScope.of(context);
		final isExpanded = scope.expandedCategoryIds.contains(category.id);

		return KlpColumn(
			crossAxisAlignment: CrossAxisAlignment.stretch,
			mainAxisSize: MainAxisSize.min,
			children: [
				KlpBox(
					width: double.infinity,
					height: klp.space.icon,
					child: KlpPressable(
						onPressed: category.collapsible ? () => scope.onCategoryToggle(category.id) : null,
						hoverHighlight: false,
						child: KlpBox(
							insets: KlpBoxInsets.directional(
								start: klp.space.navigationItemInset,
								end: klp.space.navigationItemInset,
							),
							child: KlpRow(
								children: [
									if (category.collapsible) ...[
										_KlpNavigatorDisclosure(
											expanded: isExpanded,
											size: klp.geometry.layout.disclosureIconSize,
										),
										KlpBox(width: klp.space.tight + klp.space.hairline),
									],
									KlpExpanded(
										child: KlpText(
											category.label,
											role: KlpTextRole.caption,
											tone: KlpTextTone.muted,
										),
									),
									if (category.trailing != null) category.trailing!,
								],
							),
						),
					),
				),
				if (isExpanded)
					for (final item in category.items) _KlpNavigatorItemView(item: item, level: 0),
				KlpBox(height: klp.space.navigationSectionGap),
			],
		);
	}
}
