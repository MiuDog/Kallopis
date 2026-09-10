import 'package:analyzer/error/error.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/klp_external_compile_fixture.dart';

const _kinds = {
	'color': 'KlpColor',
	'fontFamily': 'KlpFontFamily',
	'fontSize': 'KlpFontSize',
	'fontWeight': 'KlpFontWeight',
	'lineHeight': 'KlpLineHeight',
	'letterSpacing': 'KlpLetterSpacing',
	'distance': 'KlpDistance',
	'radius': 'KlpRadius',
};
const _rawTextValues = {
	'color': 'KlpColor(0, 0, 0)',
	'fontFamily': "KlpFontFamily('External')",
	'fontSize': 'KlpFontSize(12)',
	'fontWeight': 'KlpFontWeight(400)',
	'lineHeight': 'KlpLineHeight(1)',
	'letterSpacing': 'KlpLetterSpacing(0)',
};

String _textSemantics([Map<String, String> overrides = const {}]) => 'KlpTextSemantics(${_rawTextValues.keys.map((field) => '$field: ${overrides[field] ?? '${field}Key'}').join(', ')})';
String _linear(String children, String gap) => 'KlpLinearTemplate<ExternalItem>(axis: KlpAxis.vertical, children: $children, gap: $gap)';
String _surface(Map<String, String> overrides) => 'KlpSurfaceTemplate<ExternalItem>(child: ${overrides['child'] ?? 'linear'}, background: ${overrides['background'] ?? 'colorKey'}, radius: ${overrides['radius'] ?? 'radiusKey'}, inset: ${overrides['inset'] ?? 'distanceKey'})';

void main() {
	late KlpExternalCompileFixture fixture;
	final cases = <({String name, String source, String code})>[];
	final prefix = '''import 'package:kallopis/kallopis_declarative.dart';
import 'package:flutter/widgets.dart';
final class ExternalItem implements KlpRailItem {
	@override final String id;
	final String label;
	ExternalItem(this.id, this.label);
	@override String get definitionId => 'external';
	@override Iterable<KlpNode> get children => const [];
	@override String get accessibilityLabel => label;
	@override KlpAction? get action => null;
}
${_kinds.entries.map((entry) => "final ${entry.key}Key = KlpSemanticKey<${entry.value}>('external', '${entry.key}', KlpStyleKind.${entry.key});").join('\n')}
final textSemantics = ${_textSemantics()};
final text = KlpTextTemplate<ExternalItem>(text: (item) => item.label, semantics: textSemantics);
final linear = ${_linear('[text]', 'distanceKey')};
final surface = ${_surface(const {})};
final schema = KlpSemanticSchema('external', [${_kinds.entries.map((entry) => 'KlpSemanticToken<${entry.value}>(${entry.key}Key, KlpPrimitiveRef<${entry.value}>(KlpStyleKind.${entry.key}, KlpPrimitiveIndex.i0))').join(', ')}]);
String contextSelector(BuildContext context) => 'context';
''';
	// 步驟 1：封閉模板不能透過外部子型別增加渲染能力。
	for (final type in ['KlpTemplate', 'KlpTextTemplate', 'KlpLinearTemplate', 'KlpSurfaceTemplate']) {
		for (final relation in ['extends', 'implements']) {
			var code = 'sealed_class_subtype_outside_of_library';
			if (type != 'KlpTemplate') {
				code = relation == 'extends' ? 'final_class_extended_outside_of_library' : 'final_class_implemented_outside_of_library';
			}
			cases.add((name: '$relation $type', source: 'abstract final class Escape $relation $type<ExternalItem> {}', code: code));
		}
	}
	for (final value in ['const SizedBox()', 'text']) {
		cases.add((name: 'selector cannot return $value', source: 'final invalid = KlpTextTemplate<ExternalItem>(text: (item) => $value, semantics: textSemantics);', code: 'return_of_invalid_type_from_closure'));
	}
	cases.add((name: 'selector cannot receive context', source: 'final invalid = KlpTextTemplate<ExternalItem>(text: contextSelector, semantics: textSemantics);', code: 'argument_type_not_assignable'));
	cases.add((name: 'template has no widget builder', source: 'final invalid = KlpTextTemplate<ExternalItem>(text: (item) => item.label, semantics: textSemantics, builder: (BuildContext context) => const SizedBox());', code: 'undefined_named_parameter'));
	cases.add((name: 'linear children reject widget', source: 'final invalid = ${_linear('[const SizedBox()]', 'distanceKey')};', code: 'list_element_type_not_assignable'));
	cases.add((name: 'surface child rejects widget', source: 'final invalid = ${_surface({'child': 'const SizedBox()'})};', code: 'argument_type_not_assignable'));
	cases.add((name: 'component content rejects widget', source: "final invalid = KlpComponentDefinition<ExternalItem>('external', content: const SizedBox(), semantics: schema);", code: 'argument_type_not_assignable'));
	cases.add((name: 'accessibility selector rejects widget', source: "final invalid = KlpComponentDefinition<ExternalItem>('external', content: surface, semantics: schema, accessibilityLabel: (item) => const SizedBox());", code: 'return_of_invalid_type_from_closure'));
	cases.add((name: 'accessibility selector rejects context', source: "final invalid = KlpComponentDefinition<ExternalItem>('external', content: surface, semantics: schema, accessibilityLabel: contextSelector);", code: 'argument_type_not_assignable'));
	cases.add((name: 'component has no accessibility builder', source: "final invalid = KlpComponentDefinition<ExternalItem>('external', content: surface, semantics: schema, accessibilityBuilder: (BuildContext context) => const SizedBox());", code: 'undefined_named_parameter'));

	// 步驟 2：每個文字與容器風格入口都必須保留語意鍵的量值型別。
	for (final entry in _rawTextValues.entries) {
		for (final value in [entry.value, 'distanceKey']) {
			cases.add((name: 'text ${entry.key} rejects $value', source: 'final invalid = ${_textSemantics({entry.key: value})};', code: 'argument_type_not_assignable'));
		}
	}
	cases.add((name: 'text rejects raw Flutter color', source: "final invalid = ${_textSemantics({'color': 'const Color(0xff000000)'})};", code: 'argument_type_not_assignable'));
	cases.add((name: 'text rejects raw font size', source: "final invalid = ${_textSemantics({'fontSize': '12.0'})};", code: 'argument_type_not_assignable'));
	for (final value in ['1.0', 'KlpDistance(1)', 'colorKey']) {
		cases.add((name: 'linear gap rejects $value', source: 'final invalid = ${_linear('[text]', value)};', code: 'argument_type_not_assignable'));
	}
	final surfaceValues = {
		'background': ['const Color(0xff000000)', 'KlpColor(0, 0, 0)', 'distanceKey'],
		'radius': ['1.0', 'KlpRadius(1)', 'distanceKey'],
		'inset': ['1.0', 'KlpDistance(1)', 'colorKey'],
	};
	for (final entry in surfaceValues.entries) {
		for (final value in entry.value) {
			cases.add((name: 'surface ${entry.key} rejects $value', source: 'final invalid = ${_surface({entry.key: value})};', code: 'argument_type_not_assignable'));
		}
	}

	setUpAll(() async {
		fixture = await KlpExternalCompileFixture.create({
			'positive': "${prefix}final definition = KlpComponentDefinition<ExternalItem>('external', content: surface, semantics: schema, accessibilityLabel: (item) => item.label);\nfinal rail = KlpRail(id: 'rail', top: [ExternalItem('item', 'Label')]);\n",
			for (final item in cases) item.name: '$prefix${item.source}\n',
		});
		addTearDown(fixture.dispose);
	});

	test('external rail item definition composes text linear and surface templates', () async {
		final result = await fixture.resolve('positive');
		expect(result.diagnostics.where((diagnostic) => diagnostic.diagnosticCode.severity == DiagnosticSeverity.ERROR), isEmpty, reason: result.diagnostics.join('\n'));
	});
	for (final item in cases) {
		test('external template contract rejects ${item.name}', () async {
			final result = await fixture.resolve(item.name);
			final targetLine = '\n'.allMatches(prefix).length + 1;
			final errors = result.diagnostics.where((diagnostic) => diagnostic.diagnosticCode.severity == DiagnosticSeverity.ERROR);
			// 控制組與匯入必須正常；指定錯誤僅能落在最後一列的違規用法。
			expect(errors.where((error) => result.lineInfo.getLocation(error.offset).lineNumber < targetLine), isEmpty, reason: result.diagnostics.join('\n'));
			final expected = errors.where((error) => error.diagnosticCode.lowerCaseUniqueName == item.code && result.lineInfo.getLocation(error.offset).lineNumber == targetLine);
			expect(expected, isNotEmpty, reason: '${item.name}: ${item.code} at line $targetLine\n${result.diagnostics.join('\n')}');
		});
	}
}
