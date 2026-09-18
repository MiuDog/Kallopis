import 'package:kallopis/kallopis_declarative.dart';

import 'klp_runtime_demo/demo_primitives.dart';

/// 示範 consumer 只用庫擁有元件、資料與 callback 更新唯一 application source。
void main() {
	final destination = KlpDestination<Object?, Object?>(KlpId.parse('demo.main'));
	final firstStyle = demoPrimitives(alternate: false);
	final secondStyle = demoPrimitives(alternate: true);
	var alternate = false;
	var count = 0;
	late final KlpMutableState<KlpApplication> source;

	KlpApplication declaration() {
		final scope = KlpId.parse('demo');

		return KlpApplication(
			title: 'Klp closed catalog demo | count: $count',
			primitives: alternate ? secondStyle : firstStyle,
			router: KlpRouter(
				id: scope / 'router',
				initial: destination.location(null),
				routes: [
					KlpRoute<Object?, Object?>(
						destination,
						screen: (_) => KlpScreen(
							id: scope / 'screen',
							accessibilityLabel: 'Closed catalog demo',
							child: KlpAppLayout(
								id: scope / 'layout',
								child: KlpAppFrame(
									id: scope / 'frame',
									child: KlpFrameGroups(
										id: scope / 'groups',
										groups: [
											KlpFrameGroup(
												id: scope / 'actions',
												content: [
													KlpWorkspaceBlock(
														id: scope / 'count',
														kind: KlpWorkspaceBlockKind.action,
														title: 'Count',
														subtitle: '$count',
														onPressed: () {
															count++;
															source.value = declaration();
														},
													),
													KlpWorkspaceBlock(
														id: scope / 'style',
														kind: KlpWorkspaceBlockKind.action,
														title: 'Switch primitive set',
														onPressed: () {
															alternate = !alternate;
															source.value = declaration();
														},
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

	source = KlpMutableState(declaration());
	runKlpApp(source.readOnly);
}
