import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis_declarative.dart';
import 'package:kallopis/src/rendering/flutter/internal/klp_flutter_choice.dart';

import 'support/klp_component_test_definition.dart';
import 'support/klp_component_test_item.dart';
import 'support/klp_test_primitives.dart';

KlpScreen _screen(String label, {KlpAction? action}) => KlpScreen(id: 'screen', accessibilityLabel: label, child: KlpRail(id: 'rail', center: [KlpComponentTestItem(id: 'item', label: label, action: action)]));
KlpApplication _app(KlpDestination<int, String> home, List<KlpRoute<Object?, Object?>> routes, {String title = 'Review'}) => KlpApplication(title: title, primitives: klpTestPrimitives(), router: KlpRouter(id: 'router', initial: home.location(0), routes: routes), components: [klpComponentTestDefinition()]);

void main() {
	testWidgets('refresh revokes an action captured from the prior committed entry', (tester) async {
		final home = KlpDestination<int, String>('home');
		final detail = KlpDestination<int, String>('detail');
		final firstRoute = KlpRoute<int, String>(home, screen: (input) => _screen('First', action: input.navigate(detail.location(1))));
		final detailRoute = KlpRoute<int, String>(detail, screen: (_) => _screen('Detail'));
		final source = KlpMutableState(_app(home, [firstRoute, detailRoute]));
		addTearDown(source.dispose);
		runKlpApp(source.readOnly);
		await tester.pump();
		await tester.pump();
		final stale = tester.widget<KlpFlutterChoice>(find.byType(KlpFlutterChoice)).content;
		source.value = _app(home, [KlpRoute<int, String>(home, screen: (input) => _screen('Fresh', action: input.back())), detailRoute], title: 'Fresh');
		await tester.pump();
		await stale.onActivate!();
		await tester.pump();
		expect(tester.widget<KlpFlutterChoice>(find.byType(KlpFlutterChoice)).content.label, 'Fresh');
		expect(tester.takeException(), isNull);
	});

	testWidgets('root back action is rejected without changing rail selection', (tester) async {
		final home = KlpDestination<int, String>('home');
		final source = KlpMutableState(_app(home, [KlpRoute<int, String>(home, screen: (input) => _screen('Home', action: input.back()))]));
		addTearDown(source.dispose);
		runKlpApp(source.readOnly);
		await tester.pump();
		await tester.pump();
		final choice = tester.widget<KlpFlutterChoice>(find.byType(KlpFlutterChoice)).content;
		await choice.onActivate!();
		await tester.pump();
		expect(choice.selection.value, isNull);
		expect(tester.takeException(), isNull);
	});
}
