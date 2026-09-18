import 'package:kallopis/kallopis_declarative.dart';

/// 只以公開的庫擁有元件組裝 Catalog 預設內容。
KlpAppLayout sampleContent(KlpId id, String text) {
	return KlpAppLayout(
		id: id,
		child: KlpAppFrame(
			id: id / 'frame',
			child: KlpFrameGroups(
				id: id / 'groups',
				groups: [
					KlpFrameGroup(
						id: id / 'content',
						content: [
							KlpWorkspaceBlock(id: id / 'paper', kind: KlpWorkspaceBlockKind.paper, title: 'Kallopis', lines: [text]),
						],
					),
				],
			),
		),
	);
}
