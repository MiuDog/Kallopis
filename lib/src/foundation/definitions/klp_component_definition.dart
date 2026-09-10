import '../../composition/definitions/klp_definition.dart';
import '../../composition/nodes/klp_node.dart';
import '../../styling/semantics/klp_semantic_schema.dart';
import '../templates/klp_template.dart';
import 'internal/klp_template_slots.dart';

/// 將受控模板與註冊契約綁在定義期，實例不再提供風格參數。
final class KlpComponentDefinition<T extends KlpNode> {

	final KlpDefinition<T> contract;
	final KlpTemplate<T> content;
	final String Function(T)? accessibilityLabel;
	bool get hasAccessibilityLabel => accessibilityLabel != null;

	KlpComponentDefinition(String id, {
		required this.content,
		required KlpSemanticSchema semantics,
		this.accessibilityLabel,
		Iterable<String> dependencies = const [],
	}) : contract = KlpDefinition<T>(id, dependencies: dependencies, semantics: semantics, slots: klpTemplateSlots(content));

	/// 與模板 selector 相同，泛型上轉後仍保留原本實例型別資格。
	String? selectAccessibilityLabel(KlpNode node) {
		final selector = accessibilityLabel;
		if (selector == null) {
			return null;
		}
		if (node is! T) {
			throw ArgumentError.value(node, 'node', 'Component definition received an incompatible node.');
		}
		return selector(node);
	}
}
