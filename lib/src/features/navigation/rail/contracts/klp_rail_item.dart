import '../../../../composition/nodes/klp_node.dart';
import '../../../../capabilities/actions/klp_action.dart';

/// Rail 插槽資格；外部項目只提供內容與操作，不取得渲染或風格權限。
abstract interface class KlpRailItem implements KlpNode {

	String get accessibilityLabel;
	KlpAction? get action;
}
