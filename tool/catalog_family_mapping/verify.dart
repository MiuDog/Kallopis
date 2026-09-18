import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';

import '../catalog_classification/verify.dart' as classification_contract;

const acceptedClassificationRevision = '0fcf54782b0fc0013a296bd4d505a85fd50ffd1a';
const familyCompositionLevels = {'screen', 'layout', 'container', 'element', 'internal', 'none'};
const publicFamilyLevels = {'screen', 'layout', 'container', 'element'};
const _childLevel = {
	'screen': 'layout',
	'layout': 'container',
	'container': 'element',
};
const _topLevelFields = {'schemaVersion', 'classificationRevision', 'classificationSha256', 'reviewStatus', 'acceptedAt', 'families'};
const _familyFields = {'id', 'title', 'consumerJob', 'compositionLevel', 'dataInvariants', 'eventContract', 'lifecycleContract', 'members', 'roles'};
const _roleFields = {'id', 'purpose', 'acceptedFamilyIds', 'min', 'max', 'orderMeaning'};

void main(List<String> args) {
	try {
		_validateArguments(args);
		final snapshot = loadAndVerifyFamilyMapping(
			classificationPath: _option(args, '--classification'),
			familiesPath: _option(args, '--families'),
			requireAccepted: args.contains('--require-accepted'),
		);
		stdout.writeln('Catalog capability families verified: ${snapshot.memberCount}/254 members, ${snapshot.families.length} families, reviewStatus=${snapshot.reviewStatus}.');
	}
	catch (error) {
		stderr.writeln('Catalog capability family verification failed: $error');
		exitCode = 1;
	}
}

FamilyMappingSnapshot loadAndVerifyFamilyMapping({required String classificationPath, required String familiesPath, bool requireAccepted = false}) {
	// 步驟 1：先驗證既有分類權威並綁定實際檔案雜湊。
	final classification = classification_contract.loadAndVerifyClassification(
		baselinePath: 'docs/architecture/catalog-migration/legacy-baseline.json',
		classificationPath: classificationPath,
		requireAccepted: true,
	);
	final classificationBytes = File(classificationPath).readAsBytesSync();
	final classificationSha256 = sha256.convert(classificationBytes).toString();
	final acceptedLevels = {for (final item in classification.items) item.legacyName: item.compositionLevel};
	final mapping = _readJson(familiesPath);
	_requireFields(mapping, _topLevelFields, 'family mapping');
	_require(mapping['schemaVersion'] == 1, 'schemaVersion must be 1.');
	_require(_string(mapping, 'classificationRevision', 'family mapping') == acceptedClassificationRevision, 'classificationRevision must reference the accepted classification commit.');
	_require(_string(mapping, 'classificationSha256', 'family mapping') == classificationSha256, 'classificationSha256 does not match the accepted classification file.');
	final reviewStatus = _string(mapping, 'reviewStatus', 'family mapping');
	final acceptedAt = mapping['acceptedAt'];
	_validateReviewState(reviewStatus, acceptedAt, requireAccepted);

	// 步驟 2：驗證封閉 family records、層級一致與固定 254 項 membership。
	final families = <CapabilityFamily>[];
	for (final row in _rows(mapping['families'], 'family mapping.families')) {
		families.add(_family(row, acceptedLevels));
	}
	final familyIds = families.map((family) => family.id).toList();
	_require(familyIds.isNotEmpty, 'families must not be empty.');
	_require(_sameList(familyIds, [...familyIds]..sort()), 'families must be sorted by id.');
	_require(familyIds.toSet().length == familyIds.length, 'family ids must be unique.');
	final observedMembers = families.expand((family) => family.members).toList()..sort();
	final expectedMembers = acceptedLevels.keys.toList()..sort();
	_require(_sameList(observedMembers, expectedMembers), 'Family members must exactly match all accepted classification items.');
	_require(observedMembers.toSet().length == 254, 'Every accepted item must belong to exactly one family.');

	// 步驟 3：解析 parent-owned roles 並驗證直接層級、cardinality與公開可達性。
	final familyById = {for (final family in families) family.id: family};
	final parentRoles = {for (final family in families) family.id: <FamilyParentRole>[]};
	final incoming = {for (final family in families) family.id: 0};
	final edges = <String, Set<String>>{};
	for (final family in families) {
		for (final role in family.roles) {
			final expectedLevel = _childLevel[family.compositionLevel];
			_require(expectedLevel != null, '${family.id} cannot own roles at level ${family.compositionLevel}.');
			for (final childId in role.acceptedFamilyIds) {
				final child = familyById[childId];
				_require(child != null, '${family.id}.${role.id} references unknown family $childId.');
				_require(child!.compositionLevel == expectedLevel, '${family.id}.${role.id} must target $expectedLevel, found ${child.compositionLevel}.');
				incoming[childId] = incoming[childId]! + 1;
				edges.putIfAbsent(family.id, () => <String>{}).add(childId);
				parentRoles[childId]!.add(FamilyParentRole(parentFamilyId: family.id, roleId: role.id));
			}
		}
	}
	for (final family in families) {
		if (family.compositionLevel == 'screen' || !publicFamilyLevels.contains(family.compositionLevel)) continue;
		_require(incoming[family.id]! > 0, '${family.id} must be accepted by at least one direct parent role.');
	}
	final roots = families.where((family) => family.compositionLevel == 'screen').map((family) => family.id);
	final reachable = _reachableFrom(roots, edges);
	final publicIds = families.where((family) => publicFamilyLevels.contains(family.compositionLevel)).map((family) => family.id).toSet();
	_require(reachable.containsAll(publicIds), 'Every public family must be reachable from a screen family.');

	return FamilyMappingSnapshot(
		classificationRevision: acceptedClassificationRevision,
		classificationSha256: classificationSha256,
		reviewStatus: reviewStatus,
		acceptedAt: acceptedAt as String?,
		families: List.unmodifiable(families),
		parentRoles: Map<String, List<FamilyParentRole>>.unmodifiable({for (final entry in parentRoles.entries) entry.key: List<FamilyParentRole>.unmodifiable(entry.value)}),
		reachableFamilyIds: Set.unmodifiable(reachable),
		memberCount: observedMembers.length,
	);
}

final class FamilyMappingSnapshot {

	final String classificationRevision;
	final String classificationSha256;
	final String reviewStatus;
	final String? acceptedAt;
	final List<CapabilityFamily> families;
	final Map<String, List<FamilyParentRole>> parentRoles;
	final Set<String> reachableFamilyIds;
	final int memberCount;

	const FamilyMappingSnapshot({
		required this.classificationRevision,
		required this.classificationSha256,
		required this.reviewStatus,
		required this.acceptedAt,
		required this.families,
		required this.parentRoles,
		required this.reachableFamilyIds,
		required this.memberCount,
	});
}

final class CapabilityFamily {

	final String id;
	final String title;
	final String consumerJob;
	final String compositionLevel;
	final List<String> dataInvariants;
	final String eventContract;
	final String lifecycleContract;
	final List<String> members;
	final List<CapabilityFamilyRole> roles;

	const CapabilityFamily({
		required this.id,
		required this.title,
		required this.consumerJob,
		required this.compositionLevel,
		required this.dataInvariants,
		required this.eventContract,
		required this.lifecycleContract,
		required this.members,
		required this.roles,
	});
}

final class CapabilityFamilyRole {

	final String id;
	final String purpose;
	final List<String> acceptedFamilyIds;
	final int min;
	final int? max;
	final String orderMeaning;

	const CapabilityFamilyRole({required this.id, required this.purpose, required this.acceptedFamilyIds, required this.min, required this.max, required this.orderMeaning});
}

final class FamilyParentRole {

	final String parentFamilyId;
	final String roleId;

	const FamilyParentRole({required this.parentFamilyId, required this.roleId});
}

CapabilityFamily _family(Map<String, dynamic> row, Map<String, String> acceptedLevels) {
	_requireFields(row, _familyFields, 'family');
	final id = _string(row, 'id', 'family');
	final title = _string(row, 'title', id).trim();
	final consumerJob = _string(row, 'consumerJob', id).trim();
	final compositionLevel = _string(row, 'compositionLevel', id);
	final dataInvariants = _strings(row['dataInvariants'], '$id.dataInvariants');
	final eventContract = _string(row, 'eventContract', id).trim();
	final lifecycleContract = _string(row, 'lifecycleContract', id).trim();
	final members = _strings(row['members'], '$id.members');
	final roles = <CapabilityFamilyRole>[];
	for (final role in _rows(row['roles'], '$id.roles')) {
		roles.add(_role(role, id));
	}
	_require(RegExp(r'^FAM-[A-Z0-9]+(?:-[A-Z0-9]+)+$').hasMatch(id), '$id is not a valid family id.');
	_require(title.isNotEmpty && consumerJob.isNotEmpty, '$id requires a title and consumerJob.');
	_require(familyCompositionLevels.contains(compositionLevel), '$id has unknown compositionLevel $compositionLevel.');
	_require(dataInvariants.isNotEmpty && dataInvariants.every((value) => value.trim().isNotEmpty), '$id requires explicit dataInvariants.');
	_require(eventContract.isNotEmpty && lifecycleContract.isNotEmpty, '$id requires event and lifecycle contracts.');
	_require(members.isNotEmpty, '$id must contain at least one accepted legacy member.');
	_require(_sameList(members, [...members]..sort()), '$id members must be sorted.');
	_require(members.toSet().length == members.length, '$id members must be unique.');
	for (final member in members) {
		_require(acceptedLevels.containsKey(member), '$id references unknown accepted item $member.');
		_require(acceptedLevels[member] == compositionLevel, '$id cannot cross the accepted level of $member.');
	}
	final roleIds = roles.map((role) => role.id).toList();
	_require(roleIds.toSet().length == roleIds.length, '$id role ids must be unique.');
	if (compositionLevel == 'screen') {
		_require(roles.length == 1, '$id screen must own exactly one root-layout role.');
		_require(roles.single.id == 'root-layout' && roles.single.min == 1 && roles.single.max == 1, '$id root-layout role must have cardinality 1..1.');
	}
	if (compositionLevel == 'layout') _require(roles.isNotEmpty, '$id layout must expose at least one typed container role.');
	if ({'element', 'internal', 'none'}.contains(compositionLevel)) _require(roles.isEmpty, '$id cannot own structural child roles.');
	return CapabilityFamily(
		id: id,
		title: title,
		consumerJob: consumerJob,
		compositionLevel: compositionLevel,
		dataInvariants: List.unmodifiable(dataInvariants),
		eventContract: eventContract,
		lifecycleContract: lifecycleContract,
		members: List.unmodifiable(members),
		roles: List.unmodifiable(roles),
	);
}

CapabilityFamilyRole _role(Map<String, dynamic> row, String familyId) {
	_requireFields(row, _roleFields, '$familyId role');
	final id = _string(row, 'id', '$familyId role');
	final purpose = _string(row, 'purpose', '$familyId.$id').trim();
	final acceptedFamilyIds = _strings(row['acceptedFamilyIds'], '$familyId.$id.acceptedFamilyIds');
	final min = _integer(row, 'min', '$familyId.$id');
	final maxValue = row['max'];
	final orderMeaning = _string(row, 'orderMeaning', '$familyId.$id');
	_require(RegExp(r'^[a-z][a-z0-9]*(?:-[a-z0-9]+)*$').hasMatch(id), '$familyId.$id is not a valid role id.');
	_require(purpose.isNotEmpty, '$familyId.$id requires a purpose.');
	_require(acceptedFamilyIds.isNotEmpty, '$familyId.$id must accept at least one family.');
	_require(_sameList(acceptedFamilyIds, [...acceptedFamilyIds]..sort()), '$familyId.$id family ids must be sorted.');
	_require(acceptedFamilyIds.toSet().length == acceptedFamilyIds.length, '$familyId.$id family ids must be unique.');
	_require(min >= 0, '$familyId.$id min must be non-negative.');
	_require(maxValue == null || maxValue is int, '$familyId.$id max must be an integer or null.');
	final max = maxValue as int?;
	_require(max == null || max >= min, '$familyId.$id max must be greater than or equal to min.');
	_require({'fixed', 'consumer-semantic'}.contains(orderMeaning), '$familyId.$id has unknown orderMeaning $orderMeaning.');
	return CapabilityFamilyRole(id: id, purpose: purpose, acceptedFamilyIds: List.unmodifiable(acceptedFamilyIds), min: min, max: max, orderMeaning: orderMeaning);
}

Map<String, dynamic> _readJson(String path) {
	final value = jsonDecode(File(path).readAsStringSync());
	_require(value is Map<String, dynamic>, '$path must contain a JSON object.');
	return value as Map<String, dynamic>;
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

List<Map<String, dynamic>> _rows(Object? value, String label) {
	_require(value is List<dynamic>, '$label must be a list.');
	final rows = <Map<String, dynamic>>[];
	for (final item in value! as List<dynamic>) {
		_require(item is Map<String, dynamic>, '$label entries must be objects.');
		rows.add(item as Map<String, dynamic>);
	}
	return rows;
}

List<String> _strings(Object? value, String label) {
	_require(value is List<dynamic>, '$label must be a list.');
	final strings = <String>[];
	for (final item in value! as List<dynamic>) {
		_require(item is String, '$label entries must be strings.');
		strings.add(item as String);
	}
	return strings;
}

int _integer(Map<String, dynamic> row, String field, String label) {
	final value = row[field];
	_require(value is int, '$label.$field must be an integer.');
	return value as int;
}

String _string(Map<String, dynamic> row, String field, String label) {
	final value = row[field];
	_require(value is String && value.trim().isNotEmpty, '$label.$field must be a non-empty string.');
	return value as String;
}

void _validateReviewState(String status, Object? acceptedAt, bool requireAccepted) {
	_require(status == 'proposed' || status == 'accepted', 'reviewStatus must be proposed or accepted.');
	if (status == 'proposed') {
		_require(acceptedAt == null, 'acceptedAt must be null while reviewStatus is proposed.');
		_require(!requireAccepted, 'Capability family mapping is proposed and has not received human acceptance.');
		return;
	}
	_require(acceptedAt is String && acceptedAt.trim().isNotEmpty, 'accepted mapping requires a non-empty acceptedAt.');
}

void _validateArguments(List<String> args) {
	const valuedOptions = {'--classification', '--families'};
	const flags = {'--require-accepted'};
	for (var index = 0; index < args.length; index += 1) {
		final argument = args[index];
		if (flags.contains(argument)) continue;
		_require(valuedOptions.contains(argument), 'Unknown argument: $argument');
		_require(index + 1 < args.length && !args[index + 1].startsWith('--'), 'Missing value for $argument.');
		index += 1;
	}
	for (final option in valuedOptions) {
		_require(args.contains(option), 'Missing required option $option.');
	}
}

String _option(List<String> args, String name) => args[args.indexOf(name) + 1];

void _requireFields(Map<String, dynamic> row, Set<String> fields, String label) {
	_require(row.keys.toSet().length == fields.length && row.keys.toSet().containsAll(fields), '$label has unexpected or missing fields: ${row.keys.toList()}.');
}

bool _sameList<T>(List<T> left, List<T> right) {
	if (left.length != right.length) return false;
	for (var index = 0; index < left.length; index += 1) {
		if (left[index] != right[index]) return false;
	}
	return true;
}

void _require(bool condition, String message) {
	if (!condition) throw FormatException(message);
}
