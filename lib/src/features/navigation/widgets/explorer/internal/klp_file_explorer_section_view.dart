part of '../klp_file_explorer.dart';

/// 分類區塊視圖（含分類標題、折疊動畫與項目清單）。
class KlpFileExplorerSectionView extends StatelessWidget {
	const KlpFileExplorerSectionView({
		super.key,
		required this.section,
		required this.isExpanded,
		required this.expandedItemIds,
		required this.selectedId,
		required this.onToggle,
		required this.onItemToggle,
		required this.onItemSelected,
		this.spacing = KlpFileExplorerSpacing.standard,
	});

	final KlpFileExplorerSection section;
	final bool isExpanded;
	final Set<String> expandedItemIds;
	final String? selectedId;
	final VoidCallback onToggle;
	final ValueChanged<String> onItemToggle;
	final ValueChanged<String> onItemSelected;
	final KlpFileExplorerSpacing spacing;

	@override
	Widget build(BuildContext context) {
		final klp = context.klp;

		return KlpColumn(
			crossAxisAlignment: CrossAxisAlignment.stretch,
			mainAxisSize: MainAxisSize.min,
			children: [
				KlpBox(
					marginInsets: spacing.sectionMargin(context),
					child: KlpBox(
						width: double.infinity,
						height: klp.space.icon,
						child: KlpPressable(
							onPressed: section.collapsible ? onToggle : null,
							hoverHighlight: false,
							child: KlpBox(
								insets: spacing.sectionPadding(context),
								child: KlpRow(
									children: [
										if (section.collapsible) ...[
											_KlpFileExplorerDisclosure(
												expanded: isExpanded,
												size: _KlpFileExplorerDisclosureSize.section,
											),
											KlpBox(width: klp.space.tight + klp.space.hairline),
										],
										KlpExpanded(
											child: KlpText(
												section.title,
												role: KlpTextRole.caption,
												tone: KlpTextTone.muted,
											),
										),
										if (section.trailing != null) section.trailing!,
									],
								),
							),
						),
					),
				),
				if (isExpanded)
					for (final item in section.items)
						_KlpFileExplorerNodeView(
							item: item,
							level: 0,
							expandedItemIds: expandedItemIds,
							selectedId: selectedId,
							onItemToggle: onItemToggle,
							onItemSelected: onItemSelected,
							spacing: spacing,
						),
				KlpBox(height: klp.space.navigationSectionGap),
			],
		);
	}
}
