import 'package:kallopis/src/features/editing/presentation/klp_editing_presentation.dart';
import 'package:krepis_block_note/krepis_block_note.dart';
import 'package:kallopis/src/composition/definitions/klp_definition.dart';
import 'package:kallopis/src/composition/nodes/klp_node.dart';
import 'package:kallopis/src/composition/validation/klp_validated_node.dart';
import 'package:kallopis/src/features/editing/contracts/klp_block_note_editing_content.dart';
import 'package:kallopis/src/foundation/binding/contracts/klp_bound_template.dart';
import 'package:kallopis/src/kernel/lifecycle/klp_frame_lease.dart';
import 'package:kallopis/src/runtime/contracts/klp_node_adapter.dart';
import 'package:kallopis/src/runtime/contracts/klp_prepare_context.dart';
import 'package:kallopis/src/runtime/contracts/klp_prepared_node.dart';
import 'package:kallopis/src/runtime/contracts/klp_placement_resource.dart';
import 'package:kallopis/src/styling/primitives/klp_style_value.dart';
import '../internal/klp_block_note_editing_semantics.dart';

/// 內建 BlockNote 節點的語意與準備資料轉接器；借用上游 controller，不建立正文權威或使用端註冊入口。
final class KlpBlockNoteEditingAdapter implements KlpNodeAdapter {
	@override
	KlpDefinition<KlpNode> get contract => KlpDefinition<KlpBlockNoteEditingContent>(KlpBlockNoteEditingContent.typeId, semantics: KlpBlockNoteEditingSemantics.schema());

	@override
	KlpPreparedNode prepare(KlpNode node, KlpValidatedNode snapshot, KlpPrepareContext context) {
		final content = node as KlpBlockNoteEditingContent;
		final background = context.style.read(KlpBlockNoteEditingSemantics.background);
		final text = context.style.read(KlpBlockNoteEditingSemantics.text);
		return _KlpPreparedBlockNoteEditing(
			content.controller,
			onOpened: content.onOpened,
			resolveAsset: content.resolveAsset,
			onOpenAsset: content.onOpenAsset,
			onOpenReference: content.onOpenReference,
			background: _cssColor(background),
			text: _cssColor(text),
			fontFamily: context.style.read(KlpBlockNoteEditingSemantics.fontFamily).family,
			fontSize: context.style.read(KlpBlockNoteEditingSemantics.fontSize).value,
		);
	}

	String _cssColor(KlpColor color) => '#${color.red.toRadixString(16).padLeft(2, '0')}${color.green.toRadixString(16).padLeft(2, '0')}${color.blue.toRadixString(16).padLeft(2, '0')}${color.alpha.toRadixString(16).padLeft(2, '0')}';
}

final class _KlpPreparedBlockNoteEditing implements KlpPreparedNode {
	final KlpBlockNoteSessionController controller;
	final String background;
	final String text;
	final String fontFamily;
	final double fontSize;
	final Future<void> Function()? onOpened;
	final Future<KlpResolvedAsset> Function(String assetId)? resolveAsset;
	final Future<void> Function(String assetId)? onOpenAsset;
	final Future<void> Function(String referenceId, String sourceDocumentId, String sourceBlockId)? onOpenReference;
	const _KlpPreparedBlockNoteEditing(this.controller, {required this.background, required this.text, required this.fontFamily, required this.fontSize, this.onOpened, this.resolveAsset, this.onOpenAsset, this.onOpenReference});

	@override
	KlpPlacementResource createResource(KlpValidatedNode node) => _KlpBlockNotePlacement();

	@override
	KlpBoundTemplate materialize(KlpPlacementResource resource, List<KlpBoundTemplate> children, KlpFrameLease lease) => KlpBoundBlockNoteEditing(controller, background: background, text: text, fontFamily: fontFamily, fontSize: fontSize, onOpened: onOpened, resolveAsset: resolveAsset, onOpenAsset: onOpenAsset, onOpenReference: onOpenReference);
}

final class _KlpBlockNotePlacement implements KlpPlacementResource {
	@override
	void update(KlpValidatedNode node) {}

	@override
	void dispose() {}
}
