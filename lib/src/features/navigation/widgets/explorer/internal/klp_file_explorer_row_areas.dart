part of '../klp_file_explorer.dart';

/// 將樹狀控制區與內容區分開，讓同層節點以內容圖示左緣對齊。
class _KlpFileExplorerRowAreas extends StatelessWidget {
	const _KlpFileExplorerRowAreas({
		required this.level,
		required this.spacing,
		required this.content,
		this.leading,
	});

	final int level;
	final KlpFileExplorerSpacing spacing;
	final Widget? leading;
	final Widget content;

	@override
	Widget build(BuildContext context) {
		final klp = context.klp;

		return KlpRow(
			children: [
				KlpBox(
					key: const ValueKey('klp-file-explorer-leading-area'),
					insets: KlpBoxInsets.directional(
						start: level * spacing.indent(context),
					),
					child: KlpBox(
						width: klp.space.iconSmall + klp.geometry.layout.treeLeadingGap,
						child: leading == null
								? null
								: KlpAlign(alignment: Alignment.centerLeft, child: leading!),
					),
				),
				KlpExpanded(
					child: KeyedSubtree(
						key: const ValueKey('klp-file-explorer-content-area'),
						child: content,
					),
				),
			],
		);
	}
}
