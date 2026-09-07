import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis.dart';

void main() {
	test('scope resolution prefers region over page and app', () {
		final controller = KlpKeyBindingController();
		final calls = <String>[];
		final activator = const SingleActivator(LogicalKeyboardKey.keyK);

		controller.register(
			binding: const KlpKeyBinding(
				commandId: 'app.command',
				activator: SingleActivator(LogicalKeyboardKey.keyK),
				scope: KlpKeyBindingScope.app,
			),
			action: () => calls.add('app'),
		);
		controller.register(
			binding: const KlpKeyBinding(
				commandId: 'page.command',
				activator: SingleActivator(LogicalKeyboardKey.keyK),
				scope: KlpKeyBindingScope.page,
				scopeId: 'page',
			),
			action: () => calls.add('page'),
		);
		controller.register(
			binding: KlpKeyBinding(
				commandId: 'region.command',
				activator: activator,
				scope: KlpKeyBindingScope.region,
				scopeId: 'explorer',
			),
			action: () => calls.add('region'),
		);

		controller.activatePage('page');
		expect(controller.shortcuts[activator], isA<KlpCommandIntent>());
		controller.activateRegion(regionId: 'explorer');
		final intent = controller.shortcuts[activator] as KlpCommandIntent;
		controller.invoke(intent.commandId);

		expect(calls, ['region']);
	});
}
