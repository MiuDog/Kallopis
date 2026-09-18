import 'dart:convert';
import 'dart:io';

import 'package:analyzer/dart/ast/ast.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter_test/flutter_test.dart';

import 'klp_lower_module_boundary_test.dart' show lowerUnits, lowerSynthetic, lowerTargets, lowerExportClosure, lowerPartViolations;
import 'klp_prepared_module_boundary_test.dart' show preparedDartFiles, preparedDeclarations, preparedPath;

void main() {
	late Map<String, CompilationUnit> units;
	setUpAll(() {
		units = lowerUnits();
	});

	test('whole application rejects every foreign module internal edge', () {
		final paths = units.keys.where((path) => path.startsWith(_applicationPrefix)).toSet();
		expect(paths, containsAll(_baseline['applicationPaths'] as List));
		final violations = _applicationViolations(units);
		expect(violations, isEmpty, reason: violations.join('\n'));
	});

	test('scanner detects normalized conditional export part and named owner edges', () {
		const source = '${_applicationPrefix}probe/check.dart';
		final synthetic = lowerSynthetic({
			source: """
import 'package:kallopis/src/styling/probe/../internal/a.dart';
export '../../runtime/internal/b.dart';
import 'safe.dart' if (dart.library.io) '../../features/internal/c.dart';
export 'safe.dart' if (dart.library.html) '../../composition/internal/d.dart';
import '../../capabilities/contracts/barrel.dart';
import '../../future_module/contracts/barrel.dart';
import '../../kernel/contracts/named_part.dart';
part '../../foundation/internal/e.dart';
""",
			'${_applicationPrefix}probe/safe.dart': 'const safe = true;',
			'lib/src/styling/internal/a.dart': '',
			'lib/src/runtime/internal/b.dart': '',
			'lib/src/features/internal/c.dart': '',
			'lib/src/composition/internal/d.dart': '',
			'lib/src/foundation/internal/e.dart': '',
			'lib/src/capabilities/contracts/barrel.dart': "export '../internal/hidden.dart';",
			'lib/src/capabilities/internal/hidden.dart': '',
			'lib/src/future_module/contracts/barrel.dart': "export 'safe.dart' if (dart.library.io) 'second.dart';",
			'lib/src/future_module/contracts/safe.dart': '',
			'lib/src/future_module/contracts/second.dart': "part '../internal/hidden.dart';",
			'lib/src/future_module/internal/hidden.dart': "part of '../contracts/second.dart';",
			'lib/src/kernel/contracts/named_part.dart': 'part of foreign.library;',
			'lib/src/kernel/internal/owner.dart': "library foreign.library; part '../contracts/named_part.dart';",
			'${_applicationPrefix}probe/uri_part.dart': "part of '../../kernel/internal/owner.dart';",
			'${_applicationPrefix}probe/named_part.dart': 'part of foreign.library;',
		});
		final expected = <String>{
			for (final target in ['styling/internal/a.dart', 'runtime/internal/b.dart', 'features/internal/c.dart', 'composition/internal/d.dart', 'foundation/internal/e.dart', 'capabilities/internal/hidden.dart', 'future_module/internal/hidden.dart', 'kernel/internal/owner.dart']) '$source -> lib/src/$target',
			'${_applicationPrefix}probe/uri_part.dart -> lib/src/kernel/internal/owner.dart',
			'${_applicationPrefix}probe/named_part.dart -> lib/src/kernel/internal/owner.dart',
		};
		expect(_applicationViolations(synthetic).toSet(), expected);
	});

	test('scanner accepts own internals and lower contract private implementation imports', () {
		final synthetic = lowerSynthetic({
			'${_applicationPrefix}probe/check.dart': """
import '../internal/local.dart';
import '../../capabilities/contracts/value.dart';
import 'package:other/src/kernel/internal/a.dart';
// import '../../kernel/internal/comment.dart';
/* export '../../runtime/internal/comment.dart'; */
const fake = "import '../../features/internal/string.dart';";
const fakeBlock = '''part '../../composition/internal/string.dart';''';
""",
			'${_applicationPrefix}internal/local.dart': "library local.library; part '../probe/part.dart';",
			'${_applicationPrefix}probe/part.dart': 'part of local.library;',
			'lib/src/capabilities/contracts/value.dart': "import '../internal/validator.dart'; export 'other.dart'; part 'value_part.dart';",
			'lib/src/capabilities/contracts/other.dart': '',
			'lib/src/capabilities/contracts/value_part.dart': "part of 'value.dart';",
			'lib/src/capabilities/internal/validator.dart': '',
		});
		expect(_applicationViolations(synthetic), isEmpty);
		expect(lowerPartViolations(synthetic), isEmpty);
	});

	test('scanner rejects empty scans missing targets and unresolved named owners', () {
		for (final sources in <Map<String, String>>[
			{},
			{'lib/src/features/check.dart': ''},
			{'${_applicationPrefix}check.dart': ''},
			{'${_applicationPrefix}check.dart': "// import '../kernel/internal/fake.dart';"},
			{'${_applicationPrefix}check.dart': "import '../kernel/contracts/missing.dart';"},
			{'${_applicationPrefix}check.dart': 'part of missing.library;'},
			{
				'${_applicationPrefix}check.dart': 'part of duplicate.library;',
				'lib/src/kernel/contracts/one.dart': 'library duplicate.library;',
				'lib/src/kernel/contracts/two.dart': 'library duplicate.library;',
			},
		]) {
			expect(() => _applicationViolations(lowerSynthetic(sources)), throwsStateError, reason: sources.toString());
		}
	});

	test('25 moved sources retain ordered declarations unique identities and no old shims', () {
		expect(_moves, hasLength(25));
		final declarations = <String, List<String>>{};
		for (final entry in units.entries) {
			for (final name in preparedDeclarations(entry.value).where((name) => !name.startsWith('_'))) {
				declarations.putIfAbsent(name, () => []).add(entry.key);
			}
		}
		final failures = <String>[];
		for (final entry in _moves.entries) {
			final target = entry.value['path'] as String;
			if (units.containsKey(entry.key)) failures.add('禁止保留舊來源或 shim：${entry.key}');
			if (!units.containsKey(target)) {
				failures.add('缺少具名來源實體：$target');
				continue;
			}

			final names = List<String>.from(entry.value['names'] as List);
			expect(preparedDeclarations(units[target]!), names, reason: target);
			for (final name in names.where((name) => !name.startsWith('_'))) {
				expect(declarations[name], [target], reason: '唯一宣告身分：$name');
			}
		}
		expect(failures, isEmpty, reason: failures.join('\n'));
	});

	test('all source directives remove old move references including conditional and part edges', () {
		final stale = <String>[];
		for (final entry in units.entries) {
			for (final directive in entry.value.directives) {
				for (final target in lowerTargets(entry.key, directive, units)) {
					if (_moves.containsKey(target)) stale.add('${entry.key} -> $target');
				}
			}
		}
		expect(stale, isEmpty, reason: stale.join('\n'));
	});

	test('navigation keeps exactly five reciprocal parts and renderer remains one library', () {
		const owner = 'lib/src/capabilities/navigation/engine/klp_navigation_machine.dart';
		expect(units.containsKey(owner), isTrue, reason: owner);
		final expected = _navigationParts.map((name) => 'lib/src/capabilities/navigation/engine/$name').toList();
		final parts = units[owner]!.directives.whereType<PartDirective>().map((directive) => preparedPath(owner, directive.uri.stringValue!)).toList();
		expect(parts, expected, reason: '維持原導覽 library 的五個 part 及順序');
		for (final part in expected) {
			expect(units.containsKey(part), isTrue, reason: part);
			final reverse = units[part]!.directives.whereType<PartOfDirective>().toList();
			expect(reverse, hasLength(1), reason: part);
			expect(lowerTargets(part, reverse.single, units), [owner]);
		}
		expect(lowerPartViolations(units), isEmpty);
		const renderer = 'lib/src/rendering/flutter/klp_flutter_renderer.dart';
		expect(units.containsKey(renderer), isTrue, reason: renderer);
		expect(units[renderer]!.directives.where((directive) => directive is PartDirective || directive is PartOfDirective), isEmpty);
	});

	test('reciprocal part control rejects missing reversed duplicate and foreign owners', () {
		for (final sources in <Map<String, String>>[
			{'lib/src/a/owner.dart': "part 'missing.dart';"},
			{'lib/src/a/owner.dart': "part 'part.dart';", 'lib/src/a/part.dart': ''},
			{'lib/src/a/owner.dart': "part 'part.dart';", 'lib/src/a/part.dart': "part of 'wrong.dart';"},
			{'lib/src/a/owner.dart': "library correct; part 'part.dart';", 'lib/src/a/part.dart': 'part of wrong;'},
			{'lib/src/a/owner.dart': "library same; part 'part.dart';", 'lib/src/a/other.dart': "library same; part 'part.dart';", 'lib/src/a/part.dart': 'part of same;'},
			{'lib/src/a/owner.dart': "library same; part '../b/part.dart';", 'lib/src/b/part.dart': 'part of same;'},
		]) {
			expect(lowerPartViolations(lowerSynthetic(sources)), isNotEmpty, reason: sources.toString());
		}
	});

	test('all root public exports retain exact directives order and complete export closure', () {
		final roots = Map<String, dynamic>.from(_baseline['roots'] as Map);
		const legacyRoot = 'lib/kallopis_legacy_file_picker.dart';
		const legacySource = 'lib/src/application/legacy/klp_local_file_picker.dart';
		expect(preparedDartFiles('lib', recursive: false).toSet(), {...roots.keys, legacyRoot});
		expect(units[legacyRoot]!.directives.whereType<ExportDirective>().map((directive) => directive.toSource()), ["export 'src/application/legacy/klp_local_file_picker.dart' show KlpLocalFilePicker;"]);
		expect(lowerExportClosure(legacyRoot, units), {legacyRoot, legacySource});
		for (final entry in roots.entries) {
			final exports = units[entry.key]!.directives.whereType<ExportDirective>().map((directive) => directive.toSource()).toList();
			if (entry.key == 'lib/kallopis_declarative.dart') {
				// 只逆轉已接受的一增一刪，原 export 順序雜湊保持不變。
				const added = "export 'src/capabilities/actions/klp_pick_file_action.dart' show KlpPickFileAction;";
				const removed = "export 'src/features/workspace/components/klp_local_file_picker.dart';";
				expect(exports.where((value) => value == added), hasLength(1));
				expect(exports, isNot(contains(removed)));
				expect(exports.indexOf(added), exports.indexOf("export 'src/capabilities/actions/klp_action.dart';") + 1);
				exports.remove(added);
				exports.insert(exports.indexOf("export 'src/features/workspace/components/klp_workspace_block.dart';") + 1, removed);
			}
			expect(_digest(exports), entry.value['exportsHash'], reason: '公開 export 指令及順序：${entry.key}');
			final closure = lowerExportClosure(entry.key, units).toList()..sort();
			final previousClosure = _beforeHostPorts(entry.key, closure);
			expect(_digest(previousClosure), entry.value['closureHash'], reason: '僅逆轉明列 HOST PORTS delta 後的完整公開匯出閉包：${entry.key}');
			final moved = {..._moves.keys, ..._moves.values.map((move) => move['path'] as String)};
			expect(closure.toSet().intersection(moved), isEmpty, reason: '25 個搬移來源都不可進入公開 library：${entry.key}');
		}
	});

	test('public closure follows conditional exports and parts but ignores implementation imports and fake strings', () {
		final synthetic = lowerSynthetic({
			'lib/public.dart': """
import 'src/a/internal/implementation.dart';
export 'src/a/contract.dart' if (dart.library.io) 'src/a/alternate.dart';
// export 'src/a/internal/comment.dart';
const fake = "export 'src/a/internal/fake.dart';";
""",
			'lib/src/a/contract.dart': "export 'barrel.dart';",
			'lib/src/a/barrel.dart': "part 'internal/hidden.dart';",
			'lib/src/a/alternate.dart': '',
			'lib/src/a/internal/hidden.dart': "part of '../barrel.dart';",
			'lib/src/a/internal/implementation.dart': '',
		});
		expect(lowerExportClosure('lib/public.dart', synthetic), {'lib/public.dart', 'lib/src/a/contract.dart', 'lib/src/a/barrel.dart', 'lib/src/a/alternate.dart', 'lib/src/a/internal/hidden.dart'});
		expect(() => lowerExportClosure('lib/missing.dart', synthetic), throwsStateError);
	});

	test('catalog keeps all IDs factories variants order and exactly the 36 accepted path substitutions', () {
		final catalogs = Map<String, dynamic>.from(_baseline['catalogs'] as Map);
		expect(catalogs, hasLength(2));
		for (final entry in catalogs.entries) {
			// 完整 JSON 基線只預先套用已接受的 36 個路徑替換。
			final catalog = jsonDecode(File(entry.key).readAsStringSync());
			if (entry.key == 'lib/src/features/catalog/component-ownership.json') {
				// 原清冊只移除 index 18 的 utility；逆轉該列後仍比對完整既有 hash。
				final exports = catalog['exports'] as List;
				expect(exports, hasLength(66));
				expect(exports.where((row) => row['symbol'] == 'KlpLocalFilePicker'), isEmpty);
				exports.insert(18, {'symbol': 'KlpLocalFilePicker', 'source_path': 'lib/src/features/workspace/components/klp_local_file_picker.dart', 'kind': 'utility', 'definition_ids': []});
			}
			expect(_digest(catalog), entry.value, reason: entry.key);
		}
	});
}

List<String> _beforeHostPorts(String root, List<String> closure) {
	final previous = closure.toSet();
	// 舊 facade 仍可達時，必須多出同一 canonical 型別；不接受額外公開路徑。
	for (final name in ['klp_app_platform', 'klp_adaptive_mode']) {
		final facade = 'lib/src/foundation/platform/$name.dart';
		final canonical = 'lib/src/capabilities/environment/$name.dart';
		if (previous.contains(facade)) {
			expect(previous.remove(canonical), isTrue, reason: '$root -> $canonical');
		}
	}
	if (previous.contains('lib/src/application/structure/klp_application.dart')) {
		expect(previous.remove('lib/src/application/environment/klp_application_environment_observer.dart'), isTrue, reason: root);
	}
	if (root == 'lib/kallopis_declarative.dart') {
		expect(previous.remove('lib/src/capabilities/actions/klp_pick_file_action.dart'), isTrue);
		const old = 'lib/src/features/workspace/components/klp_local_file_picker.dart';
		expect(previous, isNot(contains(old)));
		previous.add(old);
	}
	return previous.toList()..sort();
}

List<String> _applicationViolations(Map<String, CompilationUnit> units) {
	final application = units.entries.where((entry) => entry.key.startsWith(_applicationPrefix)).toList();
	if (application.isEmpty) throw StateError('application 來源掃描不可為空');

	final violations = <String>{};
	for (final entry in application) {
		if (entry.value.directives.isEmpty && entry.value.declarations.isEmpty) throw StateError('不可用空來源規避掃描：${entry.key}');

		for (final directive in entry.value.directives) {
			for (final target in _targets(entry.key, directive, units)) {
				for (final reached in _exposedClosure(target, units)) {
					if (reached.startsWith('lib/src/') && !reached.startsWith(_applicationPrefix) && reached.split('/').skip(3).contains('internal')) {
						violations.add('${entry.key} -> $reached');
					}
				}
			}
		}
	}
	return violations.toList()..sort();
}

List<String> _targets(String path, Directive directive, Map<String, CompilationUnit> units) {
	final targets = lowerTargets(path, directive, units).toList();
	if (directive is PartOfDirective && directive.uri == null && targets.length != 1) throw StateError('具名 part of 必須有唯一來源 owner：$path');

	return targets;
}

Set<String> _exposedClosure(String entry, Map<String, CompilationUnit> units) {
	final reached = <String>{};
	void visit(String path) {
		if (!path.startsWith('lib/') || !reached.add(path)) return;

		final unit = units[path];
		if (unit == null) throw StateError('缺少被引用的來源：$path');

		// 僅追蹤暴露的 library 邊；下層入口自身的私有實作 import 不屬於 application 的邊。
		for (final directive in unit.directives) {
			if (directive is ExportDirective || directive is PartDirective || directive is PartOfDirective) {
				for (final target in _targets(path, directive, units)) {
					visit(target);
				}
			}
		}
	}
	visit(entry);
	return reached;
}

String _digest(Object? value) {
	// 固定以 JSON 語意內容計算雜湊，保留陣列順序與所有 metadata 欄位。
	return sha256.convert(utf8.encode(jsonEncode(value))).toString();
}

const _applicationPrefix = 'lib/src/application/';
const _navigationParts = [
	'klp_navigation_machine_operations.dart',
	'klp_navigation_machine_transaction.dart',
	'klp_navigation_pending.dart',
	'klp_navigation_machine_start.dart',
	'klp_navigation_start.dart',
];
final _moves = Map<String, dynamic>.from(_baseline['moves'] as Map);

// 固定於 b1b8e265 的獨立 AST 基線；測試不讀取可變產品或 PLAN 清冊作為期望值。
final _baseline = jsonDecode(r'''
{
	"moves": {
		"lib/src/kernel/lifecycle/internal/klp_frame_lease.dart": {
			"path": "lib/src/kernel/lifecycle/klp_frame_lease.dart",
			"names": [
				"KlpFrameLease"
			]
		},
		"lib/src/kernel/lifecycle/internal/klp_run_lifecycle_actions.dart": {
			"path": "lib/src/kernel/lifecycle/klp_run_lifecycle_actions.dart",
			"names": [
				"klpRunLifecycleActions"
			]
		},
		"lib/src/kernel/lifecycle/internal/klp_lifecycle_exception.dart": {
			"path": "lib/src/kernel/lifecycle/klp_lifecycle_exception.dart",
			"names": [
				"KlpLifecycleException"
			]
		},
		"lib/src/capabilities/navigation/internal/klp_navigation_machine.dart": {
			"path": "lib/src/capabilities/navigation/engine/klp_navigation_machine.dart",
			"names": [
				"KlpNavigationMachine"
			]
		},
		"lib/src/capabilities/navigation/internal/klp_navigation_commit_exception.dart": {
			"path": "lib/src/capabilities/navigation/engine/klp_navigation_commit_exception.dart",
			"names": [
				"KlpNavigationCommitException"
			]
		},
		"lib/src/capabilities/navigation/internal/klp_navigation_commit_contract_exception.dart": {
			"path": "lib/src/capabilities/navigation/engine/klp_navigation_commit_contract_exception.dart",
			"names": [
				"KlpNavigationCommitContractException"
			]
		},
		"lib/src/composition/nodes/internal/klp_scope_boundary.dart": {
			"path": "lib/src/composition/nodes/klp_scope_boundary.dart",
			"names": [
				"KlpScopeBoundary"
			]
		},
		"lib/src/rendering/flutter/internal/klp_flutter_renderer.dart": {
			"path": "lib/src/rendering/flutter/klp_flutter_renderer.dart",
			"names": [
				"KlpFlutterRenderer",
				"_KlpFlutterOverlayHost",
				"_KlpFlutterOverlayHostState"
			]
		},
		"lib/src/rendering/flutter/internal/klp_viewport_capabilities.dart": {
			"path": "lib/src/rendering/flutter/klp_viewport_capabilities.dart",
			"names": [
				"KlpViewportCapabilities"
			]
		},
		"lib/src/features/editing/internal/klp_editing_adapter.dart": {
			"path": "lib/src/features/editing/adapters/klp_editing_adapter.dart",
			"names": [
				"KlpEditingAdapter"
			]
		},
		"lib/src/features/editing/internal/klp_block_note_editing_adapter.dart": {
			"path": "lib/src/features/editing/adapters/klp_block_note_editing_adapter.dart",
			"names": [
				"KlpBlockNoteEditingAdapter",
				"_KlpPreparedBlockNoteEditing",
				"_KlpBlockNotePlacement"
			]
		},
		"lib/src/features/editing/internal/klp_canva_editing_adapter.dart": {
			"path": "lib/src/features/editing/adapters/klp_canva_editing_adapter.dart",
			"names": [
				"KlpCanvaEditingAdapter",
				"_KlpPreparedCanvaEditing",
				"_KlpCanvaPlacement"
			]
		},
		"lib/src/features/editing/internal/klp_block_controls_adapter.dart": {
			"path": "lib/src/features/editing/adapters/klp_block_controls_adapter.dart",
			"names": [
				"KlpBlockControlsAdapter",
				"_KlpPreparedBlockControls"
			]
		},
		"lib/src/features/editing/internal/klp_anchored_commands_adapter.dart": {
			"path": "lib/src/features/editing/adapters/klp_anchored_commands_adapter.dart",
			"names": [
				"KlpAnchoredCommandsAdapter",
				"_KlpPreparedAnchoredCommands"
			]
		},
		"lib/src/features/editing/internal/klp_mode_toolbar_adapter.dart": {
			"path": "lib/src/features/editing/adapters/klp_mode_toolbar_adapter.dart",
			"names": [
				"KlpModeToolbarAdapter",
				"_KlpPreparedModeToolbar"
			]
		},
		"lib/src/features/navigation/rail/internal/klp_rail_adapter.dart": {
			"path": "lib/src/features/navigation/rail/adapters/klp_rail_adapter.dart",
			"names": [
				"KlpRailAdapter"
			]
		},
		"lib/src/features/workspace/layout/internal/klp_app_layout_adapter.dart": {
			"path": "lib/src/features/workspace/layout/adapters/klp_app_layout_adapter.dart",
			"names": [
				"KlpAppLayoutAdapter",
				"_KlpAppLayoutKind",
				"_KlpPreparedAppLayout"
			]
		},
		"lib/src/features/workspace/layout/internal/klp_frame_groups_adapter.dart": {
			"path": "lib/src/features/workspace/layout/adapters/klp_frame_groups_adapter.dart",
			"names": [
				"KlpFrameGroupsAdapter",
				"_KlpPreparedFrameGroups",
				"_KlpPreparedFrameGroup"
			]
		},
		"lib/src/features/workspace/components/internal/klp_workspace_components_adapter.dart": {
			"path": "lib/src/features/workspace/components/adapters/klp_workspace_components_adapter.dart",
			"names": [
				"KlpWorkspaceComponentsAdapter",
				"_command",
				"_KlpWorkspaceSemantics",
				"_KlpWorkspaceKeys",
				"_KlpWorkspaceStyle",
				"_KlpPreparedExplorer",
				"_KlpPreparedTabs",
				"_KlpPreparedWindow",
				"_KlpPreparedWorkspaceData"
			]
		},
		"lib/src/features/workspace/components/internal/klp_workspace_block_adapter.dart": {
			"path": "lib/src/features/workspace/components/adapters/klp_workspace_block_adapter.dart",
			"names": [
				"KlpWorkspaceBlockAdapter",
				"_PreparedContent",
				"_PreparedContentBlock",
				"_Prepared"
			]
		},
		"lib/src/capabilities/navigation/internal/klp_navigation_machine_operations.dart": {
			"path": "lib/src/capabilities/navigation/engine/klp_navigation_machine_operations.dart",
			"names": [
				"_NavigationOperations"
			]
		},
		"lib/src/capabilities/navigation/internal/klp_navigation_machine_transaction.dart": {
			"path": "lib/src/capabilities/navigation/engine/klp_navigation_machine_transaction.dart",
			"names": [
				"_NavigationTransaction"
			]
		},
		"lib/src/capabilities/navigation/internal/klp_navigation_pending.dart": {
			"path": "lib/src/capabilities/navigation/engine/klp_navigation_pending.dart",
			"names": [
				"_NavigationPending"
			]
		},
		"lib/src/capabilities/navigation/internal/klp_navigation_machine_start.dart": {
			"path": "lib/src/capabilities/navigation/engine/klp_navigation_machine_start.dart",
			"names": [
				"_startNavigation",
				"_runInitialGuards",
				"_awaitInitialGuard",
				"_commitStart",
				"_rejectStart"
			]
		},
		"lib/src/capabilities/navigation/internal/klp_navigation_start.dart": {
			"path": "lib/src/capabilities/navigation/engine/klp_navigation_start.dart",
			"names": [
				"KlpNavigationStart"
			]
		}
	},
	"applicationPaths": [
		"lib/src/application/bootstrap/internal/klp_application_adapters.dart",
		"lib/src/application/bootstrap/internal/klp_application_host.dart",
		"lib/src/application/bootstrap/internal/klp_application_host_state.dart",
		"lib/src/application/bootstrap/internal/klp_application_session.dart",
		"lib/src/application/bootstrap/internal/klp_application_session_actions.dart",
		"lib/src/application/bootstrap/internal/klp_application_session_commit.dart",
		"lib/src/application/bootstrap/internal/klp_prepared_screen.dart",
		"lib/src/application/bootstrap/internal/klp_retained_screens_adapter.dart",
		"lib/src/application/bootstrap/internal/klp_screen_adapter.dart",
		"lib/src/application/bootstrap/run_klp_app.dart",
		"lib/src/application/environment/klp_application_environment.dart",
		"lib/src/application/legacy/klp_app.dart",
		"lib/src/application/legacy/klp_app_controller.dart",
		"lib/src/application/legacy/klp_app_frame.dart",
		"lib/src/application/legacy/klp_app_scope.dart",
		"lib/src/application/legacy/klp_app_state.dart",
		"lib/src/application/routing/klp_route.dart",
		"lib/src/application/routing/klp_route_input.dart",
		"lib/src/application/routing/klp_router.dart",
		"lib/src/application/structure/internal/klp_retained_screens.dart",
		"lib/src/application/structure/klp_application.dart",
		"lib/src/application/structure/klp_screen.dart"
	],
	"roots": {
		"lib/kallopis.dart": {
			"closureHash": "dcac3efe18734e1eed4cadd03f5f9737c77fe1b08d5734e7a2d1bcddf07f78bc",
			"exportsHash": "c0de5765b4102b3f2a9d086e098c44b03d5217441331d02c54571e336be0f35c"
		},
		"lib/kallopis_declarative.dart": {
			"closureHash": "ec733dff992808a34dc1019aed6f9092670dcc99f85bc3799e2e73ad8c29f6a6",
			"exportsHash": "31fc6c6238881d87eaa9ef39953adf2ab44acac0b78ffe7dde39df179865fe83"
		},
		"lib/kallopis_editing_provider.dart": {
			"closureHash": "a8ed5cf2b740128838a6fae6d1642429d928d4b89e9f1ad0ab338e617677f32b",
			"exportsHash": "622b627fa7eb599b92687c21baff24d71ed6d8a9185976ffa9083eb9b1da0e84"
		},
		"lib/kallopis_experimental.dart": {
			"closureHash": "991fd88652ccef1cc2d35c3fa7c160bc7c70a4cfa9d30a735c14110f65322366",
			"exportsHash": "10c422b78dd79dda899ca17a339d854587b96d2e657e48850fbc5e030d37d75b"
		},
		"lib/kallopis_foundation.dart": {
			"closureHash": "bd97fbd8ac08110872e00c46c1980b7b94586fc598b173d972ca7b3a32f1aa6a",
			"exportsHash": "c16f2d2f7f35465447a7242d601d68e3c18a242ab04a56db13e834472542587b"
		},
		"lib/kallopis_theme.dart": {
			"closureHash": "35e9fd68a044f2d5f2a5ca5d22226009dc581dce9865a6218f051681b016c008",
			"exportsHash": "d67a36b6d22534e3e7086d36acb6deba91552722d5d65438a4acbfece757e34c"
		}
	},
	"catalogs": {
		"lib/src/features/catalog/component-ownership.json": "4cbb9fcabe5406f42b19b45c7023f3aee7f2c21339d41e0b81310c60929201a6",
		"lib/src/application/bootstrap/internal/klp_application_catalog.json": "40864d56415f4e375905a735ca7eaac854cf2c3d6e04371348352e8d5e74f0f8"
	}
}
''') as Map<String, dynamic>;
