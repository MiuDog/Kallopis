import '../../composition/nodes/klp_node.dart';
import '../../composition/slots/klp_slot.dart';
import '../../styling/primitives/klp_style_value.dart';
import '../../styling/semantics/klp_semantic_key.dart';
import 'klp_axis.dart';
import 'klp_text_semantics.dart';

part 'klp_text_template.dart';
part 'klp_linear_template.dart';
part 'klp_surface_template.dart';
part 'klp_children_template.dart';

/// 元件定義期使用的封閉模板；不提供外部渲染或風格求值入口。
sealed class KlpTemplate<T extends KlpNode> {

	const KlpTemplate();

	/// 泛型上轉不能取消模板自身的資料資格。
	bool accepts(KlpNode node) => node is T;
}
