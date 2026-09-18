import 'package:kallopis/kallopis_declarative.dart';
import 'package:kallopis/src/capabilities/actions/klp_action.dart';

/// 只用公開宣告式策略記錄真正宿主交付的環境，不自行解析平台。
final class KlpEnvironmentHostFixture implements KlpPlatformStrategy {

	final List<KlpAdaptiveContext> observations = [];
	int activations = 0;
	final destination = KlpDestination<Object?, Object?>(KlpId.parse('environment.main'));

	KlpApplication application({String title = 'Environment host'}) {
		final adaptive = KlpAdaptive(id: KlpId.parse('adaptive'), fallback: _layout(), strategies: {for (final platform in KlpAdaptivePlatform.values) platform: this});
		final screen = KlpScreen(id: KlpId.parse('screen'), accessibilityLabel: title, child: adaptive);
		final route = KlpRoute(destination, screen: (_) => screen);
		final router = KlpRouter(id: KlpId.parse('router'), initial: destination.location(null), routes: [route]);
		return KlpApplication(title: title, router: router);
	}

	@override
	KlpCompositeNode build(KlpAdaptiveContext context) {
		observations.add(context);
		return _layout();
	}

	KlpAppLayout _layout() {
		final block = KlpWorkspaceBlock(id: KlpId.parse('action'), kind: KlpWorkspaceBlockKind.action, title: 'Activate', action: KlpCallbackAction(() => activations++));
		final group = KlpFrameGroup(id: KlpId.parse('group'), content: [block]);
		final groups = KlpFrameGroups(id: KlpId.parse('groups'), groups: [group]);
		return KlpAppLayout(id: KlpId.parse('layout'), child: KlpAppFrame(id: KlpId.parse('frame'), child: groups));
	}
}
