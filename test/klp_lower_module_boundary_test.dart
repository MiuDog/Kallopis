import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:flutter_test/flutter_test.dart';
import 'klp_prepared_module_boundary_test.dart' show preparedDartFiles, preparedUnit, preparedDeclarations, preparedUris, preparedPath;

void main() {

	test('provider keeps exactly 44 exports with 42 editing contracts and 9 parts', () {
		const provider = 'lib/kallopis_editing_provider.dart';
		final units = lowerUnits();
		final exports = units[provider]!.directives.whereType<ExportDirective>().toList();
		expect(exports.length, 44);
		expect(exports.every((directive) => directive.combinators.isEmpty && directive.configurations.isEmpty), isTrue, reason: '保留完整原符號可達性');
		final expected = lowerMoves.values.map((move) => move.$1).where((path) => path.contains('/editing/contracts/') && !path.endsWith('/klp_block_drop_preview.dart')).toSet();
		expect(expected.length, 51);
		final actual = exports.map((directive) => preparedPath(provider, directive.uri.stringValue!)).toSet();
		expect(actual.where((path) => path.contains('/editing/')), hasLength(42));
		expect(actual.difference(expected), {'lib/src/kernel/diagnostics/klp_contract_error.dart', 'lib/src/capabilities/state/klp_state.dart'});
		final closure = lowerExportClosure(provider, units);
		expect(closure.where((path) => path.contains('/editing/')).toSet(), expected);
		final partCount = expected.where((path) => units[path]!.directives.any((directive) => directive is PartOfDirective)).length;
		expect(partCount, 9);
		final expectedNames = {'KlpState', 'KlpContractError', for (final move in lowerMoves.values.where((move) => expected.contains(move.$1))) ...move.$2};
		expect(expectedNames.length, 90);
		final actualNames = {for (final path in closure) ...preparedDeclarations(units[path]!).where((name) => !name.startsWith('_'))};
		expect(actualNames, expectedNames, reason: '公開符號完整保留且不新增');
	});
	test('all public barrels keep submission drop helpers and bound contracts private', () {
		final units = lowerUnits();
		final entries = preparedDartFiles('lib', recursive: false);
		expect(units, contains('lib/src/capabilities/editing/internal/klp_editing_draw_command_validation.dart'));
		expect(entries, containsAll(['lib/kallopis_editing_provider.dart', 'lib/kallopis_foundation.dart', 'lib/kallopis_theme.dart', 'lib/kallopis_declarative.dart']));
		for (final entry in entries) {
			final forbidden = lowerExportClosure(entry, units).where((path) => path.contains('/binding/contracts/') || RegExp(r'/klp_(editing_submission|block_drop_preview|block_drop_target|editing_draw_command_validation)\.dart$').hasMatch(path));
			expect(forbidden, isEmpty, reason: entry);
		}
	});
	test('15 foundation contracts retain abstract template and 11 library parts', () {
		final units = lowerUnits();
		final paths = lowerMoves.values.map((move) => move.$1).where((path) => path.contains('/foundation/binding/contracts/')).toSet();
		expect(paths.length, 15);
		expect(paths.every(units.containsKey), isTrue, reason: '具名 contracts 必須存在，禁止空集合通過');
		expect(paths.where((path) => units[path]!.directives.any((directive) => directive is PartOfDirective)), hasLength(11));
		final template = units['lib/src/foundation/binding/contracts/klp_bound_template.dart']!.declarations.whereType<ClassDeclaration>().single;
		expect(template.abstractKeyword, isNotNull, reason: '保留套件內 abstract 呈現協定');
	});
	test('all rendering sources reject every foreign module internal edge', () {
		final units = lowerUnits();
		final rendering = units.keys.where((path) => path.startsWith('lib/src/rendering/')).toSet();
		expect(rendering, contains('lib/src/rendering/flutter/klp_flutter_renderer.dart'));
		expect(rendering.length, greaterThan(23), reason: '掃描完整 rendering，不能以搬移清單取代來源集合');
		final violations = lowerRenderingViolations(units);
		expect(violations, isEmpty, reason: violations.join('\n'));
	});
	test('guard follows normalized conditional exports parts and named owners', () {
		const source = 'lib/src/rendering/probe/check.dart';
		final units = lowerSynthetic({
			source: """
import 'package:kallopis/src/styling/probe/../internal/a.dart';
export '../../application/internal/b.dart';
import 'safe.dart' if (dart.library.io) '../../runtime/internal/c.dart';
export 'safe.dart' if (dart.library.html) '../../features/internal/d.dart';
import '../../capabilities/public.dart';
import '../../future_module/public.dart';
// import '../../kernel/internal/comment.dart';
part '../../foundation/internal/e.dart';
""",
			'lib/src/rendering/probe/safe.dart': '',
			'lib/src/styling/internal/a.dart': '',
			'lib/src/application/internal/b.dart': '',
			'lib/src/runtime/internal/c.dart': '',
			'lib/src/features/internal/d.dart': '',
			'lib/src/foundation/internal/e.dart': '',
			'lib/src/capabilities/public.dart': "export 'internal/hidden.dart';",
			'lib/src/capabilities/internal/hidden.dart': '',
			'lib/src/future_module/public.dart': "export 'safe.dart' if (dart.library.io) 'internal/hidden.dart';",
			'lib/src/future_module/safe.dart': '',
			'lib/src/future_module/internal/hidden.dart': '',
			'lib/src/rendering/probe/named.dart': 'part of foreign.library;',
			'lib/src/kernel/internal/owner.dart': "library foreign.library; part '../../rendering/probe/named.dart';",
			'lib/src/rendering/probe/uri_part.dart': "part of '../../kernel/internal/owner.dart';",
		});
		final violations = lowerRenderingViolations(units);
		for (final target in ['styling/internal/a.dart', 'application/internal/b.dart', 'runtime/internal/c.dart', 'features/internal/d.dart', 'foundation/internal/e.dart', 'capabilities/internal/hidden.dart', 'future_module/internal/hidden.dart']) {
			expect(violations, contains('$source -> lib/src/$target'));
		}
		expect(violations, contains('lib/src/rendering/probe/named.dart -> lib/src/kernel/internal/owner.dart'));
		expect(violations, contains('lib/src/rendering/probe/uri_part.dart -> lib/src/kernel/internal/owner.dart'));
		expect(violations.length, 9);
	});
	test('guard accepts own internals and contract implementation imports', () {
		final units = lowerSynthetic({
			'lib/src/rendering/probe/check.dart': "import '../internal/local.dart'; import '../../capabilities/contracts/value.dart'; import 'package:other/src/foundation/internal/a.dart';",
			'lib/src/rendering/internal/local.dart': "library local.library; part '../probe/part.dart';",
			'lib/src/rendering/probe/part.dart': 'part of local.library;',
			'lib/src/capabilities/contracts/value.dart': "import '../internal/validator.dart'; export 'other.dart'; part 'value_part.dart';",
			'lib/src/capabilities/contracts/other.dart': '',
			'lib/src/capabilities/contracts/value_part.dart': "part of 'value.dart';",
			'lib/src/capabilities/internal/validator.dart': '',
		});
		expect(lowerRenderingViolations(units), isEmpty);
		expect(lowerPartViolations(units), isEmpty);
	});
	test('all 71 moves retain one public declaration and remove old shims', () {
		final units = lowerUnits();
		expect(lowerMoves.length, 71);
		final allDeclarations = <String, List<String>>{};
		for (final entry in units.entries) {
			for (final name in preparedDeclarations(entry.value).where((name) => !name.startsWith('_'))) {
				allDeclarations.putIfAbsent(name, () => []).add(entry.key);
			}
		}
		final failures = <String>[];
		for (final entry in lowerMoves.entries) {
			final (target, names) = entry.value;
			if (units.containsKey(entry.key)) failures.add('禁止舊路徑或 shim：${entry.key}');
			if (!units.containsKey(target)) {
				failures.add('必須實體搬移：$target');
				continue;
			}

			final actual = preparedDeclarations(units[target]!).where((name) => !name.startsWith('_')).toSet();
			expect(actual, names.toSet(), reason: target);
			for (final name in names) {
				expect(allDeclarations[name], [target], reason: '單一宣告身分：$name');
			}
		}
		expect(failures, isEmpty, reason: failures.join('\n'));
	});
	test('all parts have one reciprocal owner in the same module', () {
		final units = lowerUnits();
		expect(units.values.expand((unit) => unit.directives.whereType<PartDirective>()).length, greaterThanOrEqualTo(20));
		final violations = lowerPartViolations(units);
		expect(violations, isEmpty, reason: violations.join('\n'));
	});
	test('part guard rejects missing reverse duplicate named and cross-module owners', () {
		for (final sources in <Map<String, String>>[
			{'lib/src/a/owner.dart': "part 'missing.dart';"},
			{'lib/src/a/owner.dart': "part 'part.dart';", 'lib/src/a/part.dart': ''},
			{'lib/src/a/owner.dart': "part 'part.dart';", 'lib/src/a/part.dart': "part of 'other.dart';"},
			{'lib/src/a/owner.dart': "library correct; part 'part.dart';", 'lib/src/a/part.dart': 'part of wrong;'},
			{'lib/src/a/owner.dart': "library same; part 'part.dart';", 'lib/src/a/other.dart': "library same; part 'part.dart';", 'lib/src/a/part.dart': 'part of same;'},
			{'lib/src/a/owner.dart': "library same; part '../b/part.dart';", 'lib/src/b/part.dart': 'part of same;'},
			{'lib/src/a/part.dart': 'part of missing;'},
		]) {
			expect(lowerPartViolations(lowerSynthetic(sources)), isNotEmpty, reason: sources.toString());
		}
	});
}

Map<String, CompilationUnit> lowerUnits() => {for (final path in preparedDartFiles('lib')) path: preparedUnit(path)};

Map<String, CompilationUnit> lowerSynthetic(Map<String, String> sources) => {for (final entry in sources.entries) entry.key: parseString(content: entry.value, path: entry.key, throwIfDiagnostics: true).unit};

String? lowerLibraryName(CompilationUnit unit) {
	for (final directive in unit.directives.whereType<LibraryDirective>()) {
		return RegExp(r'^library\s+([\w.]+)\s*;').firstMatch(directive.toSource())?.group(1);
	}
	return null;
}

Iterable<String> lowerTargets(String path, Directive directive, Map<String, CompilationUnit> units) sync* {
	// URI 指令使用正規化路徑；具名 part 必須找到真正 library，不能忽略它。
	yield* preparedUris(directive).map((uri) => preparedPath(path, uri));
	if (directive is PartOfDirective && directive.uri == null) {
		final name = directive.libraryName?.toSource();
		for (final entry in units.entries) {
			if (name != null && lowerLibraryName(entry.value) == name) yield entry.key;
		}
	}
}

Set<String> lowerExportClosure(String entry, Map<String, CompilationUnit> units) {
	final reached = <String>{};
	void visit(String path) {
		if (!path.startsWith('lib/') || !reached.add(path)) return;

		final unit = units[path];
		if (unit == null) throw StateError('缺少被引用的來源：$path');

		for (final directive in unit.directives) {
			if (directive is ExportDirective || directive is PartDirective) {
				for (final target in lowerTargets(path, directive, units)) {
					visit(target);
				}
			}
		}
	}
	visit(entry);
	return reached;
}

List<String> lowerRenderingViolations(Map<String, CompilationUnit> units) {
	final violations = <String>{};
	for (final entry in units.entries.where((entry) => entry.key.startsWith('lib/src/rendering/'))) {
		for (final directive in entry.value.directives) {
			for (final target in lowerTargets(entry.key, directive, units)) {
				// 追蹤匯入的公開命名空間；契約自身的私有 import 不成為 renderer 的直接邊。
				for (final reached in lowerExportClosure(target, units)) {
					if (reached.startsWith('lib/src/') && !reached.startsWith('lib/src/rendering/') && reached.split('/').skip(3).contains('internal')) {
						violations.add('${entry.key} -> $reached');
					}
				}
			}
		}
	}
	return violations.toList()..sort();
}

List<String> lowerPartViolations(Map<String, CompilationUnit> units) {
	final violations = <String>[];
	final owners = <String, List<String>>{};
	for (final entry in units.entries) {
		for (final directive in entry.value.directives.whereType<PartDirective>()) {
			final target = preparedPath(entry.key, directive.uri.stringValue!);
			owners.putIfAbsent(target, () => []).add(entry.key);
			if (!units.containsKey(target)) violations.add('缺少 part：$target');
			if (entry.key.split('/').take(3).join('/') != target.split('/').take(3).join('/')) violations.add('跨模組 part：${entry.key} -> $target');
		}
	}
	for (final path in {...owners.keys, ...units.keys.where((path) => units[path]!.directives.any((directive) => directive is PartOfDirective))}) {
		final ownerPaths = owners[path] ?? [];
		final reverse = units[path]?.directives.whereType<PartOfDirective>().toList() ?? [];
		if (ownerPaths.length != 1 || reverse.length != 1) {
			violations.add('part 需唯一雙向 owner：$path');
			continue;
		}

		final targets = lowerTargets(path, reverse.single, units).toList();
		if (targets.length != 1 || targets.single != ownerPaths.single) violations.add('part of 不對應 owner：$path');
	}
	return violations;
}

// 固定於 dec5b1b 的已接受 71 檔清冊；不由目前產品路徑反推期望值。
const lowerMoves = <String, (String, List<String>)>{
	'lib/src/capabilities/editing/internal/klp_begin_composition_intent.dart': ('lib/src/capabilities/editing/contracts/klp_begin_composition_intent.dart', ['KlpBeginCompositionIntent']),
	'lib/src/capabilities/editing/internal/klp_block_command_anchor.dart': ('lib/src/capabilities/editing/contracts/klp_block_command_anchor.dart', ['KlpBlockCommandAnchor']),
	'lib/src/capabilities/editing/internal/klp_block_item.dart': ('lib/src/capabilities/editing/contracts/klp_block_item.dart', ['KlpBlockKind', 'KlpBlockItem']),
	'lib/src/capabilities/editing/internal/klp_block_projection.dart': ('lib/src/capabilities/editing/contracts/klp_block_projection.dart', ['KlpBlockProjection']),
	'lib/src/capabilities/editing/internal/klp_block_request.dart': ('lib/src/capabilities/editing/contracts/klp_block_request.dart', ['KlpBlockIntent', 'KlpBlockTextKind', 'KlpBlockRequest']),
	'lib/src/capabilities/editing/internal/klp_block_viewport_request.dart': ('lib/src/capabilities/editing/contracts/klp_block_viewport_request.dart', ['KlpBlockViewportRequest']),
	'lib/src/capabilities/editing/internal/klp_cancel_composition_intent.dart': ('lib/src/capabilities/editing/contracts/klp_cancel_composition_intent.dart', ['KlpCancelCompositionIntent']),
	'lib/src/capabilities/editing/internal/klp_caret_command_anchor.dart': ('lib/src/capabilities/editing/contracts/klp_caret_command_anchor.dart', ['KlpCaretCommandAnchor']),
	'lib/src/capabilities/editing/internal/klp_command_anchor.dart': ('lib/src/capabilities/editing/contracts/klp_command_anchor.dart', ['KlpCommandAnchor']),
	'lib/src/capabilities/editing/internal/klp_command_item.dart': ('lib/src/capabilities/editing/contracts/klp_command_item.dart', ['KlpCommandAvailability', 'KlpCommandTone', 'KlpCommandItem']),
	'lib/src/capabilities/editing/internal/klp_command_projection.dart': ('lib/src/capabilities/editing/contracts/klp_command_projection.dart', ['KlpCommandProjection']),
	'lib/src/capabilities/editing/internal/klp_command_reply.dart': ('lib/src/capabilities/editing/contracts/klp_command_reply.dart', ['KlpCommandReply']),
	'lib/src/capabilities/editing/internal/klp_command_request.dart': ('lib/src/capabilities/editing/contracts/klp_command_request.dart', ['KlpCommandRequest']),
	'lib/src/capabilities/editing/internal/klp_commit_composition_intent.dart': ('lib/src/capabilities/editing/contracts/klp_commit_composition_intent.dart', ['KlpCommitCompositionIntent']),
	'lib/src/capabilities/editing/internal/klp_composition_attribute.dart': ('lib/src/capabilities/editing/contracts/klp_composition_attribute.dart', ['KlpCompositionAttribute']),
	'lib/src/capabilities/editing/internal/klp_composition_segment.dart': ('lib/src/capabilities/editing/contracts/klp_composition_segment.dart', ['KlpCompositionSegment']),
	'lib/src/capabilities/editing/internal/klp_composition_text.dart': ('lib/src/capabilities/editing/contracts/klp_composition_text.dart', ['KlpCompositionText']),
	'lib/src/capabilities/editing/internal/klp_editing_command_intent.dart': ('lib/src/capabilities/editing/contracts/klp_editing_command_intent.dart', ['KlpEditingCommand', 'KlpEditingCommandIntent']),
	'lib/src/capabilities/editing/internal/klp_editing_draw_command.dart': ('lib/src/capabilities/editing/contracts/klp_editing_draw_command.dart', ['KlpEditingPaintRole', 'KlpEditingRect', 'KlpEditingDrawCommand', 'KlpEditingDrawRect', 'KlpEditingDrawPath', 'KlpEditingPushClip', 'KlpEditingPopClip', 'KlpEditingPushTransform', 'KlpEditingPopTransform']),
	'lib/src/capabilities/editing/internal/klp_editing_drawing.dart': ('lib/src/capabilities/editing/contracts/klp_editing_drawing.dart', ['KlpEditingDrawing']),
	'lib/src/capabilities/editing/internal/klp_editing_endpoint.dart': ('lib/src/capabilities/editing/contracts/klp_editing_endpoint.dart', ['KlpEditingAffinity', 'KlpEditingEndpoint']),
	'lib/src/capabilities/editing/internal/klp_editing_intent.dart': ('lib/src/capabilities/editing/contracts/klp_editing_intent.dart', ['KlpEditingIntent']),
	'lib/src/capabilities/editing/internal/klp_editing_interaction.dart': ('lib/src/capabilities/editing/contracts/klp_editing_interaction.dart', ['KlpEditingInteraction', 'KlpEditingInteractionBinding']),
	'lib/src/capabilities/editing/internal/klp_editing_layout.dart': ('lib/src/capabilities/editing/contracts/klp_editing_layout.dart', ['KlpEditingLayout']),
	'lib/src/capabilities/editing/internal/klp_editing_path.dart': ('lib/src/capabilities/editing/contracts/klp_editing_path.dart', ['KlpEditingPathOperation', 'KlpEditingPathCommand', 'KlpEditingPath']),
	'lib/src/capabilities/editing/internal/klp_editing_point_request.dart': ('lib/src/capabilities/editing/contracts/klp_editing_point_request.dart', ['KlpEditingPointRequest']),
	'lib/src/capabilities/editing/internal/klp_editing_projection.dart': ('lib/src/capabilities/editing/contracts/klp_editing_projection.dart', ['KlpEditingProjection']),
	'lib/src/capabilities/editing/internal/klp_editing_reply.dart': ('lib/src/capabilities/editing/contracts/klp_editing_reply.dart', ['KlpEditingDecision', 'KlpEditingReply']),
	'lib/src/capabilities/editing/internal/klp_editing_request.dart': ('lib/src/capabilities/editing/contracts/klp_editing_request.dart', ['KlpEditingRequest']),
	'lib/src/capabilities/editing/internal/klp_editing_save_projection.dart': ('lib/src/capabilities/editing/contracts/klp_editing_save_projection.dart', ['KlpEditingSavePhase', 'KlpEditingSaveError', 'KlpEditingSaveProjection']),
	'lib/src/capabilities/editing/internal/klp_editing_save_reply.dart': ('lib/src/capabilities/editing/contracts/klp_editing_save_reply.dart', ['KlpEditingSaveDecision', 'KlpEditingSaveReply']),
	'lib/src/capabilities/editing/internal/klp_editing_save_request.dart': ('lib/src/capabilities/editing/contracts/klp_editing_save_request.dart', ['KlpEditingSaveIntent', 'KlpEditingSaveRequest']),
	'lib/src/capabilities/editing/internal/klp_editing_save_source.dart': ('lib/src/capabilities/editing/contracts/klp_editing_save_source.dart', ['KlpEditingSaveSource', 'KlpEditingSaveStatePublisher']),
	'lib/src/capabilities/editing/internal/klp_editing_source.dart': ('lib/src/capabilities/editing/contracts/klp_editing_source.dart', ['KlpEditingSource', 'KlpEditingLayoutSource', 'KlpEditableSource', 'KlpBlockControlSource', 'KlpAnchoredCommandSource', 'KlpEditorModeSource']),
	'lib/src/capabilities/editing/internal/klp_editing_stamp.dart': ('lib/src/capabilities/editing/contracts/klp_editing_stamp.dart', ['KlpEditingStamp']),
	'lib/src/capabilities/editing/internal/klp_editing_style.dart': ('lib/src/capabilities/editing/contracts/klp_editing_style.dart', ['KlpEditingMarkerFormat', 'KlpEditingStyle']),
	'lib/src/capabilities/editing/internal/klp_editing_text_window.dart': ('lib/src/capabilities/editing/contracts/klp_editing_text_window.dart', ['KlpEditingTextWindow']),
	'lib/src/capabilities/editing/internal/klp_editing_viewport.dart': ('lib/src/capabilities/editing/contracts/klp_editing_viewport.dart', ['KlpEditingViewport']),
	'lib/src/capabilities/editing/internal/klp_editor_mode_item.dart': ('lib/src/capabilities/editing/contracts/klp_editor_mode_item.dart', ['KlpEditorInputPurpose', 'KlpEditorModeAvailability', 'KlpEditorModeItem']),
	'lib/src/capabilities/editing/internal/klp_editor_mode_projection.dart': ('lib/src/capabilities/editing/contracts/klp_editor_mode_projection.dart', ['KlpEditorModeTransition', 'KlpEditorModeProjection']),
	'lib/src/capabilities/editing/internal/klp_editor_mode_reply.dart': ('lib/src/capabilities/editing/contracts/klp_editor_mode_reply.dart', ['KlpEditorModeReply']),
	'lib/src/capabilities/editing/internal/klp_editor_mode_request.dart': ('lib/src/capabilities/editing/contracts/klp_editor_mode_request.dart', ['KlpEditorModeRequest']),
	'lib/src/capabilities/editing/internal/klp_editor_tool_item.dart': ('lib/src/capabilities/editing/contracts/klp_editor_tool_item.dart', ['KlpEditorPointerKind', 'KlpEditorToolItem']),
	'lib/src/capabilities/editing/internal/klp_editor_viewport_projection.dart': ('lib/src/capabilities/editing/contracts/klp_editor_viewport_projection.dart', ['KlpEditorViewportProjection']),
	'lib/src/capabilities/editing/internal/klp_editor_viewport_request.dart': ('lib/src/capabilities/editing/contracts/klp_editor_viewport_request.dart', ['KlpEditorViewportRequest']),
	'lib/src/capabilities/editing/internal/klp_handwriting_state.dart': ('lib/src/capabilities/editing/contracts/klp_handwriting_state.dart', ['KlpHandwritingPhase', 'KlpHandwritingCaptureIdentity', 'KlpHandwritingState']),
	'lib/src/capabilities/editing/internal/klp_handwriting_state_source.dart': ('lib/src/capabilities/editing/contracts/klp_handwriting_state_source.dart', ['KlpHandwritingStateSource', 'KlpHandwritingStatePublisher']),
	'lib/src/capabilities/editing/internal/klp_replace_text_intent.dart': ('lib/src/capabilities/editing/contracts/klp_replace_text_intent.dart', ['KlpReplaceTextIntent']),
	'lib/src/capabilities/editing/internal/klp_select_text_intent.dart': ('lib/src/capabilities/editing/contracts/klp_select_text_intent.dart', ['KlpSelectTextIntent']),
	'lib/src/capabilities/editing/internal/klp_text_offsets.dart': ('lib/src/capabilities/editing/contracts/klp_text_offsets.dart', ['KlpTextOffsets']),
	'lib/src/capabilities/editing/internal/klp_update_composition_intent.dart': ('lib/src/capabilities/editing/contracts/klp_update_composition_intent.dart', ['KlpUpdateCompositionIntent']),
	'lib/src/capabilities/editing/internal/klp_block_drop_preview.dart': ('lib/src/capabilities/editing/contracts/klp_block_drop_preview.dart', ['KlpBlockDropPlacement', 'KlpBlockDropPreview']),
	'lib/src/capabilities/editing/internal/klp_block_drop_target.dart': ('lib/src/capabilities/editing/klp_block_drop_target.dart', ['KlpBlockDropTarget', 'klpCanDropBlockAt', 'klpBlockDropTargets', 'klpResolveBlockDropTarget']),
	'lib/src/capabilities/editing/internal/klp_editing_submission.dart': ('lib/src/capabilities/editing/klp_editing_submission.dart', ['KlpEditingSubmission']),
	'lib/src/foundation/binding/internal/klp_bound_template.dart': ('lib/src/foundation/binding/contracts/klp_bound_template.dart', ['KlpBoundTemplate']),
	'lib/src/foundation/binding/internal/klp_bound_text_style.dart': ('lib/src/foundation/binding/contracts/klp_bound_text_style.dart', ['KlpBoundTextStyle']),
	'lib/src/foundation/binding/internal/klp_bound_control_style.dart': ('lib/src/foundation/binding/contracts/klp_bound_control_style.dart', ['KlpBoundControlStyle']),
	'lib/src/foundation/binding/internal/klp_bound_choice_style.dart': ('lib/src/foundation/binding/contracts/klp_bound_choice_style.dart', ['KlpBoundChoiceStyle']),
	'lib/src/foundation/binding/internal/klp_bound_text.dart': ('lib/src/foundation/binding/contracts/klp_bound_text.dart', ['KlpBoundText']),
	'lib/src/foundation/binding/internal/klp_bound_linear.dart': ('lib/src/foundation/binding/contracts/klp_bound_linear.dart', ['KlpBoundLinear']),
	'lib/src/foundation/binding/internal/klp_bound_surface.dart': ('lib/src/foundation/binding/contracts/klp_bound_surface.dart', ['KlpBoundSurface']),
	'lib/src/foundation/binding/internal/klp_bound_surface_shadow.dart': ('lib/src/foundation/binding/contracts/klp_bound_surface_shadow.dart', ['KlpBoundSurfaceShadow']),
	'lib/src/foundation/binding/internal/klp_bound_choice.dart': ('lib/src/foundation/binding/contracts/klp_bound_choice.dart', ['KlpBoundChoice']),
	'lib/src/foundation/binding/internal/klp_bound_regions.dart': ('lib/src/foundation/binding/contracts/klp_bound_regions.dart', ['KlpBoundRegions']),
	'lib/src/foundation/binding/internal/klp_bound_extent.dart': ('lib/src/foundation/binding/contracts/klp_bound_extent.dart', ['KlpBoundExtent']),
	'lib/src/foundation/binding/internal/klp_bound_placement.dart': ('lib/src/foundation/binding/contracts/klp_bound_placement.dart', ['KlpBoundPlacement']),
	'lib/src/foundation/binding/internal/klp_bound_retained_stack.dart': ('lib/src/foundation/binding/contracts/klp_bound_retained_stack.dart', ['KlpBoundRetainedStack']),
	'lib/src/foundation/binding/internal/klp_bound_screen.dart': ('lib/src/foundation/binding/contracts/klp_bound_screen.dart', ['KlpBoundScreen']),
	'lib/src/foundation/binding/internal/klp_bound_accessibility.dart': ('lib/src/foundation/binding/contracts/klp_bound_accessibility.dart', ['KlpBoundAccessibility']),
	'lib/src/styling/presets/internal/klp_paper_shadow_recipe.dart': ('lib/src/styling/presets/klp_paper_shadow_recipe.dart', ['KlpPaperShadowRecipe']),
	'lib/src/styling/semantics/internal/klp_control_density.dart': ('lib/src/styling/semantics/klp_control_density.dart', ['KlpControlDensity']),
};
