import 'dart:io';
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
	test('entire foundation has no upward or engine directive', () {
		// 完整掃描模組，不匯入尚未存在的新 URI。
		final files = preparedDartFiles('lib/src/foundation');
		expect(files, isNotEmpty);
		final violations = [for (final path in files) ...foundationViolations(path, File(path).readAsStringSync())]..sort();
		expect(violations, isEmpty, reason: violations.join('\n'));
	});
	test('guard covers package relative conditional part and engine targets', () {
		const path = 'lib/src/foundation/probe/check.dart';
		const source = """
import 'package:kallopis/src/features/../features/a.dart';
export '../../runtime/b.dart';
import 'safe.dart' if (dart.library.io) '../../application/c.dart';
export 'safe.dart' if (dart.library.html) '../../rendering/d.dart';
import 'package:krepis_block_note/krepis_block_note.dart';
export 'package:krepis_canva/krepis_canva.dart';
import 'package:blocknote/blocknote.dart';
export 'package:canva/canva.dart';
import 'package:kallopis/src/capabilities/editing/safe.dart';
import 'package:other/src/features/safe.dart';
// import '../../features/comment.dart';
part '../../features/e.dart';
""";
		expect(foundationViolations(path, source), [
			'$path -> lib/src/features/a.dart',
			'$path -> lib/src/runtime/b.dart',
			'$path -> lib/src/application/c.dart',
			'$path -> lib/src/rendering/d.dart',
			'$path -> package:krepis_block_note/krepis_block_note.dart',
			'$path -> package:krepis_canva/krepis_canva.dart',
			'$path -> package:blocknote/blocknote.dart',
			'$path -> package:canva/canva.dart',
			'$path -> lib/src/features/e.dart',
		]);
		expect(foundationViolations(path, "part of '../../features/owner.dart';"), ['$path -> lib/src/features/owner.dart']);
		expect(foundationViolations(path, "import '../binding/safe.dart';"), isEmpty);
	});
	test('35 moves have unique declarations and no old shims', () {
		expect(_moves.length, 35);
		final declarations = <String, List<String>>{};
		for (final path in preparedDartFiles('lib')) {
			for (final name in preparedDeclarations(preparedUnit(path))) {
				declarations.putIfAbsent(name, () => []).add(path);
			}
		}
		for (final entry in _moves.entries) {
			final (target, names) = entry.value;
			expect(File(entry.key).existsSync(), isFalse, reason: '禁止舊 shim：${entry.key}');
			expect(File(target).existsSync(), isTrue, reason: '必須實體搬移：$target');
			expect(preparedDeclarations(preparedUnit(target)).toSet(), names.toSet(), reason: target);
			for (final name in names) {
				expect(declarations[name], [target], reason: '單一宣告身分：$name');
			}
		}
	});
	test('parts have one reciprocal same-module owner', () {
		final owners = <String, List<String>>{};
		final units = {for (final path in preparedDartFiles('lib')) path: preparedUnit(path)};
		for (final entry in units.entries) {
			for (final directive in entry.value.directives.whereType<PartDirective>()) {
				final target = preparedPath(entry.key, directive.uri.stringValue!);
				expect(target.split('/').take(3), entry.key.split('/').take(3), reason: '${entry.key} -> $target');
				owners.putIfAbsent(target, () => []).add(entry.key);
				expect(units.containsKey(target), isTrue, reason: target);
			}
		}
		for (final entry in units.entries) {
			for (final directive in entry.value.directives.whereType<PartOfDirective>()) {
				expect(owners[entry.key]?.length, 1, reason: entry.key);
				if (directive.uri != null) {
					expect(owners[entry.key], [preparedPath(entry.key, directive.uri!.stringValue!)]);
				}
			}
		}
	});
	test('all public barrels keep prepared libraries unreachable', () {
		final contracts = preparedDartFiles('lib/src/foundation').where((path) => path.contains('/binding/contracts/'));
		expect(contracts, isNotEmpty, reason: 'LOWER-V1-r1 binding contracts must exist before public reachability is checked');
		final entries = preparedDartFiles('lib', recursive: false);
		expect(entries, containsAll(['lib/kallopis.dart', 'lib/kallopis_foundation.dart', 'lib/kallopis_declarative.dart']));
		for (final entry in entries) {
			final forbidden = preparedExportClosure(entry).where((path) => path.contains('/binding/internal/') || path.contains('/binding/contracts/') || path.contains('/editing/presentation/') || path.contains('/workspace/presentation/'));
			expect(forbidden, isEmpty, reason: entry);
		}
	});
}

List<String> preparedDartFiles(String path, {bool recursive = true}) {
	// 直接列舉實際 Dart 來源，避免以人工清冊縮減掃描。
	return Directory(path).listSync(recursive: recursive).whereType<File>().map((file) => file.path.replaceAll('\\', '/')).where((path) => path.endsWith('.dart')).toList()..sort();
}

CompilationUnit preparedUnit(String path) {
	// AST 忽略註解，保留條件指令及真正宣告。
	return parseString(content: File(path).readAsStringSync(), path: path, throwIfDiagnostics: true).unit;
}

Iterable<String> preparedDeclarations(CompilationUnit unit) sync* {
	for (final declaration in unit.declarations) {
		switch (declaration) {
			case ClassDeclaration():
				yield declaration.namePart.typeName.lexeme;
			case EnumDeclaration():
				yield declaration.namePart.typeName.lexeme;
			case TypeAlias():
				yield declaration.name.lexeme;
			case ExtensionTypeDeclaration():
				yield declaration.primaryConstructor.typeName.lexeme;
			case MixinDeclaration():
				yield declaration.name.lexeme;
			case FunctionDeclaration():
				yield declaration.name.lexeme;
			case ExtensionDeclaration():
				if (declaration.name != null) yield declaration.name!.lexeme;
			case TopLevelVariableDeclaration():
				yield* declaration.variables.variables.map((variable) => variable.name.lexeme);
		}
	}
}

Iterable<String> preparedUris(Directive directive) sync* {
	if (directive is ImportDirective) {
		yield directive.uri.stringValue!;
		yield* directive.configurations.map((item) => item.uri.stringValue!);
	}
	else if (directive is ExportDirective) {
		yield directive.uri.stringValue!;
		yield* directive.configurations.map((item) => item.uri.stringValue!);
	}
	else if (directive is PartDirective) {
		yield directive.uri.stringValue!;
	}
	else if (directive is PartOfDirective && directive.uri != null) {
		yield directive.uri!.stringValue!;
	}
}

String preparedPath(String owner, String target) {
	const prefix = 'package:kallopis/';
	if (target.startsWith(prefix)) return Uri.parse('lib/${target.substring(prefix.length)}').normalizePath().path;
	if (Uri.parse(target).hasScheme) return target;

	return Uri.parse(owner).resolve(target).normalizePath().path;
}

List<String> foundationViolations(String path, String source) {
	final unit = parseString(content: source, path: path, throwIfDiagnostics: true).unit;
	final violations = <String>[];
	for (final directive in unit.directives) {
		for (final uri in preparedUris(directive)) {
			final target = preparedPath(path, uri);
			final upward = RegExp(r'^lib/src/(features|runtime|application|rendering)/').hasMatch(target);
			final engine = RegExp(r'^package:[^/]*(krepis|block_?note|canva)', caseSensitive: false).hasMatch(target);
			if (upward || engine) violations.add('$path -> $target');
		}
	}
	return violations;
}

Set<String> preparedExportClosure(String entry) {
	final reached = <String>{};
	void visit(String path) {
		if (!path.startsWith('lib/') || !reached.add(path)) return;

		for (final directive in preparedUnit(path).directives) {
			if (directive is ExportDirective || directive is PartDirective) {
				for (final target in preparedUris(directive)) {
					visit(preparedPath(path, target));
				}
			}
		}
	}
	visit(entry);
	return reached;
}

Map<String, String> preparedPublicSymbols(String entry, [Set<String>? visiting]) {
	final active = {...?visiting};
	if (!entry.startsWith('lib/') || !active.add(entry)) return {};

	final unit = preparedUnit(entry);
	final result = {for (final name in preparedDeclarations(unit)) if (!name.startsWith('_')) name: entry};
	for (final directive in unit.directives) {
		if (directive is! ExportDirective && directive is! PartDirective) continue;

		for (final target in preparedUris(directive)) {
			final symbols = preparedPublicSymbols(preparedPath(entry, target), active);
			if (directive is ExportDirective) {
				for (final combinator in directive.combinators) {
					if (combinator is ShowCombinator) {
						final shown = combinator.shownNames.map((name) => name.name).toSet();
						symbols.removeWhere((name, _) => !shown.contains(name));
					}
					else if (combinator is HideCombinator) {
						final hidden = combinator.hiddenNames.map((name) => name.name).toSet();
						symbols.removeWhere((name, _) => hidden.contains(name));
					}
				}
			}
			result.addAll(symbols);
		}
	}
	return result;
}

// 已接受搬移及基線宣告身分固定於測試，不讀可變產品清冊。
const _moves = <String, (String, List<String>)>{
	'lib/src/foundation/binding/internal/klp_bound_editing.dart': ('lib/src/features/editing/presentation/klp_bound_editing.dart', ['KlpBoundEditing']),
	'lib/src/foundation/binding/internal/klp_bound_block_note_editing.dart': ('lib/src/features/editing/presentation/klp_bound_block_note_editing.dart', ['KlpBoundBlockNoteEditing']),
	'lib/src/foundation/binding/internal/klp_bound_canva_editing.dart': ('lib/src/features/editing/presentation/klp_bound_canva_editing.dart', ['KlpBoundCanvaEditing']),
	'lib/src/foundation/binding/internal/klp_bound_editing_layout.dart': ('lib/src/features/editing/presentation/klp_bound_editing_layout.dart', ['KlpBoundEditingLayout']),
	'lib/src/foundation/binding/internal/klp_bound_editing_actions.dart': ('lib/src/features/editing/presentation/klp_bound_editing_actions.dart', ['KlpBoundEditingActions']),
	'lib/src/foundation/binding/internal/klp_bound_block_controls.dart': ('lib/src/features/editing/presentation/klp_bound_block_controls.dart', ['KlpBoundBlockControls']),
	'lib/src/foundation/binding/internal/klp_bound_block_controls_slot.dart': ('lib/src/features/editing/presentation/klp_bound_block_controls_slot.dart', ['KlpBoundBlockControlsSlot']),
	'lib/src/foundation/binding/internal/klp_bound_block_actions.dart': ('lib/src/features/editing/presentation/klp_bound_block_actions.dart', ['KlpBoundBlockActions']),
	'lib/src/foundation/binding/internal/klp_bound_anchored_commands.dart': ('lib/src/features/editing/presentation/klp_bound_anchored_commands.dart', ['KlpBoundAnchoredCommands']),
	'lib/src/foundation/binding/internal/klp_bound_anchored_commands_slot.dart': ('lib/src/features/editing/presentation/klp_bound_anchored_commands_slot.dart', ['KlpBoundAnchoredCommandsSlot']),
	'lib/src/foundation/binding/internal/klp_bound_anchored_command_actions.dart': ('lib/src/features/editing/presentation/klp_bound_anchored_command_actions.dart', ['KlpBoundAnchoredCommandActions']),
	'lib/src/foundation/binding/internal/klp_bound_mode_toolbar.dart': ('lib/src/features/editing/presentation/klp_bound_mode_toolbar.dart', ['KlpBoundModeToolbar']),
	'lib/src/foundation/binding/internal/klp_bound_mode_toolbar_slot.dart': ('lib/src/features/editing/presentation/klp_bound_mode_toolbar_slot.dart', ['KlpBoundModeToolbarSlot']),
	'lib/src/foundation/binding/internal/klp_bound_editor_mode_actions.dart': ('lib/src/features/editing/presentation/klp_bound_editor_mode_actions.dart', ['KlpBoundEditorModeActions']),
	'lib/src/foundation/binding/internal/klp_bound_editing_save_actions.dart': ('lib/src/features/editing/presentation/klp_bound_editing_save_actions.dart', ['KlpBoundEditingSaveActions']),
	'lib/src/foundation/binding/internal/klp_bound_editing_style.dart': ('lib/src/features/editing/presentation/klp_bound_editing_style.dart', ['KlpBoundEditingStyle']),
	'lib/src/foundation/binding/internal/klp_bound_app_layout.dart': ('lib/src/features/workspace/presentation/klp_bound_app_layout.dart', ['KlpBoundAppLayout']),
	'lib/src/foundation/binding/internal/klp_bound_frame_groups.dart': ('lib/src/features/workspace/presentation/klp_bound_frame_groups.dart', ['KlpBoundFrameGroups']),
	'lib/src/foundation/binding/internal/klp_bound_frame_group.dart': ('lib/src/features/workspace/presentation/klp_bound_frame_group.dart', ['KlpBoundFrameGroup']),
	'lib/src/foundation/binding/internal/klp_bound_explorer_item_data.dart': ('lib/src/features/workspace/presentation/klp_bound_explorer_item_data.dart', ['KlpBoundExplorerItemData']),
	'lib/src/foundation/binding/internal/klp_bound_explorer.dart': ('lib/src/features/workspace/presentation/klp_bound_explorer.dart', ['KlpBoundExplorer']),
	'lib/src/foundation/binding/internal/klp_bound_document_tab_data.dart': ('lib/src/features/workspace/presentation/klp_bound_document_tab_data.dart', ['KlpBoundDocumentTabData']),
	'lib/src/foundation/binding/internal/klp_bound_document_tabs.dart': ('lib/src/features/workspace/presentation/klp_bound_document_tabs.dart', ['KlpBoundDocumentTabs']),
	'lib/src/foundation/binding/internal/klp_bound_window_controls.dart': ('lib/src/features/workspace/presentation/klp_bound_window_controls.dart', ['KlpBoundWindowControls']),
	'lib/src/foundation/binding/internal/klp_bound_workspace_data.dart': ('lib/src/features/workspace/presentation/klp_bound_workspace_data.dart', ['KlpBoundWorkspaceData']),
	'lib/src/foundation/binding/internal/klp_bound_workspace_item.dart': ('lib/src/features/workspace/presentation/klp_bound_workspace_item.dart', ['KlpBoundWorkspaceItem']),
	'lib/src/foundation/binding/internal/klp_bound_workspace_choice.dart': ('lib/src/features/workspace/presentation/klp_bound_workspace_choice.dart', ['KlpBoundWorkspaceChoice']),
	'lib/src/foundation/binding/internal/klp_bound_workspace_content.dart': ('lib/src/features/workspace/presentation/klp_bound_workspace_content.dart', ['KlpBoundWorkspaceContent']),
	'lib/src/foundation/binding/internal/klp_bound_workspace_content_block.dart': ('lib/src/features/workspace/presentation/klp_bound_workspace_content_block.dart', ['KlpBoundWorkspaceContentBlock']),
	'lib/src/foundation/binding/internal/klp_bound_workspace_block.dart': ('lib/src/features/workspace/presentation/klp_bound_workspace_block.dart', ['KlpBoundWorkspaceBlock']),
	'lib/src/foundation/binding/internal/klp_bound_workspace_command.dart': ('lib/src/features/workspace/presentation/klp_bound_workspace_command.dart', ['KlpBoundWorkspaceCommand']),
	'lib/src/foundation/interaction/internal/klp_button_style.dart': ('lib/src/features/actions/button/internal/klp_button_style.dart', ['KlpButtonStyle']),
	'lib/src/foundation/interaction/filter/klp_selection_toolbar.dart': ('lib/src/features/actions/selection_toolbar/klp_selection_toolbar.dart', []),
	'lib/src/foundation/interaction/filter/internal/klp_selection_toolbar_widget.dart': ('lib/src/features/actions/selection_toolbar/internal/klp_selection_toolbar_widget.dart', ['KlpSelectionToolbar']),
	'lib/src/foundation/interaction/filter/primitives/klp_selection_toolbar_dashed_frame.dart': ('lib/src/features/actions/selection_toolbar/primitives/klp_selection_toolbar_dashed_frame.dart', ['_KlpSelectionToolbarDashedFrame']),
};
