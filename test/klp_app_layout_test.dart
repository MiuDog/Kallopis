import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis_declarative.dart';

import 'support/klp_component_test_item.dart';

void main() {
	test('KlpAppLayout keeps a pure typed tree and preserves layout order', () {
		final frame = KlpAppFrame(id: KlpId.parse('left'), child: _groups('content'));
		final layout = KlpAppLayout(
			id: KlpId.parse('layout'),
			child: LayoutRow(
				id: KlpId.parse('row'),
				children: [
					frame,
					LayoutResizeHandle(id: KlpId.parse('handle')),
					LayoutColumn(
						id: KlpId.parse('right'),
						children: [
							KlpAppFrame(id: KlpId.parse('second'), child: _groups('second_content')),
						],
					),
				],
			),
		);

		expect(layout.children.single, isA<LayoutRow>());
		expect(layout.child.children.map((child) => child.id.value), ['left', 'handle', 'right']);
		expect(frame.children.single.id.value, 'content.groups');
		expect(frame.role, KlpAppFrameRole.content);
	});

	test('KlpAppFrame requires a Frame group root', () {
		final groups = _groups('content');
		final frame = KlpAppFrame(id: KlpId.parse('frame'), child: groups);

		expect(frame.child, same(groups));
	});
}

KlpFrameGroups _groups(String id) => KlpFrameGroups(
	id: KlpId.parse('$id.groups'),
	groups: [
		KlpFrameGroup(
			id: KlpId.parse('$id.group'),
			content: [KlpComponentTestItem(id: KlpId.parse(id))],
		),
	],
);
