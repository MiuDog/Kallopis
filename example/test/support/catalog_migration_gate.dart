import 'dart:io';

import '../../../tool/support/public_library_sources.dart';
import 'catalog_migration_inventory.dart';

/// 驗證完整性與可查核的程式證據；不證明渲染、行為、視覺或人類接受。
List<String> migrationErrors(Directory root, Map<String, dynamic> baseline, Map<String, dynamic>? coverage) {

	final errors = <String>[];
	final components = (baseline['components'] as List).cast<Map<String, dynamic>>();
	final expected = components.map((item) => item['name'] as String).toSet();
	if (coverage == null) {
		// 沒有 manifest 只能視為尚未開始；仍保護全部舊來源。
		for (final item in components) {
			_checkLegacy(root, item, errors);
		}
		return errors;
	}

	if (coverage['schemaVersion'] != 1) errors.add('coverage schemaVersion 必須為 1');
	if (coverage['complete'] is! bool) errors.add('coverage complete 必須為 boolean');
	if (coverage['components'] is! List) {
		errors.add('coverage components 必須為陣列');
		return errors;
	}

	// 每個固定基準名稱只能出現一次，不能以宣告 complete 隱藏漏列元件。
	final rows = <String, Map<String, dynamic>>{};
	for (final value in coverage['components'] as List) {
		if (value is! Map<String, dynamic> || value['name'] is! String) {
			errors.add('coverage 元件必須具有 name');
			continue;
		}
		final name = value['name'] as String;
		if (rows.containsKey(name)) errors.add('$name：重複對應');
		rows[name] = value;
	}
	for (final name in expected.difference(rows.keys.toSet())) {
		errors.add('$name：缺少對應');
	}
	for (final name in rows.keys.toSet().difference(expected)) {
		errors.add('$name：不在固定基準');
	}

	// 新 API 必須透過真正的宣告式公開入口可達。
	final publicSources = publicLibrarySources(File('${root.path}/lib/kallopis_declarative.dart')).map((file) => file.absolute.uri.normalizePath()).toSet();
	var pending = false;
	for (final item in components) {
		final name = item['name'] as String;
		final row = rows[name];
		final status = row?['status'];
		if (status != 'migrated' && status != 'preserved') {
			pending = true;
			if (status != 'pending') errors.add('$name：status 必須為 pending、migrated 或 preserved');
			_checkLegacy(root, item, errors);
			continue;
		}

		final api = row!['newApi'];
		if (api is! String || !RegExp(r'^[A-Za-z_$][A-Za-z0-9_$]*$').hasMatch(api)) {
			errors.add('$name：newApi 必須為 Dart 型別名稱');
			continue;
		}
		final source = _file(root, row['source'], errors);
		final demo = _file(root, row['demo'], errors);
		if (source != null) {
			if (!publicSources.contains(source.absolute.uri.normalizePath())) errors.add('$name：source 不可由 kallopis_declarative.dart 到達');
			if (!declaresSymbol(dartCode(source.readAsStringSync()), api)) errors.add('$name：source 沒有宣告 $api');
		}
		if (demo != null) {
			final call = RegExp('\\b${RegExp.escape(api)}(?:\\.[A-Za-z_][A-Za-z0-9_]*)?\\s*\\(');
			if (!call.hasMatch(dartCode(demo.readAsStringSync()))) errors.add('$name：demo 沒有呼叫 $api');
		}
		final evidence = row['evidence'];
		if (evidence is! List || evidence.isEmpty) {
			errors.add('$name：缺少 evidence');
			continue;
		}
		for (final record in evidence) {
			if (record is! Map || record['description'] is! String || (record['description'] as String).trim().isEmpty) {
				errors.add('$name：evidence 必須含 path 與 description');
				continue;
			}
			_file(root, record['path'], errors);
		}
	}
	if (coverage['complete'] == true && pending) errors.add('仍有 pending 或缺漏，禁止宣稱 complete');
	return errors;
}

void _checkLegacy(Directory root, Map<String, dynamic> item, List<String> errors) {

	final name = item['name'] as String;
	final sources = item['legacySources'] as List;
	if (sources.isEmpty) errors.add('$name：基準缺少 legacySources');
	for (final path in sources) {
		final file = _file(root, path, errors);
		if (file != null && !declaresSymbol(dartCode(file.readAsStringSync()), name)) {
			errors.add('$name：尚未遷移，不得移除舊宣告 $path');
		}
	}
}

File? _file(Directory root, dynamic path, List<String> errors) {

	if (path is! String || path.isEmpty || path.startsWith('/') || path.contains('\\') || path.contains(':') || path.split('/').contains('..')) {
		errors.add('必須提供 repository 相對檔案路徑：$path');
		return null;
	}

	// 存在性是證據入口的底線，不能把路徑字串本身當作已執行驗證。
	final file = File('${root.path}/$path');
	if (!file.existsSync()) {
		errors.add('檔案不存在：$path');
		return null;
	}
	return file;
}
