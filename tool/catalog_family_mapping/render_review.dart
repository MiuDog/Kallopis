import 'dart:io';

import 'verify.dart';

void main(List<String> args) {
	try {
		_validateArguments(args);
		final snapshot = loadAndVerifyFamilyMapping(
			classificationPath: _option(args, '--classification'),
			familiesPath: _option(args, '--families'),
		);
		final outputPath = _option(args, '--output');
		final review = _render(snapshot);

		// 所有輸入與結構圖通過後才覆寫審閱頁，避免留下部分成功產物。
		File(outputPath).writeAsStringSync(review);
		stdout.writeln('Catalog capability family review rendered: ${snapshot.families.length} families, ${snapshot.memberCount} members.');
	}
	catch (error) {
		stderr.writeln('Catalog capability family review failed: $error');
		exitCode = 1;
	}
}

String _render(FamilyMappingSnapshot snapshot) {
	final familyById = {for (final family in snapshot.families) family.id: family};
	final levelCounts = {for (final level in familyCompositionLevels) level: snapshot.families.where((family) => family.compositionLevel == level).length};
	final edgeCount = snapshot.families.fold<int>(0, (sum, family) => sum + family.roles.fold<int>(0, (roleSum, role) => roleSum + role.acceptedFamilyIds.length));
	final publicCount = snapshot.families.where((family) => publicFamilyLevels.contains(family.compositionLevel)).length;
	final reachablePublicCount = snapshot.families.where((family) => publicFamilyLevels.contains(family.compositionLevel) && snapshot.reachableFamilyIds.contains(family.id)).length;
	final buffer = StringBuffer()
		..writeln('# Catalog capability family 審閱')
		..writeln()
		..writeln('> 此頁由已接受的固定分類與 `families.json` 產生，請勿手動修改。Family 接受不代表公開處置、module ownership 或 migration 完成。')
		..writeln()
		..writeln('- Family 狀態：`${snapshot.reviewStatus}`')
		..writeln('- 接受時間：`${snapshot.acceptedAt ?? '尚未接受'}`')
		..writeln('- Classification revision：`${snapshot.classificationRevision}`')
		..writeln('- Classification SHA-256：`${snapshot.classificationSha256}`')
		..writeln('- 固定 legacy members：`${snapshot.memberCount}`')
		..writeln('- Capability families：`${snapshot.families.length}`')
		..writeln()
		..writeln('## 結構摘要')
		..writeln()
		..writeln('| Composition level | Family 數 |')
		..writeln('| --- | ---: |');
	for (final level in familyCompositionLevels.toList()..sort()) {
		buffer.writeln('| `$level` | ${levelCounts[level]} |');
	}
	buffer
		..writeln()
		..writeln('- 公開 family 可達性：`$reachablePublicCount/$publicCount`')
		..writeln('- Parent-owned role edges：`$edgeCount`')
		..writeln('- 唯一合法結構順序：`screen → layout → container → element`');

	for (final level in const ['screen', 'layout', 'container', 'element', 'internal', 'none']) {
		final families = snapshot.families.where((family) => family.compositionLevel == level).toList();
		buffer
			..writeln()
			..writeln('## `$level` families — ${families.length}');
		for (final family in families) {
			buffer
				..writeln()
				..writeln('### ${family.title} (`${family.id}`)')
				..writeln()
				..writeln('- Consumer job：${family.consumerJob}')
				..writeln('- Event contract：${family.eventContract}')
				..writeln('- Lifecycle contract：${family.lifecycleContract}')
				..writeln('- Legacy members（${family.members.length}）：${family.members.map((member) => '`$member`').join('、')}')
				..writeln('- Data invariants：');
			for (final invariant in family.dataInvariants) {
				buffer.writeln('  - $invariant');
			}
			buffer.writeln('- Accepted by：');
			final parents = snapshot.parentRoles[family.id]!;
			if (family.compositionLevel == 'screen') {
				buffer.writeln('  - `application/router → screen` 固定根入口');
			}
			else if (parents.isEmpty) {
				buffer.writeln('  - 不參與 public composition graph。');
			}
			else {
				for (final parent in parents) {
					final parentTitle = familyById[parent.parentFamilyId]!.title;
					buffer.writeln('  - `$parentTitle` (`${parent.parentFamilyId}`).`${parent.roleId}`');
				}
			}
			buffer.writeln('- Child roles：');
			if (family.roles.isEmpty) {
				buffer.writeln('  - 無。');
			}
			else {
				for (final role in family.roles) {
					final maximum = role.max?.toString() ?? 'unbounded';
					buffer
						..writeln('  - `${role.id}`（`${role.min}..$maximum`；`${role.orderMeaning}`）：${role.purpose}')
						..writeln('    - 接受：${role.acceptedFamilyIds.map((id) => '`$id`').join('、')}');
				}
			}
		}
	}
	return buffer.toString();
}

void _validateArguments(List<String> args) {
	const options = {'--classification', '--families', '--output'};
	for (var index = 0; index < args.length; index += 2) {
		final argument = args[index];
		if (!options.contains(argument)) throw FormatException('Unknown argument: $argument');
		if (index + 1 >= args.length || args[index + 1].startsWith('--')) throw FormatException('Missing value for $argument.');
	}
	for (final option in options) {
		if (!args.contains(option)) throw FormatException('Missing required option $option.');
	}
}

String _option(List<String> args, String name) => args[args.indexOf(name) + 1];
