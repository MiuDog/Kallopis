import 'package:kallopis/kallopis_declarative.dart';

import 'klp_test_menu_item.dart';
import 'klp_test_rail_item.dart';

final class KlpTestItem implements KlpTestRailItem, KlpTestMenuItem {

	@override
	String id;
	@override
	String definitionId;
	@override
	final List<KlpNode> children;

	KlpTestItem(this.id, this.definitionId, [List<KlpNode>? children]) : children = children ?? [];
}
