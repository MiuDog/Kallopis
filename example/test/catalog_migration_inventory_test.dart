import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import 'support/catalog_migration_gate.dart';
import 'support/catalog_migration_inventory.dart';

void main() {

	final root = Directory.current.parent;

	// 基準只讀；最初由 registry 實際執行結果一次凍結，測試沒有刷新模式。
	final baseline = _readJson(File('${root.path}/docs/architecture/catalog-migration/legacy-baseline.json'));
	final coverageFile = File('${root.path}/docs/architecture/catalog-migration/coverage.json');
	final coverage = coverageFile.existsSync() ? _readJson(coverageFile) : null;
	const requireComplete = bool.fromEnvironment('CATALOG_MIGRATION_REQUIRE_COMPLETE');

	test('固定基準保留每頁 specimen、hasDemo 與間接 covered 元件', () {
		expect(baseline['schemaVersion'], 1);
		expect((baseline['pages'] as List).length, 32, reason: '凍結起點共 32 頁');
		final names = <String>{};
		var specimens = 0;
		var demoed = 0;
		var covered = 0;
		for (final page in baseline['pages'] as List) {
			for (final specimen in page['specimens'] as List) {
				specimens++;
				if (specimen['hasDemo'] == true) demoed++;
				expect(specimen['hasDemo'], isA<bool>());
				names.add(specimen['name'] as String);
			}
			names.addAll((page['coveredComponents'] as List).cast<String>());
			covered += (page['coveredComponents'] as List).length;
		}
		expect([specimens, demoed, covered, names.length], [211, 210, 43, 254], reason: '固定起點不可自動縮減');
		final components = (baseline['components'] as List).cast<Map<String, dynamic>>();
		final recorded = components.map((item) => item['name'] as String).toList();
		expect(recorded.toSet(), names);
		expect(recorded.length, names.length, reason: '同一元件不得重複計算');
		for (final item in components) {
			expect(item['legacySources'], isNotEmpty, reason: '${item['name']} 未記錄舊來源');
		}
	});

	test('尚未遷移的元件仍在真正 registry，並保留原示範', () {
		final current = captureLegacyCatalog(root);
		final currentNames = (current['components'] as List).map((item) => item['name']).toSet();
		final completed = <dynamic>{
			for (final row in coverage?['components'] as List? ?? [])
				if (row['status'] == 'migrated' || row['status'] == 'preserved') row['name'],
		};
		final currentDemos = <dynamic>{
			for (final page in current['pages'] as List)
				for (final specimen in page['specimens'] as List)
					if (specimen['hasDemo'] == true) specimen['name'],
		};
		for (final item in baseline['components'] as List) {
			if (!completed.contains(item['name'])) expect(currentNames, contains(item['name']));
		}
		for (final page in baseline['pages'] as List) {
			for (final specimen in page['specimens'] as List) {
				if (specimen['hasDemo'] == true && !completed.contains(specimen['name'])) {
					expect(currentDemos, contains(specimen['name']), reason: '未遷移不得撤除原示範');
				}
			}
		}
	});

	test('遷移 manifest 對應與證據有效；一般通過只代表誠實記錄', () {
		expect(migrationErrors(root, baseline, coverage), isEmpty);
	});

	test('要求完成時，缺 manifest 或任何 pending 必須失敗', () {
		if (!requireComplete) return;

		expect(coverage, isNotNull, reason: '完成閘門不能省略 coverage.json');
		expect(coverage!['complete'], isTrue, reason: '遷移尚未完成；一般 inventory 通過不等於完成');
		expect(migrationErrors(root, baseline, coverage), isEmpty);
	});

	test('gate 拒絕漏列、重複、pending 假完成與移除舊宣告', () {
		final fixture = _GateFixture();
		addTearDown(fixture.dispose);
		expect(fixture.errors(), isEmpty);
		fixture.coverage['complete'] = true;
		expect(fixture.errors().join('\n'), contains('禁止宣稱 complete'));
		fixture.coverage['complete'] = false;
		fixture.rows.add(Map<String, dynamic>.from(fixture.rows.single));
		expect(fixture.errors().join('\n'), contains('重複對應'));
		fixture.rows.clear();
		expect(fixture.errors().join('\n'), contains('缺少對應'));
		fixture.rows.add({'name': 'OldThing', 'status': 'pending'});
		fixture.write('lib/old.dart', '// class OldThing {}');
		expect(fixture.errors().join('\n'), contains('不得移除舊宣告'));
	});

	test('gate 不接受只在註解或字串列名，完成者須有可達宣告與真實呼叫', () {
		final fixture = _GateFixture();
		addTearDown(fixture.dispose);
		fixture.complete();
		expect(fixture.errors(), isEmpty);
		fixture.write('lib/new.dart', '// class NewThing {}');
		expect(fixture.errors().join('\n'), contains('沒有宣告 NewThing'));
		fixture.write('lib/new.dart', 'class NewThing {}');
		fixture.write('example/demo.dart', 'const label = "NewThing()"; // NewThing()');
		expect(fixture.errors().join('\n'), contains('沒有呼叫 NewThing'));
		fixture.write('example/demo.dart', 'final demo = NewThing();');
		fixture.write('lib/kallopis_declarative.dart', '// export "new.dart";');
		expect(fixture.errors().join('\n'), contains('不可由 kallopis_declarative.dart 到達'));
	});

	test('完成者不可用不存在的 source、demo、evidence 路徑', () {
		final fixture = _GateFixture();
		addTearDown(fixture.dispose);
		fixture.complete();
		for (final field in ['source', 'demo']) {
			final original = fixture.rows.single[field];
			fixture.rows.single[field] = 'missing.dart';
			expect(fixture.errors().join('\n'), contains('檔案不存在：missing.dart'));
			fixture.rows.single[field] = original;
		}
		fixture.rows.single['evidence'] = [{'path': 'missing.md', 'description': '不存在的紀錄'}];
		expect(fixture.errors().join('\n'), contains('檔案不存在：missing.md'));
	});
}

Map<String, dynamic> _readJson(File file) {

	// 讀取固定 fixture 與主線維護的 manifest，絕不自動補全或修正。
	return jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
}

class _GateFixture {

	final Directory root;
	final baseline = <String, dynamic>{
		'components': [{'name': 'OldThing', 'legacySources': ['lib/old.dart']}],
	};
	final coverage = <String, dynamic>{
		'schemaVersion': 1,
		'complete': false,
		'components': <Map<String, dynamic>>[{'name': 'OldThing', 'status': 'pending'}],
	};

	// 暫存資料只驗證 gate 拒絕假完成，不取代產品渲染與行為測試。
	_GateFixture() : root = Directory.systemTemp.createTempSync('catalog-migration-gate-') {

		write('lib/old.dart', 'class OldThing {}');
		write('lib/kallopis_declarative.dart', 'export "new.dart";');
		write('lib/new.dart', 'class NewThing {}');
		write('example/demo.dart', 'final demo = NewThing();');
		write('evidence.md', '此為 gate 自我驗證的暫存紀錄。');
	}

	List<Map<String, dynamic>> get rows => coverage['components'] as List<Map<String, dynamic>>;

	List<String> errors() => migrationErrors(root, baseline, coverage);

	void complete() {

		coverage['complete'] = true;
		rows.single.addAll({
			'status': 'migrated',
			'newApi': 'NewThing',
			'source': 'lib/new.dart',
			'demo': 'example/demo.dart',
			'evidence': [{'path': 'evidence.md', 'description': 'gate 的成功控制組'}],
		});
	}

	void write(String path, String contents) {

		// 每個例子只操作自己的暫存 repository。
		final file = File('${root.path}/$path');
		file.parent.createSync(recursive: true);
		file.writeAsStringSync(contents);
	}

	void dispose() {

		// 刪除前驗證解析後的絕對路徑仍位於指定暫存區。
		final actual = root.resolveSymbolicLinksSync();
		final temp = Directory.systemTemp.resolveSymbolicLinksSync();
		if (!actual.startsWith('$temp${Platform.pathSeparator}catalog-migration-gate-')) {
			throw StateError('拒絕刪除暫存區以外的路徑：$actual');
		}
		root.deleteSync(recursive: true);
	}
}
