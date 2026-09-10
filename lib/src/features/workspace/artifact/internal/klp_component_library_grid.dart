part of '../klp_artifact_workspace.dart';

/// 元件定義的響應式預覽網格。
class KlpComponentLibraryGrid extends StatelessWidget {
	const KlpComponentLibraryGrid({
		super.key,
		required this.components,
		this.onSelected,
	});

	final List<KlpComponentDefinitionData> components;
	final ValueChanged<String>? onSelected;

	@override
	Widget build(BuildContext context) {
		return KlpWrap(
			spacingSize: KlpSpaceSize.base,
			runSpacingSize: KlpSpaceSize.base,
			children: [
				for (final component in components)
					KlpComponentDefinitionCard(
						data: component,
						onPressed: onSelected == null
								? null
								: () => onSelected!(component.id),
					),
			],
		);
	}
}
