import 'package:kallopis/kallopis_declarative.dart';

/// 示範 consumer 只用庫擁有元件、資料與 callback 更新唯一 application source。
void main() {
	final destination = KlpDestination<Object?, Object?>(KlpId.parse('demo.main'));
	var count = 0;
	late final KlpMutableState<KlpApplication> source;

	KlpApplication declaration() {
		final scope = KlpId.parse('demo');

		return KlpApplication(
			title: 'Klp closed catalog demo | count: $count',
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
												id: scope / 'reset',
												kind: KlpWorkspaceBlockKind.action,
												title: 'Reset count',
												onPressed: () {
													count = 0;
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
