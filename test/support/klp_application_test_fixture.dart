import 'package:kallopis/kallopis_declarative.dart';

import 'klp_component_test_item.dart';
import 'klp_test_primitives.dart';

final _applicationDestination = KlpDestination<Object?, Object?>(
	KlpId.parse('fixture.main'),
);

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
		router: KlpRouter(
			id: KlpId.parse('fixture.router'),
			initial: _applicationDestination.location(null),
			routes: [
				KlpRoute(
					_applicationDestination,
					screen: (_) => KlpScreen(
						id: KlpId.parse('screen'),
						accessibilityLabel: title,
			child: KlpAppLayout(
				id: KlpId.parse('layout'),
				child: KlpAppFrame(
					id: KlpId.parse('frame'),
					child: KlpFrameGroups(
						id: KlpId.parse('groups'),
						groups: [
							KlpFrameGroup(
								id: KlpId.parse('group'),
								content: [
									for (final item in items)
										KlpWorkspaceBlock(
											id: item.id,
											kind: KlpWorkspaceBlockKind.action,
											title: select?.call(item) ?? item.label,
											action: item.action,
										),
									if (items.isEmpty)
										KlpWorkspaceBlock(
											id: KlpId.parse('empty'),
											kind: KlpWorkspaceBlockKind.paper,
											title: title,
										),
								],
							),
						],
					),
				),
			),
					),
				),
			],
		),
	);
}
