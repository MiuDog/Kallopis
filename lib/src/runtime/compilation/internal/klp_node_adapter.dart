import '../../../composition/definitions/klp_definition.dart';
import '../../../composition/nodes/klp_node.dart';
import '../../../composition/validation/klp_validated_node.dart';
import 'klp_prepare_context.dart';
import 'klp_prepared_node.dart';

/// 本庫內部把功能降為封閉 foundation，runtime 不認識特定功能型別。
abstract interface class KlpNodeAdapter {

	KlpDefinition<KlpNode> get contract;
	KlpPreparedNode prepare(KlpNode node, KlpValidatedNode snapshot, KlpPrepareContext context);
}
