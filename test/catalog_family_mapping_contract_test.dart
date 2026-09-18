import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:flutter_test/flutter_test.dart';

const _classificationPath = 'tool/catalog_classification/classification.json';
const _familiesPath = 'tool/catalog_family_mapping/families.json';
const _acceptedClassificationRevision = '0fcf54782b0fc0013a296bd4d505a85fd50ffd1a';
const _acceptedClassificationSha256 = 'e837e0d6be2ee36dbba4a94bb4869c1989050b232d3c0fefa640435ffcb07de8';
const _compositionLevels = {'screen', 'layout', 'container', 'element', 'internal', 'none'};
const _publicLevels = {'screen', 'layout', 'container', 'element'};
const _childLevel = {
	'screen': 'layout',
	'layout': 'container',
	'container': 'element',
};

void main() {

	test('accepted Catalog classification has one closed reachable capability family graph', () {
		final classificationFile = File(_classificationPath);
		final familiesFile = File(_familiesPath);
		expect(classificationFile.existsSync(), isTrue, reason: 'Accepted classification is the family mapping input.');
		if (!familiesFile.existsSync()) fail('SCL-FAM-r1 requires $_familiesPath.');

		// 步驟 1：綁定已接受的 254 項分類，避免 family 輸入在審閱期間漂移。
		final classificationBytes = classificationFile.readAsBytesSync();
		final classification = jsonDecode(utf8.decode(classificationBytes)) as Map<String, dynamic>;
		expect(classification['reviewStatus'], 'accepted');
		expect(sha256.convert(classificationBytes).toString(), _acceptedClassificationSha256);
		final classificationRows = _rows(classification['items']);
		final classificationLevels = <String, String>{};
		for (final row in classificationRows) {
			final name = _string(row, 'legacyName');
			expect(classificationLevels.containsKey(name), isFalse, reason: 'Duplicate accepted classification item: $name.');
			classificationLevels[name] = _string(row, 'compositionLevel');
		}
		expect(classificationLevels, hasLength(254));

		// 步驟 2：驗證 family records 與固定清冊是一對一且不混入後續決策。
		final mapping = _read(_familiesPath);
		_expectFields(mapping, {'schemaVersion', 'classificationRevision', 'classificationSha256', 'reviewStatus', 'acceptedAt', 'families'});
		expect(mapping['schemaVersion'], 1);
		expect(mapping['classificationRevision'], _acceptedClassificationRevision);
		expect(mapping['classificationSha256'], _acceptedClassificationSha256);
		_validateReviewState(mapping);

		final families = _rows(mapping['families']);
		final familyIds = families.map((family) => _string(family, 'id')).toList();
		expect(familyIds, isNotEmpty);
		expect(familyIds, orderedEquals([...familyIds]..sort()));
		expect(familyIds.toSet(), hasLength(familyIds.length));

		final familyLevels = <String, String>{};
		final familyRoles = <String, List<Map<String, dynamic>>>{};
		final observedMembers = <String>[];
		for (final family in families) {
			_expectFields(family, {
				'id',
				'title',
				'consumerJob',
				'compositionLevel',
				'dataInvariants',
				'eventContract',
				'lifecycleContract',
				'members',
				'roles',
			});
			final id = _string(family, 'id');
			final level = _string(family, 'compositionLevel');
			final members = _strings(family['members']);
			final roles = _rows(family['roles']);
			expect(id, matches(RegExp(r'^FAM-[A-Z0-9]+(?:-[A-Z0-9]+)+$')));
			expect(_string(family, 'title').trim(), isNotEmpty, reason: id);
			expect(_string(family, 'consumerJob').trim(), isNotEmpty, reason: id);
			expect(_compositionLevels, contains(level), reason: id);
			expect(_strings(family['dataInvariants']).every((value) => value.trim().isNotEmpty), isTrue, reason: '$id data invariants must be explicit.');
			expect(_strings(family['dataInvariants']), isNotEmpty, reason: '$id must state its shared data contract or why none exists.');
			expect(_string(family, 'eventContract').trim(), isNotEmpty, reason: id);
			expect(_string(family, 'lifecycleContract').trim(), isNotEmpty, reason: id);
			expect(members, isNotEmpty, reason: id);
			expect(members, orderedEquals([...members]..sort()), reason: '$id members must be sorted.');
			expect(members.toSet(), hasLength(members.length), reason: '$id members must be unique.');
			for (final member in members) {
				expect(classificationLevels, contains(member), reason: '$id references an unknown legacy item.');
				expect(classificationLevels[member], level, reason: '$id cannot cross accepted composition levels.');
			}
			if (level == 'screen') _expectScreenRootRole(id, roles);
			if (level == 'layout') expect(roles, isNotEmpty, reason: '$id layout must expose at least one typed container role.');
			if ({'element', 'internal', 'none'}.contains(level)) expect(roles, isEmpty, reason: '$id cannot own structural child roles.');
			familyLevels[id] = level;
			familyRoles[id] = roles;
			observedMembers.addAll(members);
		}
		final expectedMembers = classificationLevels.keys.toList()..sort();
		expect(observedMembers..sort(), orderedEquals(expectedMembers));
		expect(observedMembers.toSet(), hasLength(254), reason: 'Every accepted legacy item must belong to exactly one family.');

		// 步驟 3：驗證 parent-owned roles 只跨下一層，並讓所有公開 family 從 screen 可達。
		final incoming = {for (final id in familyIds) id: 0};
		final edges = <String, Set<String>>{};
		for (final familyId in familyIds) {
			final parentLevel = familyLevels[familyId]!;
			final roles = familyRoles[familyId]!;
			final roleIds = <String>{};
			for (final role in roles) {
				_expectFields(role, {'id', 'purpose', 'acceptedFamilyIds', 'min', 'max', 'orderMeaning'});
				final roleId = _string(role, 'id');
				final acceptedFamilyIds = _strings(role['acceptedFamilyIds']);
				expect(roleId, matches(RegExp(r'^[a-z][a-z0-9]*(?:-[a-z0-9]+)*$')), reason: familyId);
				expect(roleIds.add(roleId), isTrue, reason: '$familyId has duplicate role $roleId.');
				expect(_string(role, 'purpose').trim(), isNotEmpty, reason: '$familyId.$roleId');
				expect(acceptedFamilyIds, isNotEmpty, reason: '$familyId.$roleId');
				expect(acceptedFamilyIds, orderedEquals([...acceptedFamilyIds]..sort()), reason: '$familyId.$roleId family IDs must be sorted.');
				expect(acceptedFamilyIds.toSet(), hasLength(acceptedFamilyIds.length), reason: '$familyId.$roleId family IDs must be unique.');
				final minimum = _integer(role, 'min');
				final maximum = role['max'];
				final orderMeaning = _string(role, 'orderMeaning');
				final expectedChildLevel = _childLevel[parentLevel];
				expect(expectedChildLevel, isNotNull, reason: '$familyId cannot own roles at level $parentLevel.');
				expect(minimum, greaterThanOrEqualTo(0), reason: '$familyId.$roleId');
				expect(maximum == null || maximum is int, isTrue, reason: '$familyId.$roleId max must be an integer or null.');
				if (maximum is int) expect(maximum, greaterThanOrEqualTo(minimum), reason: '$familyId.$roleId');
				expect({'fixed', 'consumer-semantic'}, contains(orderMeaning), reason: '$familyId.$roleId');
				for (final childId in acceptedFamilyIds) {
					expect(familyLevels, contains(childId), reason: '$familyId.$roleId has dangling family $childId.');
					expect(familyLevels[childId], expectedChildLevel, reason: '$familyId.$roleId must target the next composition level.');
					incoming[childId] = incoming[childId]! + 1;
					edges.putIfAbsent(familyId, () => <String>{}).add(childId);
				}
			}
		}

		for (final entry in familyLevels.entries) {
			if (entry.value == 'screen' || !_publicLevels.contains(entry.value)) continue;
			expect(incoming[entry.key], greaterThan(0), reason: '${entry.key} must be accepted by at least one direct parent role.');
		}
		final reachable = _reachableFrom(familyLevels.entries.where((entry) => entry.value == 'screen').map((entry) => entry.key), edges);
		final publicFamilyIds = familyLevels.entries.where((entry) => _publicLevels.contains(entry.value)).map((entry) => entry.key).toSet();
		expect(reachable.intersection(publicFamilyIds), publicFamilyIds, reason: 'Every public family must be reachable from a screen family.');
	});
}

void _expectScreenRootRole(String familyId, List<Map<String, dynamic>> roles) {

	expect(roles, hasLength(1), reason: '$familyId screen must own exactly one root layout role.');
	final root = roles.single;
	expect(root['id'], 'root-layout', reason: familyId);
	expect(root['min'], 1, reason: familyId);
	expect(root['max'], 1, reason: familyId);
}

Set<String> _reachableFrom(Iterable<String> roots, Map<String, Set<String>> edges) {
	final reachable = <String>{};
	final pending = [...roots];
	while (pending.isNotEmpty) {
		final current = pending.removeLast();
		if (!reachable.add(current)) continue;
		pending.addAll(edges[current] ?? const <String>{});
	}
	return reachable;
}

Map<String, dynamic> _read(String path) {
	// 從 repository 檔案系統讀取真實契約，不使用會掩蓋缺漏的測試副本。
	return jsonDecode(File(path).readAsStringSync()) as Map<String, dynamic>;
}

List<Map<String, dynamic>> _rows(Object? value) => (value as List<dynamic>).cast<Map<String, dynamic>>();
List<String> _strings(Object? value) => (value as List<dynamic>).cast<String>();

int _integer(Map<String, dynamic> row, String field) {
	final value = row[field];
	expect(value, isA<int>(), reason: '$field must be an integer.');
	return value as int;
}

String _string(Map<String, dynamic> row, String field) {
	final value = row[field];
	expect(value, isA<String>(), reason: '$field must be a string.');
	return value as String;
}

void _expectFields(Map<String, dynamic> row, Set<String> fields) {
	expect(row.keys.toSet(), fields, reason: 'Unexpected or missing fields: ${row.keys.toList()}');
}

void _validateReviewState(Map<String, dynamic> mapping) {
	final status = mapping['reviewStatus'];
	expect(status, anyOf('proposed', 'accepted'));
	if (status == 'proposed') {
		expect(mapping['acceptedAt'], isNull);
		return;
	}

	expect(mapping['acceptedAt'], isA<String>());
	expect((mapping['acceptedAt'] as String).trim(), isNotEmpty);
}
