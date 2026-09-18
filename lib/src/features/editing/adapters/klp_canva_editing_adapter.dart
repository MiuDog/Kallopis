import 'package:kallopis/src/features/editing/presentation/klp_editing_presentation.dart';
import 'package:kallopis/src/composition/definitions/klp_definition.dart';
import 'package:krepis_canva/krepis_canva.dart';
import 'package:kallopis/src/composition/nodes/klp_node.dart';
import 'package:kallopis/src/composition/validation/klp_validated_node.dart';
import 'package:kallopis/src/features/editing/contracts/klp_canva_editing_content.dart';
import 'package:kallopis/src/foundation/binding/contracts/klp_bound_template.dart';
import 'package:kallopis/src/kernel/lifecycle/klp_frame_lease.dart';
import 'package:kallopis/src/runtime/contracts/klp_node_adapter.dart';
import 'package:kallopis/src/runtime/contracts/klp_prepare_context.dart';
import 'package:kallopis/src/runtime/contracts/klp_prepared_node.dart';
import 'package:kallopis/src/runtime/contracts/klp_placement_resource.dart';

/// 內建 Canva 節點的語意與準備資料轉接器；借用上游畫布 controller，不擁有文件或保存權威。
final class KlpCanvaEditingAdapter implements KlpNodeAdapter {
  @override
  KlpDefinition<KlpNode> get contract =>
      KlpDefinition<KlpCanvaEditingContent>(KlpCanvaEditingContent.typeId);

  @override
  KlpPreparedNode prepare(
    KlpNode node,
    KlpValidatedNode snapshot,
    KlpPrepareContext context,
  ) => _KlpPreparedCanvaEditing((node as KlpCanvaEditingContent).controller);
}

final class _KlpPreparedCanvaEditing implements KlpPreparedNode {
  final KrepisCanvaSessionController controller;
  const _KlpPreparedCanvaEditing(this.controller);

  @override
  KlpPlacementResource createResource(KlpValidatedNode node) =>
      _KlpCanvaPlacement();

  @override
  KlpBoundTemplate materialize(
    KlpPlacementResource resource,
    List<KlpBoundTemplate> children,
    KlpFrameLease lease,
  ) => KlpBoundCanvaEditing(controller);
}

final class _KlpCanvaPlacement implements KlpPlacementResource {
  @override
  void update(KlpValidatedNode node) {}

  @override
  void dispose() {}
}
