import 'package:kallopis/kallopis_declarative.dart';
import 'package:kallopis/src/features/navigation/rail/contracts/klp_rail_item.dart';

/// 同時符合 rail item 與 screen body 的消費端複合資料，沒有渲染入口。
final class KlpCompositeTestNode
		implements KlpCompositeNode, KlpRailItem, KlpScreenBody {
	@override
	final KlpId id;
	final String label;
	@override
	final KlpChildren children;
	@override
	final KlpAction? action;

	KlpCompositeTestNode(
		this.id,
		this.children, {
		this.label = 'Group',
		this.action,
	});

	@override
	String get definitionId => 'fixture';
	@override
	String get accessibilityLabel => label;
}
