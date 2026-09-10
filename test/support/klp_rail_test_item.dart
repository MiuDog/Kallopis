import 'package:kallopis/kallopis_declarative.dart';

import '../klp_test_menu_item.dart';

/// 同時具備兩種插槽資格，保留消費端提供的資料與操作。
final class KlpRailTestItem implements KlpRailItem, KlpTestMenuItem {

	@override
	final String id;
	@override
	final String accessibilityLabel;
	@override
	final KlpAction? action;
	@override
	final List<KlpNode> children = const [];

	KlpRailTestItem(this.id, {this.accessibilityLabel = 'Item', this.action});

	@override
	String get definitionId => 'custom.railItem';
}
