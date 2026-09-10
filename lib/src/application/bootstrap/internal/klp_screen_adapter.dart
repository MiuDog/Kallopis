import '../../../composition/definitions/klp_definition.dart';
import '../../../composition/nodes/klp_node.dart';
import '../../../composition/validation/klp_validated_node.dart';
import '../../../runtime/compilation/internal/klp_node_adapter.dart';
import '../../../runtime/compilation/internal/klp_prepare_context.dart';
import '../../../runtime/compilation/internal/klp_prepared_node.dart';
import '../../../styling/primitives/klp_primitive_index.dart';
import '../../../styling/primitives/klp_style_kind.dart';
import '../../../styling/references/klp_style_ref.dart';
import '../../../styling/semantics/klp_semantic_key.dart';
import '../../../styling/semantics/klp_semantic_schema.dart';
import '../../../styling/semantics/klp_semantic_token.dart';
import '../../structure/klp_screen.dart';
import 'klp_prepared_screen.dart';

/// 畫面底層用途由本庫定義；槽位映射尚未作正式預設風格承諾。
final class KlpScreenAdapter implements KlpNodeAdapter {

	static final background = KlpSemanticKey(KlpScreen.typeId, 'background', KlpStyleKind.color);
	static final radius = KlpSemanticKey(KlpScreen.typeId, 'radius', KlpStyleKind.radius);
	static final inset = KlpSemanticKey(KlpScreen.typeId, 'inset', KlpStyleKind.distance);

	@override
	final KlpDefinition<KlpScreen> contract = KlpDefinition<KlpScreen>(KlpScreen.typeId, semantics: KlpSemanticSchema(KlpScreen.typeId, [
		KlpSemanticToken(background, const KlpPrimitiveRef(KlpStyleKind.color, KlpPrimitiveIndex.i0)),
		KlpSemanticToken(radius, const KlpPrimitiveRef(KlpStyleKind.radius, KlpPrimitiveIndex.i0)),
		KlpSemanticToken(inset, const KlpPrimitiveRef(KlpStyleKind.distance, KlpPrimitiveIndex.i0)),
	]), slots: [KlpScreen.bodySlot]);

	@override
	KlpPreparedNode prepare(KlpNode node, KlpValidatedNode snapshot, KlpPrepareContext context) {
		return KlpPreparedScreen(
			context.style.read(background),
			context.style.read(radius),
			context.style.read(inset),
			(node as KlpScreen).accessibilityLabel,
		);
	}
}
