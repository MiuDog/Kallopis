import '../slots/klp_children.dart';
import 'klp_node.dart';

/// 外部複合節點必須以封閉插槽配置交付子樹，不能另設子項選取函式。
abstract interface class KlpCompositeNode implements KlpNode {

	@override
	KlpChildren get children;
}
