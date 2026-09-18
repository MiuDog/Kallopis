import 'package:kallopis/src/composition/definitions/klp_definition.dart';
import 'package:kallopis/src/composition/nodes/klp_node.dart';
import 'package:kallopis/src/composition/validation/klp_validated_node.dart';
import 'package:kallopis/src/runtime/contracts/klp_node_adapter.dart';
import 'package:kallopis/src/runtime/contracts/klp_prepare_context.dart';
import 'package:kallopis/src/runtime/contracts/klp_prepared_node.dart';
import 'package:kallopis/src/styling/primitives/klp_primitive_index.dart';
import 'package:kallopis/src/styling/primitives/klp_style_kind.dart';
import 'package:kallopis/src/styling/references/klp_style_ref.dart';
import 'package:kallopis/src/styling/semantics/klp_semantic_key.dart';
import 'package:kallopis/src/styling/semantics/klp_semantic_schema.dart';
import 'package:kallopis/src/styling/semantics/klp_semantic_token.dart';
import 'package:kallopis/src/application/structure/klp_screen.dart';
import 'klp_prepared_screen.dart';

/// 畫面底層用途由本庫定義；槽位映射尚未作正式預設風格承諾。
final class KlpScreenAdapter implements KlpNodeAdapter {
  static final background = KlpSemanticKey(
    KlpScreen.typeId,
    'background',
    KlpStyleKind.color,
  );
  static final radius = KlpSemanticKey(
    KlpScreen.typeId,
    'radius',
    KlpStyleKind.radius,
  );
  static final inset = KlpSemanticKey(
    KlpScreen.typeId,
    'inset',
    KlpStyleKind.distance,
  );

  @override
  final KlpDefinition<KlpScreen> contract = KlpDefinition<KlpScreen>(
    KlpScreen.typeId,
    semantics: KlpSemanticSchema(KlpScreen.typeId, [
      KlpSemanticToken(
        background,
        const KlpPrimitiveRef(KlpStyleKind.color, KlpPrimitiveIndex.i0),
      ),
      KlpSemanticToken(
        radius,
        const KlpPrimitiveRef(KlpStyleKind.radius, KlpPrimitiveIndex.i0),
      ),
      KlpSemanticToken(
        inset,
        const KlpPrimitiveRef(KlpStyleKind.distance, KlpPrimitiveIndex.i0),
      ),
    ]),
    slots: [KlpScreen.bodySlot],
  );

  @override
  KlpPreparedNode prepare(
    KlpNode node,
    KlpValidatedNode snapshot,
    KlpPrepareContext context,
  ) {
    return KlpPreparedScreen(
      context.style.read(background),
      context.style.read(radius),
      context.style.read(inset),
      (node as KlpScreen).accessibilityLabel,
    );
  }
}
