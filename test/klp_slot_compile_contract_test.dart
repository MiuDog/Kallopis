import 'package:analyzer/error/error.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/klp_external_compile_fixture.dart';

const _prefix = '''import 'package:kallopis/kallopis_declarative.dart';
import 'package:flutter/widgets.dart';
abstract interface class CardItem implements KlpNode {}
final class ExternalItem implements CardItem, KlpRailItem {
	@override final String id;
	ExternalItem(this.id);
	@override String get definitionId => 'external.item';
	@override Iterable<KlpNode> get children => const [];
	@override String get accessibilityLabel => id;
	@override KlpAction? get action => null;
}
final class OtherNode implements KlpNode {
	@override String get id => 'other';
	@override String get definitionId => 'external.other';
	@override Iterable<KlpNode> get children => const [];
}
final slot = KlpSlot<CardItem>(owner: 'external.panel', name: 'items', min: 1);
final gap = KlpSemanticKey<KlpDistance>('external.panel', 'gap', KlpStyleKind.distance);
final class ExternalPanel implements KlpCompositeNode, KlpScreenBody {
	@override final String id;
	@override final KlpChildren children;
	ExternalPanel(this.id, List<CardItem> items) : children = KlpChildren([slot.assign(items)]);
	@override String get definitionId => 'external.panel';
}
final template = KlpChildrenTemplate<ExternalPanel, CardItem>(slot: slot, axis: KlpAxis.vertical, gap: gap);
final schema = KlpSemanticSchema('external.panel', [KlpSemanticToken(gap, KlpPrimitiveRef(KlpStyleKind.distance, KlpPrimitiveIndex.i1))]);
final definition = KlpComponentDefinition<ExternalPanel>('external.panel', content: template, semantics: schema);
final item = ExternalItem('item');
final panel = ExternalPanel('panel', [item]);
''';

void main() {
	late KlpExternalCompileFixture fixture;
	final cases = <({String name, String source, String code})>[
		(name: 'unqualified child', source: 'final invalid = slot.assign([OtherNode()]);', code: 'list_element_type_not_assignable'),
		(name: 'native widget child', source: 'final invalid = slot.assign([const SizedBox()]);', code: 'list_element_type_not_assignable'),
		(name: 'native widget qualification', source: "final invalid = KlpSlot<Widget>(owner: 'external.panel', name: 'widgets');", code: 'type_argument_not_matching_bounds'),
		(name: 'raw children without assignment', source: 'final invalid = KlpChildren([item]);', code: 'list_element_type_not_assignable'),
		(name: 'assignment direct construction', source: 'final invalid = KlpSlotAssignment<CardItem>(slot, [item]);', code: 'new_with_undefined_constructor_default'),
		(name: 'plain iterable children getter', source: "final class Invalid implements KlpCompositeNode { @override String get id => 'bad'; @override String get definitionId => 'bad'; @override Iterable<KlpNode> get children => const []; }", code: 'invalid_override'),
		(name: 'list children getter', source: "final class Invalid implements KlpCompositeNode { @override String get id => 'bad'; @override String get definitionId => 'bad'; @override List<KlpNode> get children => const []; }", code: 'invalid_override'),
		(name: 'missing children getter', source: "final class Invalid implements KlpCompositeNode { @override String get id => 'bad'; @override String get definitionId => 'bad'; }", code: 'non_abstract_class_inherits_abstract_member_one'),
		(name: 'assignment style override', source: 'final invalid = slot.assign([item], gap: gap);', code: 'undefined_named_parameter'),
		(name: 'children raw style', source: 'final invalid = KlpChildren([slot.assign([item])], gap: 12);', code: 'undefined_named_parameter'),
		(name: 'template raw gap', source: 'final invalid = KlpChildrenTemplate<ExternalPanel, CardItem>(slot: slot, axis: KlpAxis.vertical, gap: KlpDistance(12));', code: 'argument_type_not_assignable'),
		(name: 'template wrong qualification', source: 'final invalid = KlpChildrenTemplate<ExternalPanel, OtherNode>(slot: slot, axis: KlpAxis.vertical, gap: gap);', code: 'argument_type_not_assignable'),
		(name: 'template children selector', source: 'final invalid = KlpChildrenTemplate<ExternalPanel, CardItem>(slot: slot, axis: KlpAxis.vertical, gap: gap, children: (panel) => [item]);', code: 'undefined_named_parameter'),
		(name: 'template widget builder', source: 'final invalid = KlpChildrenTemplate<ExternalPanel, CardItem>(slot: slot, axis: KlpAxis.vertical, gap: gap, builder: (BuildContext context) => const SizedBox());', code: 'undefined_named_parameter'),
	];

	// 封閉資料容器與模板禁止由外部子型別替換資格、子樹或渲染行為。
	for (final type in ['KlpChildren', 'KlpSlot<CardItem>', 'KlpSlotAssignment<CardItem>', 'KlpChildrenTemplate<ExternalPanel, CardItem>']) {
		for (final relation in ['extends', 'implements']) {
			final code = relation == 'extends' ? 'final_class_extended_outside_of_library' : 'final_class_implemented_outside_of_library';
			cases.add((name: '$relation $type', source: 'abstract final class Escape $relation $type {}', code: code));
		}
	}

	setUpAll(() async {
		fixture = await KlpExternalCompileFixture.create({
			'positive': "${_prefix}final screen = KlpScreen(id: 'screen', accessibilityLabel: 'Screen', child: panel);\nfinal rail = KlpRail(id: 'rail', top: [item]);\n",
			for (final item in cases) item.name: '$_prefix${item.source}\n',
		});
		addTearDown(fixture.dispose);
	});

	test('external composite uses public slots and supports multiple child qualifications', () async {
		final result = await fixture.resolve('positive');
		expect(result.diagnostics.where((diagnostic) => diagnostic.diagnosticCode.severity == DiagnosticSeverity.ERROR), isEmpty, reason: result.diagnostics.join('\n'));
	});
	for (final item in cases) {
		test('external slot contract rejects ${item.name}', () async {
			final result = await fixture.resolve(item.name);
			final targetLine = '\n'.allMatches(_prefix).length + 1;
			final errors = result.diagnostics.where((diagnostic) => diagnostic.diagnosticCode.severity == DiagnosticSeverity.ERROR);
			// 控制組不能失敗；預期診斷必須精確指向額外加入的違規用法。
			expect(errors.where((error) => result.lineInfo.getLocation(error.offset).lineNumber < targetLine), isEmpty, reason: result.diagnostics.join('\n'));
			final expected = errors.where((error) => error.diagnosticCode.lowerCaseUniqueName == item.code && result.lineInfo.getLocation(error.offset).lineNumber == targetLine);
			expect(expected, isNotEmpty, reason: '${item.name}: ${item.code} at line $targetLine\n${result.diagnostics.join('\n')}');
		});
	}
}
