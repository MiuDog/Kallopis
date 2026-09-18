import 'package:kallopis/src/composition/definitions/klp_definition.dart';
import 'package:kallopis/src/composition/nodes/klp_node.dart';
import 'package:kallopis/src/composition/validation/klp_validated_node.dart';
import 'package:kallopis/src/runtime/contracts/klp_prepare_context.dart';
import 'package:kallopis/src/runtime/contracts/klp_prepared_node.dart';

/// 本庫內部把功能降為封閉 foundation，runtime 不認識特定功能型別。
abstract interface class KlpNodeAdapter {
	KlpDefinition<KlpNode> get contract;
	KlpPreparedNode prepare(
		KlpNode node,
		KlpValidatedNode snapshot,
		KlpPrepareContext context,
	);
}
