import 'package:kallopis/kallopis_declarative.dart';

import 'klp_runtime_demo/demo_primitives.dart';
import 'klp_runtime_demo/demo_rail_definition.dart';
import 'klp_runtime_demo/demo_rail_item.dart';
import 'klp_runtime_demo/demo_counter.dart';
import 'klp_runtime_demo/demo_counter_definition.dart';

/// 首頁 A 計數、B 開啟次頁、C 換風格；次頁 A 回傳結果、B 取消。
void main() {
	final definition = demoRailDefinition();
	final counterDefinition = demoCounterDefinition();
	final destination = KlpDestination<Object?, Object?>('demo.main');
	final details = KlpDestination<int, int>('demo.details');
	final firstStyle = demoPrimitives(alternate: false);
	final secondStyle = demoPrimitives(alternate: true);
	var alternate = false;
	var count = 0;
	var lastAction = '-';
	late final KlpMutableState<KlpApplication> source;
	late void Function(String) activate;

	KlpApplication declaration() {
		return KlpApplication(
			title: 'Klp router demo | A: count/result | B: open/back | C: style | $lastAction / $count',
			primitives: alternate ? secondStyle : firstStyle,
			router: KlpRouter(id: 'demo.router', initial: destination.location(null), routes: [
				KlpRoute<Object?, Object?>(destination, screen: (input) => KlpScreen(id: 'demo.screen', accessibilityLabel: 'Demo home', child: KlpRail(
					id: 'demo.rail',
					top: [DemoRailItem(id: 'a', label: 'A', counter: DemoCounter(id: 'a.counter', value: count), action: KlpCallbackAction(() => activate('A')))],
					center: [DemoRailItem(id: 'b', label: 'B', counter: DemoCounter(id: 'b.counter', value: count), action: input.navigate(details.location(count), onResult: (value) {
						count = value;
						lastAction = 'result';
						source.value = declaration();
					}))],
					bottom: [DemoRailItem(id: 'c', label: 'C', counter: DemoCounter(id: 'c.counter', value: count), action: KlpCallbackAction(() => activate('C')))],
				))),
				KlpRoute<int, int>(details, screen: (input) => KlpScreen(id: 'demo.screen', accessibilityLabel: 'Demo details', child: KlpRail(
					id: 'demo.rail',
					top: [DemoRailItem(id: 'a', label: 'R', counter: DemoCounter(id: 'a.counter', value: input.parameters), action: input.finish(input.parameters + 1))],
					center: [DemoRailItem(id: 'b', label: 'X', counter: DemoCounter(id: 'b.counter', value: input.parameters), action: input.back())],
					bottom: [DemoRailItem(id: 'c', label: 'C', counter: DemoCounter(id: 'c.counter', value: count), action: KlpCallbackAction(() => activate('C')))],
				))),
			]),
			components: [definition, counterDefinition],
		);
	}

	activate = (action) {
		count++;
		lastAction = action;
		if (action == 'C') alternate = !alternate;
		source.value = declaration();
	};
	source = KlpMutableState(declaration());
	runKlpApp(source.readOnly);
}
