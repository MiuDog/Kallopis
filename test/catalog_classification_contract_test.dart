import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

const _baselinePath = 'docs/architecture/catalog-migration/legacy-baseline.json';
const _classificationPath = 'tool/catalog_classification/classification.json';
const _acceptedSpecRevision = '5e4ad9599ace8c3d1e2949964ea0db1aca88ceb3';
const _categories = {
	'CAT-ACTION',
	'CAT-APP',
	'CAT-CANVAS',
	'CAT-CHART',
	'CAT-COLLAB',
	'CAT-DATA',
	'CAT-DOC',
	'CAT-FEEDBACK',
	'CAT-FILE',
	'CAT-FORM',
	'CAT-LAYOUT',
	'CAT-NAV',
	'CAT-OVERLAY',
	'CAT-PLAN',
	'CAT-SEARCH',
	'CAT-SETTINGS',
	'CAT-SYSTEM',
	'CAT-VISUAL',
};
const _roles = {
	'catalog-artifact',
	'composition-part',
	'consumer-capability',
	'implementation-material',
	'system-contract',
};

void main() {

	test('fixed Catalog classification is complete closed and module-free', () {
		final classificationFile = File(_classificationPath);
		expect(classificationFile.existsSync(), isTrue, reason: 'CAT-TAX-01 requires $_classificationPath.');

		// 由兩個獨立檔案讀取固定名稱與分類，避免測試複製 254 項 fixture。
		final baseline = _read(_baselinePath);
		final classification = _read(_classificationPath);
		_expectFields(classification, {'schemaVersion', 'specRevision', 'reviewStatus', 'acceptedAt', 'items'});
		expect(classification['schemaVersion'], 1);
		expect(classification['specRevision'], _acceptedSpecRevision);
		_validateReviewState(classification);

		final baselineNames = _rows(baseline['components']).map((item) => _string(item, 'name')).toList()..sort();
		final items = _rows(classification['items']);
		final classificationNames = items.map((item) => _string(item, 'legacyName')).toList();
		expect(baselineNames, hasLength(254));
		expect(classificationNames, hasLength(254));
		expect(classificationNames, orderedEquals(baselineNames));
		expect(classificationNames.toSet(), hasLength(254));

		// 每筆只保存分類資料，後續 module 與 migration 處置不能提前滲入。
		for (final item in items) {
			_expectFields(item, {'legacyName', 'consumerIntent', 'primaryCategory', 'secondaryCategories', 'role'});
			final name = _string(item, 'legacyName');
			final intent = _string(item, 'consumerIntent').trim();
			final primary = _string(item, 'primaryCategory');
			final secondary = _strings(item['secondaryCategories']);
			final role = _string(item, 'role');
			expect(intent, isNotEmpty, reason: name);
			expect(intent, isNot(contains(name)), reason: '$name intent must describe consumer work, not the class.');
			expect(intent, isNot(matches(RegExp(r'\b(class|module|layer)\b|(?:^|/)lib/|(?:^|/)src/'))), reason: '$name intent must not derive classification from implementation.');
			expect(_categories, contains(primary), reason: name);
			expect(secondary, orderedEquals([...secondary]..sort()), reason: '$name secondary categories must be sorted.');
			expect(secondary.toSet(), hasLength(secondary.length), reason: '$name secondary categories must be unique.');
			expect(secondary, isNot(contains(primary)), reason: '$name primary must not be repeated as secondary.');
			expect(secondary.every(_categories.contains), isTrue, reason: name);
			expect(_roles, contains(role), reason: name);
		}
	});
}

Map<String, dynamic> _read(String path) {
	// 從 repository 檔案系統讀取真實契約，不使用會掩蓋缺漏的測試副本。
	return jsonDecode(File(path).readAsStringSync()) as Map<String, dynamic>;
}

List<Map<String, dynamic>> _rows(Object? value) => (value as List<dynamic>).cast<Map<String, dynamic>>();
List<String> _strings(Object? value) => (value as List<dynamic>).cast<String>();

String _string(Map<String, dynamic> row, String field) {
	final value = row[field];
	expect(value, isA<String>(), reason: '$field must be a string.');
	return value as String;
}

void _expectFields(Map<String, dynamic> row, Set<String> fields) {
	expect(row.keys.toSet(), fields, reason: 'Unexpected or missing fields: ${row.keys.toList()}');
}

void _validateReviewState(Map<String, dynamic> classification) {
	final status = classification['reviewStatus'];
	expect(status, anyOf('proposed', 'accepted'));
	if (status == 'proposed') {
		expect(classification['acceptedAt'], isNull);
		return;
	}

	expect(classification['acceptedAt'], isA<String>());
	expect((classification['acceptedAt'] as String).trim(), isNotEmpty);
}
