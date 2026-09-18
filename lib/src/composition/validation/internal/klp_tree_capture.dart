import 'dart:collection';

import 'package:kallopis/src/kernel/diagnostics/klp_contract_error.dart';
import 'package:kallopis/src/kernel/identity/klp_placement_id.dart';
import 'package:kallopis/src/composition/nodes/klp_node.dart';
import 'package:kallopis/src/composition/nodes/klp_composite_node.dart';
import 'package:kallopis/src/composition/nodes/klp_scope_boundary.dart';
import 'package:kallopis/src/composition/nodes/klp_adaptive.dart';
import 'package:kallopis/src/composition/nodes/klp_platform_strategy.dart';
import 'package:kallopis/src/composition/slots/klp_children.dart';
import 'package:kallopis/src/composition/registry/klp_registry.dart';
import 'package:kallopis/src/composition/validation/klp_tree_validation.dart';
import 'package:kallopis/src/composition/validation/klp_validated_node.dart';
import 'package:kallopis/src/composition/validation/klp_validated_slot.dart';

/// 原始節點只供同次資料準備使用，不存入公開驗證結果或已提交畫面。
final class KlpTreeCapture {
  final KlpTreeValidation validation;
  final Map<KlpPlacementId, KlpNode> sources;

  KlpTreeCapture(this.validation, Map<KlpPlacementId, KlpNode> sources)
    : sources = Map.unmodifiable(sources);
}

/// 結構驗證與編譯共用唯一擷取流程，每個結構 getter 僅讀取一次。
KlpTreeCapture captureKlpTree(KlpRegistry registry, KlpNode root, {KlpAdaptiveContext? adaptiveContext}) {
  final active = HashSet<KlpNode>.identity();
  final sources = <KlpPlacementId, KlpNode>{};
  final snapshots = <KlpValidatedNode>[];
  final definitions = {
    for (final definition in registry.definitions) definition.id: definition,
  };

  KlpPlacementId visit(KlpNode node, List<String> scope) {
    if (!active.add(node)) {
      throw const KlpContractError(
        'node_cycle',
        'A structure cannot contain a cycle.',
      );
    }

    // 識別、型別與子樹先封存，後續演算法不再要求消費端 getter。
    final id = node.id;
    final definitionId = node.definitionId;
    final suppliedChildren = node is KlpAdaptive ? node.childrenFor(adaptiveContext) : node.children;
    final children = List<KlpNode>.of(suppliedChildren);
    if (id.value.trim().isEmpty || definitionId.trim().isEmpty) {
      throw const KlpContractError(
        'empty_id',
        'An identifier cannot be empty.',
      );
    }
    final placement = KlpPlacementId(scope: scope, localId: id.value);
    if (sources.containsKey(placement)) {
      throw KlpContractError('duplicate_placement', '$placement');
    }

    final registered = definitions[definitionId];
    if (registered == null) {
      throw KlpContractError(
        'unknown_definition',
        'placement=${id.value} definition=$definitionId',
      );
    }
    if (!registered.accepts(node)) {
      throw KlpContractError('node_type_mismatch', id.value);
    }
    final slotRanges = <KlpValidatedSlot>[];
    if (node is KlpCompositeNode) {
      // 只使用剛才讀取的唯一快照，不再要求 children getter。
      if (suppliedChildren is! KlpChildren) {
        throw KlpContractError('composite_children_required', id.value);
      }
      final assignments = suppliedChildren.assignments;
      if (assignments.length != registered.slots.length) {
        throw KlpContractError('slot_assignment_count', id.value);
      }
      var offset = 0;
      for (var index = 0; index < registered.slots.length; index++) {
        final slot = registered.slots[index];
        final assignment = assignments[index];
        if (!identical(slot, assignment.slot)) {
          throw KlpContractError(
            'slot_assignment_mismatch',
            '${id.value}.${slot.name}',
          );
        }
        for (final child in assignment.children) {
          if (!slot.accepts(child)) {
            throw KlpContractError(
              'slot_child_type_mismatch',
              '${id.value}.${slot.name}',
            );
          }
        }
        final end = offset + assignment.children.length;
        slotRanges.add(KlpValidatedSlot(slot, offset, end));
        offset = end;
      }
    } else if (registered.slots.isNotEmpty || suppliedChildren is KlpChildren) {
      throw KlpContractError('composite_node_required', id.value);
    }

    sources[placement] = node;
    final position = snapshots.length;
    snapshots.add(KlpValidatedNode.scoped(placement, definitionId, const []));
    // 型別是本庫封閉授權；不由消費端布林值或第二份樹資料決定。
    final childScope = node is KlpScopeBoundary ? [...scope, id.value] : scope;
    final childrenPlacements = [
      for (final child in children) visit(child, childScope),
    ];
    snapshots[position] = KlpValidatedNode.scoped(
      placement,
      definitionId,
      childrenPlacements,
      slotRanges: slotRanges,
    );
    active.remove(node);
    return placement;
  }

  final rootId = visit(root, const []);
  return KlpTreeCapture(KlpTreeValidation.scoped(rootId, snapshots), sources);
}
