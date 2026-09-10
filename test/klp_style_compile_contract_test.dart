import 'package:analyzer/error/error.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/klp_external_compile_fixture.dart';

const _publicImport = "import 'package:kallopis/kallopis_declarative.dart';\n";
const _colorKey = "KlpSemanticKey<KlpColor>('external', 'foreground', KlpStyleKind.color)";
const _colorRef = 'KlpPrimitiveRef<KlpColor>(KlpStyleKind.color, KlpPrimitiveIndex.i0)';
const _distanceRef = 'KlpPrimitiveRef<KlpDistance>(KlpStyleKind.distance, KlpPrimitiveIndex.i0)';
const _primitiveFields = {
	'colors': 'KlpColor(0, 0, 0)',
	'distances': 'KlpDistance(1)',
	'radii': 'KlpRadius(1)',
	'strokeWidths': 'KlpStrokeWidth(1)',
	'fontSizes': 'KlpFontSize(12)',
	'fontWeights': 'KlpFontWeight(400)',
	'lineHeights': 'KlpLineHeight(1)',
	'letterSpacings': 'KlpLetterSpacing(0)',
	'durations': 'KlpDuration(100)',
	'fontFamilies': "KlpFontFamily('External')",
	'curves': 'KlpCurve(0, 0, 1, 1)',
};

String _fields([String? omitted]) => _primitiveFields.entries.where((entry) => entry.key != omitted).map((entry) => '${entry.key}: List.filled(8, ${entry.value})').join(', ');

void main() {
	late KlpExternalCompileFixture fixture;
	final cases = <({String name, String source, String code})>[];

	// 步驟 1：逐一鎖住封閉基底與全部公開變體，不以任意解析錯誤代替契約。
	for (final type in ['KlpStyleValue', 'KlpStyleRef<KlpColor>']) {
		for (final relation in ['extends', 'implements']) {
			cases.add((name: '$relation $type', source: 'abstract final class External $relation $type {}', code: 'sealed_class_subtype_outside_of_library'));
		}
	}
	for (final type in ['KlpPrimitiveSet', 'KlpStyleKind<KlpColor>', 'KlpColor', 'KlpDistance', 'KlpRadius', 'KlpStrokeWidth', 'KlpFontSize', 'KlpFontWeight', 'KlpLineHeight', 'KlpLetterSpacing', 'KlpDuration', 'KlpFontFamily', 'KlpCurve', 'KlpPrimitiveRef<KlpColor>', 'KlpSemanticRef<KlpColor>']) {
		for (final relation in ['extends', 'implements']) {
			final code = relation == 'extends' ? 'final_class_extended_outside_of_library' : 'final_class_implemented_outside_of_library';
			cases.add((name: '$relation $type', source: 'abstract final class External $relation $type {}', code: code));
		}
	}
	cases.add((name: 'custom kind constructor', source: 'final custom = new KlpStyleKind<KlpColor>();', code: 'new_with_undefined_constructor_default'));
	cases.add((name: 'custom literal reference', source: 'final class Literal extends KlpStyleRef<KlpColor> { final KlpColor value; Literal(this.value); @override KlpStyleKind<KlpColor> get kind => KlpStyleKind.color; }', code: 'sealed_class_subtype_outside_of_library'));
	cases.add((name: 'distance reference cannot supply color token', source: 'final token = KlpSemanticToken<KlpColor>($_colorKey, $_distanceRef);', code: 'argument_type_not_assignable'));
	for (final field in _primitiveFields.keys) {
		cases.add((name: 'required primitive $field', source: 'final primitives = KlpPrimitiveSet(${_fields(field)});', code: 'missing_required_argument'));
	}
	cases.add((name: 'unknown primitive field', source: 'final primitives = KlpPrimitiveSet(${_fields()}, unknown: <KlpColor>[]);', code: 'undefined_named_parameter'));
	cases.add((name: 'primitive has no partial copy', source: 'final next = KlpPrimitiveSet(${_fields()}).copyWith(colors: <KlpColor>[]);', code: 'undefined_method'));

	setUpAll(() async {
		final positive = '''${_publicImport}final primitives = KlpPrimitiveSet(${_fields()});
final key = $_colorKey;
final token = KlpSemanticToken<KlpColor>(key, $_colorRef, isPublic: true);
final alias = KlpSemanticToken<KlpColor>(KlpSemanticKey<KlpColor>('external', 'alias', KlpStyleKind.color), KlpSemanticRef<KlpColor>(key));
final schema = KlpSemanticSchema('external', [token, alias]);
''';
		fixture = await KlpExternalCompileFixture.create({'positive': positive, for (final item in cases) item.name: '$_publicImport${item.source}\n'});
		addTearDown(fixture.dispose);
	});

	test('legal external primitive and semantic schema resolves without errors', () async {
		final result = await fixture.resolve('positive');
		final errors = result.diagnostics.where((diagnostic) => diagnostic.diagnosticCode.severity == DiagnosticSeverity.ERROR);
		expect(errors, isEmpty, reason: result.diagnostics.join('\n'));
	});

	for (final item in cases) {
		test('external compile contract rejects ${item.name}', () async {
			final result = await fixture.resolve(item.name);
			// 匯入列不可有錯；拒絕原因必須是第二列違規用法的精確診斷碼。
			expect(result.diagnostics.where((diagnostic) => result.lineInfo.getLocation(diagnostic.offset).lineNumber == 1), isEmpty);
			final matching = result.diagnostics.where((diagnostic) => diagnostic.diagnosticCode.lowerCaseUniqueName == item.code && result.lineInfo.getLocation(diagnostic.offset).lineNumber == 2);
			expect(matching, isNotEmpty, reason: '${item.name}: expected ${item.code} at line 2\n${result.diagnostics.join('\n')}');
		});
	}
}
