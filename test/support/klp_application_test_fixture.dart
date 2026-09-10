import 'package:kallopis/kallopis_declarative.dart';

import 'klp_component_test_definition.dart';
import 'klp_component_test_item.dart';
import 'klp_test_primitives.dart';

final _applicationDestination = KlpDestination<Object?, Object?>('fixture.main');

/// 消費端形狀的資料工廠；沒有 Widget、renderer 或局部風格輸入。
KlpApplication klpApplicationTestFixture({
	String title = 'Initial application',
	List<KlpComponentTestItem> items = const [],
	bool alternate = false,
	String Function(KlpComponentTestItem)? select,
}) {
	return KlpApplication(
		title: title,
		primitives: klpTestPrimitives(alternate: alternate),
		router: KlpRouter(id: 'fixture.router', initial: _applicationDestination.location(null), routes: [KlpRoute(_applicationDestination, screen: (_) => KlpScreen(id: 'screen', accessibilityLabel: title, child: KlpRail(id: 'rail', center: items)))]),
		components: [klpComponentTestDefinition(select: select)],
	);
}
