import '../../../composition/definitions/klp_definition.dart';
import '../../../composition/nodes/klp_node.dart';
import '../../../composition/registry/klp_registry.dart';
import '../../../composition/slots/klp_slot.dart';
import '../../../composition/validation/klp_validated_node.dart';
import '../../../composition/validation/klp_validated_slot.dart';
import '../../../kernel/diagnostics/klp_contract_error.dart';
import '../../../styling/primitives/klp_primitive_set.dart';
import '../../../styling/resolution/internal/klp_semantic_resolution.dart';
import '../../../styling/resolution/internal/klp_semantic_resolver.dart';
import '../../definitions/klp_component_definition.dart';
import '../../templates/klp_template.dart';
import 'klp_bound_component.dart';
import 'klp_bound_template.dart';
import 'klp_bound_text_style.dart';
import 'klp_component_binding_exception.dart';
import 'klp_prepared_component.dart';
import 'klp_prepared_template.dart';

/// 定義先驗證，資料後投影；只輸出封閉 foundation 結果，不建立 Flutter Widget。
final class KlpComponentCompiler {

	final Map<String, KlpComponentDefinition<KlpNode>> _definitions = {};
	late final KlpSemanticResolver _semantics;

	KlpComponentCompiler(Iterable<KlpComponentDefinition<KlpNode>> definitions, {Iterable<KlpDefinition<KlpNode>> sharedDefinitions = const []}) {
		final snapshot = List<KlpComponentDefinition<KlpNode>>.of(definitions);
		final registry = KlpRegistry([...sharedDefinitions, ...snapshot.map((definition) => definition.contract)]);
		_semantics = KlpSemanticResolver(registry.definitions.map((definition) => definition.semantics));
		for (final definition in snapshot) {
			_validate(definition.content, definition.contract.id);
			_definitions[definition.contract.id] = definition;
		}
	}

	KlpBoundComponent bind(KlpNode node, KlpPrimitiveSet primitives) {
		final snapshot = KlpValidatedNode(node.id, node.definitionId, [for (final child in node.children) child.id]);
		return bindCaptured(node, snapshot, primitives);
	}

	/// 結構編譯已擷取識別與子節點，不再讀取外部結構 getter。
	KlpBoundComponent bindCaptured(KlpNode node, KlpValidatedNode snapshot, KlpPrimitiveSet primitives, {KlpSemanticResolution? resolved}) {
		if (snapshot.slotRanges.isNotEmpty || (_definitions[snapshot.definitionId]?.contract.slots.isNotEmpty ?? false)) throw KlpContractError('component_requires_child_context', snapshot.id);
		return prepareCaptured(node, snapshot, primitives, resolved: resolved).materialize(const []);
	}

	/// 子插槽只保存已驗證範圍，消費端程式在安裝資源前完成執行。
	KlpPreparedComponent prepareCaptured(KlpNode node, KlpValidatedNode snapshot, KlpPrimitiveSet primitives, {KlpSemanticResolution? resolved}) {
		final (definition, slots) = _validateCaptured(node, snapshot);
		final style = resolved ?? _semantics.resolve(primitives);
		final bound = _bind(definition.content, node, style, snapshot.id, 'content', slots);
		String? accessibilityLabel;
		if (definition.hasAccessibilityLabel) {
			try {
				final selected = definition.selectAccessibilityLabel(node);
				if (selected == null || selected.trim().isEmpty) {
					throw KlpContractError(
						'invalid_component_accessibility_label',
						snapshot.id,
					);
				}
				accessibilityLabel = selected;
			}
			catch (cause, stackTrace) {
				if (cause is KlpContractError) {
					rethrow;
				}
				throw KlpComponentBindingException(
					placementId: snapshot.id,
					templatePath: 'accessibilityLabel',
					cause: cause,
					stackTrace: stackTrace,
				);
			}
		}
		return KlpPreparedComponent(
			id: snapshot.id,
			definitionId: snapshot.definitionId,
			childCount: snapshot.childrenIds.length,
			content: bound,
			accessibilityLabel: accessibilityLabel,
		);
	}

	/// runtime 可先檢查整棵樹的模板資格，再開始任何文字投影。
	void validateCaptured(KlpNode node, KlpValidatedNode snapshot) {
		_validateCaptured(node, snapshot);
	}

	(KlpComponentDefinition<KlpNode>, Map<KlpSlot<KlpNode>, KlpValidatedSlot>) _validateCaptured(KlpNode node, KlpValidatedNode snapshot) {
		final id = snapshot.id;
		final definitionId = snapshot.definitionId;
		if (id.trim().isEmpty) throw const KlpContractError('empty_id', 'component.placement');

		final definition = _definitions[definitionId];
		if (definition == null) throw KlpContractError('unknown_component', '$id -> $definitionId');
		if (!definition.contract.accepts(node)) throw KlpContractError('node_type_mismatch', id);

		final slots = _validateSlots(definition.contract, snapshot);

		_validateInput(definition.content, node, id, 'content');
		return (definition, slots);
	}

	Map<KlpSlot<KlpNode>, KlpValidatedSlot> _validateSlots(KlpDefinition<KlpNode> definition, KlpValidatedNode snapshot) {
		if (definition.slots.isEmpty && snapshot.childrenIds.isNotEmpty) throw KlpContractError('component_children_unsupported', snapshot.id);
		if (snapshot.slotRanges.length != definition.slots.length) throw KlpContractError('component_slot_snapshot_mismatch', snapshot.id);

		// 內部呼叫同樣不得遺漏、重複或越界使用直接子放置。
		final ranges = <KlpSlot<KlpNode>, KlpValidatedSlot>{};
		var offset = 0;
		for (var index = 0; index < definition.slots.length; index++) {
			final slot = definition.slots[index];
			final range = snapshot.slotRanges[index];
			final count = range.end - range.start;
			if (!identical(range.slot, slot) || range.start != offset || count < slot.min || (slot.max != null && count > slot.max!) || range.end > snapshot.childrenIds.length) throw KlpContractError('component_slot_snapshot_mismatch', snapshot.id);
			ranges[slot] = range;
			offset = range.end;
		}
		if (offset != snapshot.childrenIds.length) throw KlpContractError('component_slot_snapshot_mismatch', snapshot.id);

		return ranges;
	}

	void _validate(KlpTemplate<KlpNode> template, String owner) {
		switch (template) {
			case KlpChildrenTemplate(:final gap):
				_semantics.validateUsage(owner, gap);
			case KlpTextTemplate(:final semantics):
				for (final key in [semantics.color, semantics.fontFamily, semantics.fontSize, semantics.fontWeight, semantics.lineHeight, semantics.letterSpacing]) {
					_semantics.validateUsage(owner, key);
				}
			case KlpLinearTemplate(:final gap, :final children):
				_semantics.validateUsage(owner, gap);
				for (final child in children) {
					_validate(child, owner);
				}
			case KlpSurfaceTemplate(:final background, :final radius, :final inset, :final child):
				for (final key in [background, radius, inset]) {
					_semantics.validateUsage(owner, key);
				}
				_validate(child, owner);
		}
	}

	void _validateInput(KlpTemplate<KlpNode> template, KlpNode node, String id, String path) {
		if (!template.accepts(node)) throw KlpContractError('template_type_mismatch', '$id -> $path');
		switch (template) {
			case KlpTextTemplate():
			case KlpChildrenTemplate():
				break;
			case KlpLinearTemplate(:final children):
				for (var index = 0; index < children.length; index++) {
					_validateInput(children[index], node, id, '$path/children/$index');
				}
			case KlpSurfaceTemplate(:final child):
				_validateInput(child, node, id, '$path/child');
		}
	}

	KlpPreparedTemplate _bind(KlpTemplate<KlpNode> template, KlpNode node, KlpSemanticResolution style, String id, String path, Map<KlpSlot<KlpNode>, KlpValidatedSlot> slots) {
		switch (template) {
			case KlpChildrenTemplate(:final axis, :final gap, :final slot):
				final range = slots[slot]!;
				return KlpPreparedChildren(axis: axis, gap: style.read(gap), start: range.start, end: range.end);
			case KlpTextTemplate(:final semantics):
				String value;
				try {
					value = template.selectText(node);
				}
				catch (cause, stackTrace) {
					throw KlpComponentBindingException(placementId: id, templatePath: path, cause: cause, stackTrace: stackTrace);
				}
				return KlpPreparedValue(KlpBoundText(value, KlpBoundTextStyle(
					color: style.read(semantics.color),
					fontFamily: style.read(semantics.fontFamily),
					fontSize: style.read(semantics.fontSize),
					fontWeight: style.read(semantics.fontWeight),
					lineHeight: style.read(semantics.lineHeight),
					letterSpacing: style.read(semantics.letterSpacing),
				)));
			case KlpLinearTemplate(:final axis, :final gap, :final children):
				return KlpPreparedLinear(axis, style.read(gap), [for (var index = 0; index < children.length; index++) _bind(children[index], node, style, id, '$path/children/$index', slots)]);
			case KlpSurfaceTemplate(:final background, :final radius, :final inset, :final child):
				return KlpPreparedSurface(
					background: style.read(background),
					radius: style.read(radius),
					inset: style.read(inset),
					child: _bind(child, node, style, id, '$path/child', slots),
				);
		}
	}
}
