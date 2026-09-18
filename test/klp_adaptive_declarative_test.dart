import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/widgets.dart';
import 'package:kallopis/kallopis_declarative.dart';
import 'package:kallopis/src/features/navigation/rail/contracts/klp_rail.dart';

import 'support/klp_test_primitives.dart';

final class _TestScreenBody implements KlpCompositeNode, KlpScreenBody {
	@override
	final KlpId id;
	_TestScreenBody(this.id);
	@override
	final KlpChildren children = KlpChildren([]);
	@override
	String get definitionId => 'test.body';
}

void main() {
	group('KlpAdaptive 宣告式自適應與降級機制測試', () {
		test('KlpAdaptive 只建立命中平台策略', () {
			final root = KlpId.root('test');
			final windows = _Strategy(root / 'windows');
			final android = _Strategy(root / 'android');
			final adaptive = KlpAdaptive(
				id: root / 'adaptive',
				fallback: _TestScreenBody(root / 'fallback'),
				strategies: {
					KlpAdaptivePlatform.windows: windows,
					KlpAdaptivePlatform.android: android,
				},
			);

			final children = adaptive.childrenFor(const KlpAdaptiveContext(
				platform: KlpAdaptivePlatform.windows,
				deviceClass: KlpDeviceClass.desktop,
				orientation: KlpOrientation.landscape,
				displayMode: KlpDisplayMode.nativeApp,
			));

			expect(windows.calls, 1);
			expect(android.calls, 0);
			expect(children.assignments, hasLength(1));
			expect(children.single.id, root / 'windows');
		});

		testWidgets('application host 只把目前平台交給命中策略', (tester) async {
			final root = KlpId.root('test');
			final selected = _RailStrategy(root / 'selected');
			final unselected = _RailStrategy(root / 'unselected');
			final destination = KlpDestination<Object?, Object?>(root / 'home');
			final source = KlpMutableState(
				KlpApplication(
					title: 'Adaptive strategy',
					primitives: klpTestPrimitives(),
					router: KlpRouter(
						id: root / 'router',
						initial: destination.location(null),
						routes: [
							KlpRoute(
								destination,
								screen: (_) => KlpScreen(
									id: root / 'screen',
									accessibilityLabel: 'Adaptive strategy',
									child: KlpAdaptive(
										id: root / 'adaptive',
										fallback: KlpRail(id: root / 'fallback'),
										strategies: {
											_currentPlatform(): selected,
											_otherPlatform(): unselected,
										},
									),
								),
							),
						],
					),
				),
			);
			addTearDown(source.dispose);

			runKlpApp(source.readOnly);
			await tester.pump();
			await tester.pump();

			expect(selected.calls, greaterThanOrEqualTo(1));
			expect(unselected.calls, 0);
			expect(tester.takeException(), isNull);
			await tester.pumpWidget(const SizedBox.shrink());
		});
	});
}

final class _Strategy implements KlpPlatformStrategy {
	final KlpId id;
	int calls = 0;

	_Strategy(this.id);

	@override
	KlpCompositeNode build(KlpAdaptiveContext context) {
		calls++;
		return _TestScreenBody(id);
	}
}

final class _RailStrategy implements KlpPlatformStrategy {
	final KlpId id;
	int calls = 0;

	_RailStrategy(this.id);

	@override
	KlpCompositeNode build(KlpAdaptiveContext context) {
		calls++;
		return KlpRail(id: id);
	}
}

KlpAdaptivePlatform _currentPlatform() => switch (defaultTargetPlatform) {
	TargetPlatform.android => KlpAdaptivePlatform.android,
	TargetPlatform.iOS => KlpAdaptivePlatform.ios,
	TargetPlatform.windows => KlpAdaptivePlatform.windows,
	TargetPlatform.macOS => KlpAdaptivePlatform.macos,
	TargetPlatform.linux => KlpAdaptivePlatform.linux,
	TargetPlatform.fuchsia => KlpAdaptivePlatform.other,
};

KlpAdaptivePlatform _otherPlatform() => switch (_currentPlatform()) {
	KlpAdaptivePlatform.android => KlpAdaptivePlatform.windows,
	_ => KlpAdaptivePlatform.android,
};
