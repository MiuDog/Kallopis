part of '../klp_artifact_workspace.dart';

/// 元件定義卡，不持有元件文件或 instance override。
class KlpComponentDefinitionCard extends StatelessWidget {
	const KlpComponentDefinitionCard({
		super.key,
		required this.data,
		this.onPressed,
	});

	final KlpComponentDefinitionData data;
	final VoidCallback? onPressed;

	@override
	Widget build(BuildContext context) {
		return _KlpComponentDefinitionSemantics(
			button: onPressed != null,
			label: data.name,
			child: KlpGestureRegion(
				behavior: HitTestBehavior.opaque,
				onTap: onPressed,
				child: KlpPreviewCard(
					title: data.name,
					preview: data.preview,
					metadata: [
						?data.description,
						data.statusLabel,
					],
				),
			),
		);
	}
}
