import 'dart:convert';
import 'dart:io';

const catalogCategoryTitles = {
	'CAT-APP': '應用與工作區',
	'CAT-LAYOUT': '布局與組成',
	'CAT-NAV': '導覽與探索',
	'CAT-ACTION': '動作與命令',
	'CAT-DATA': '資料與集合',
	'CAT-SEARCH': '搜尋與篩選',
	'CAT-FORM': '表單與輸入',
	'CAT-FEEDBACK': '狀態與回饋',
	'CAT-OVERLAY': '浮層與暫態介面',
	'CAT-DOC': '文件、內容與編輯',
	'CAT-PLAN': '規劃與時間',
	'CAT-SETTINGS': '設定與偏好',
	'CAT-FILE': '檔案與資產',
	'CAT-COLLAB': '溝通與協作',
	'CAT-CANVAS': '畫布、圖解與手寫',
	'CAT-CHART': '圖表與資料視覺化',
	'CAT-SYSTEM': '無障礙、輸入與平台適應',
	'CAT-VISUAL': '視覺語言與體驗',
};
const catalogRoles = {
	'catalog-artifact',
	'composition-part',
	'consumer-capability',
	'implementation-material',
	'system-contract',
};
const _topLevelFields = {'schemaVersion', 'specRevision', 'reviewStatus', 'acceptedAt', 'items'};
const _itemFields = {'legacyName', 'consumerIntent', 'primaryCategory', 'secondaryCategories', 'role'};
final _implementationReference = RegExp(r'\b(class|module|layer)\b|(?:^|/)lib/|(?:^|/)src/');

void main(List<String> args) {
	try {
		_validateArguments(args, {'--baseline', '--classification', '--require-accepted'});
		final snapshot = loadAndVerifyClassification(
			baselinePath: _option(args, '--baseline'),
			classificationPath: _option(args, '--classification'),
			requireAccepted: args.contains('--require-accepted'),
		);
		stdout.writeln('Catalog classification verified: ${snapshot.items.length}/${snapshot.legacyEntries.length}, reviewStatus=${snapshot.reviewStatus}.');
	}
	catch (error) {
		stderr.writeln('Catalog classification verification failed: $error');
		exitCode = 1;
	}
}

CatalogClassificationSnapshot loadAndVerifyClassification({required String baselinePath, required String classificationPath, bool requireAccepted = false}) {
	// 步驟 1：先完整讀取兩份權威輸入，任何解析失敗都不得被視為空清冊。
	final baseline = _readJson(baselinePath);
	final classification = _readJson(classificationPath);
	final legacyEntries = _legacyEntries(baseline);

	// 步驟 2：驗證分類頂層狀態與每筆封閉資料契約。
	_requireFields(classification, _topLevelFields, 'classification');
	_require(classification['schemaVersion'] == 1, 'schemaVersion must be 1.');
	final specRevision = _string(classification, 'specRevision', 'classification');
	final reviewStatus = _string(classification, 'reviewStatus', 'classification');
	final acceptedAt = classification['acceptedAt'];
	_validateReviewState(reviewStatus, acceptedAt, requireAccepted);
	final items = <CatalogClassificationItem>[];
	for (final row in _rows(classification['items'], 'classification.items')) {
		items.add(_classificationItem(row));
	}

	// 步驟 3：以固定 baseline 做雙向集合及穩定排序比對。
	final expectedNames = legacyEntries.keys.toList()..sort();
	final observedNames = items.map((item) => item.legacyName).toList();
	_require(expectedNames.length == 254, 'Legacy baseline must contain exactly 254 unique components, found ${expectedNames.length}.');
	_require(observedNames.length == 254, 'Classification must contain exactly 254 items, found ${observedNames.length}.');
	_require(_sameList(observedNames, expectedNames), 'Classification names must exactly match the sorted legacy baseline.');

	return CatalogClassificationSnapshot(
		specRevision: specRevision,
		reviewStatus: reviewStatus,
		acceptedAt: acceptedAt as String?,
		legacyEntries: legacyEntries,
		items: List.unmodifiable(items),
	);
}

final class CatalogClassificationSnapshot {

	final String specRevision;
	final String reviewStatus;
	final String? acceptedAt;
	final Map<String, LegacyCatalogEntry> legacyEntries;
	final List<CatalogClassificationItem> items;

	const CatalogClassificationSnapshot({required this.specRevision, required this.reviewStatus, required this.acceptedAt, required this.legacyEntries, required this.items});
}

final class CatalogClassificationItem {

	final String legacyName;
	final String consumerIntent;
	final String primaryCategory;
	final List<String> secondaryCategories;
	final String role;

	const CatalogClassificationItem({required this.legacyName, required this.consumerIntent, required this.primaryCategory, required this.secondaryCategories, required this.role});
}

final class LegacyCatalogEntry {

	final String name;
	final String pageLabel;
	final String pageTitle;
	final List<String> sourcePaths;

	const LegacyCatalogEntry({required this.name, required this.pageLabel, required this.pageTitle, required this.sourcePaths});
}

CatalogClassificationItem _classificationItem(Map<String, dynamic> row) {
	_requireFields(row, _itemFields, 'classification item');
	final name = _string(row, 'legacyName', 'classification item');
	final intent = _string(row, 'consumerIntent', name).trim();
	final primary = _string(row, 'primaryCategory', name);
	final secondary = _strings(row['secondaryCategories'], '$name.secondaryCategories');
	final role = _string(row, 'role', name);
	_require(intent.isNotEmpty, '$name consumerIntent must not be empty.');
	_require(!intent.contains(name) && !_implementationReference.hasMatch(intent), '$name consumerIntent must describe consumer work without implementation references.');
	_require(catalogCategoryTitles.containsKey(primary), '$name has unknown primaryCategory $primary.');
	_require(_sameList(secondary, [...secondary]..sort()), '$name secondaryCategories must be sorted.');
	_require(secondary.toSet().length == secondary.length, '$name secondaryCategories must be unique.');
	_require(!secondary.contains(primary), '$name primaryCategory must not repeat in secondaryCategories.');
	_require(secondary.every(catalogCategoryTitles.containsKey), '$name has an unknown secondary category.');
	_require(catalogRoles.contains(role), '$name has unknown role $role.');
	return CatalogClassificationItem(
		legacyName: name,
		consumerIntent: intent,
		primaryCategory: primary,
		secondaryCategories: List.unmodifiable(secondary),
		role: role,
	);
}

Map<String, LegacyCatalogEntry> _legacyEntries(Map<String, dynamic> baseline) {
	final sources = <String, List<String>>{};
	for (final component in _rows(baseline['components'], 'baseline.components')) {
		final name = _string(component, 'name', 'baseline component');
		_require(!sources.containsKey(name), 'Duplicate baseline component: $name.');
		sources[name] = List.unmodifiable(_strings(component['legacySources'], '$name.legacySources'));
	}

	final entries = <String, LegacyCatalogEntry>{};
	for (final page in _rows(baseline['pages'], 'baseline.pages')) {
		final label = _string(page, 'label', 'baseline page');
		final title = _string(page, 'title', label);
		final names = <String>[
			for (final specimen in _rows(page['specimens'], '$label.specimens')) _string(specimen, 'name', '$label specimen'),
			..._strings(page['coveredComponents'], '$label.coveredComponents'),
		];
		for (final name in names) {
			_require(sources.containsKey(name), 'Baseline page $label references unknown component $name.');
			_require(!entries.containsKey(name), 'Baseline component $name appears on multiple pages.');
			entries[name] = LegacyCatalogEntry(name: name, pageLabel: label, pageTitle: title, sourcePaths: sources[name]!);
		}
	}
	_require(entries.keys.toSet().containsAll(sources.keys) && sources.keys.toSet().containsAll(entries.keys), 'Every baseline component must belong to exactly one legacy page.');
	return Map.unmodifiable(entries);
}

Map<String, dynamic> _readJson(String path) {
	// 從呼叫端指定的 repository 路徑讀取 UTF-8 JSON，避免隱含工作目錄替代來源。
	final value = jsonDecode(File(path).readAsStringSync());
	_require(value is Map<String, dynamic>, '$path must contain a JSON object.');
	return value as Map<String, dynamic>;
}

void _validateReviewState(String status, Object? acceptedAt, bool requireAccepted) {
	_require(status == 'proposed' || status == 'accepted', 'reviewStatus must be proposed or accepted.');
	if (status == 'proposed') {
		_require(acceptedAt == null, 'acceptedAt must be null while reviewStatus is proposed.');
		_require(!requireAccepted, 'Classification is proposed and has not received human acceptance.');
		return;
	}

	_require(acceptedAt is String && acceptedAt.trim().isNotEmpty, 'accepted classification requires a non-empty acceptedAt.');
}

void _validateArguments(List<String> args, Set<String> allowed) {
	for (var index = 0; index < args.length; index++) {
		final argument = args[index];
		_require(allowed.contains(argument), 'Unknown argument: $argument.');
		if (argument == '--require-accepted') continue;
		_require(index + 1 < args.length && !args[index + 1].startsWith('--'), 'Missing value for $argument.');
		index++;
	}
}

String _option(List<String> args, String name) {
	final index = args.indexOf(name);
	_require(index >= 0 && index + 1 < args.length, 'Missing required option $name.');
	return args[index + 1];
}

List<Map<String, dynamic>> _rows(Object? value, String label) {
	_require(value is List<dynamic>, '$label must be a list.');
	final rows = <Map<String, dynamic>>[];
	for (final item in value as List<dynamic>) {
		_require(item is Map<String, dynamic>, '$label must contain only objects.');
		rows.add(item as Map<String, dynamic>);
	}
	return rows;
}

List<String> _strings(Object? value, String label) {
	_require(value is List<dynamic>, '$label must be a list.');
	final strings = <String>[];
	for (final item in value as List<dynamic>) {
		_require(item is String && item.isNotEmpty, '$label must contain only non-empty strings.');
		strings.add(item as String);
	}
	return strings;
}

String _string(Map<String, dynamic> row, String field, String label) {
	final value = row[field];
	_require(value is String && value.isNotEmpty, '$label.$field must be a non-empty string.');
	return value as String;
}

void _requireFields(Map<String, dynamic> row, Set<String> expected, String label) {
	final observed = row.keys.toSet();
	_require(observed.length == expected.length && observed.containsAll(expected), '$label fields must be exactly ${expected.toList()..sort()}, found ${observed.toList()..sort()}.');
}

bool _sameList(List<String> left, List<String> right) => left.length == right.length && List.generate(left.length, (index) => left[index] == right[index]).every((value) => value);

void _require(bool condition, String message) {
	if (!condition) throw FormatException(message);
}
