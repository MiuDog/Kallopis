import 'dart:io';

import 'verify.dart';

void main(List<String> args) {
	try {
		_validateArguments(args);
		final outputPath = _option(args, '--output');
		final snapshot = loadAndVerifyClassification(
			baselinePath: _option(args, '--baseline'),
			classificationPath: _option(args, '--classification'),
		);
		final review = _render(snapshot);

		// 所有輸入與分類均通過後才覆寫輸出，避免留下看似完整的部分審閱頁。
		File(outputPath).writeAsStringSync(review);
		stdout.writeln('Catalog classification review rendered: ${snapshot.items.length} items across ${catalogCategoryTitles.length} categories.');
	}
	catch (error) {
		stderr.writeln('Catalog classification review failed: $error');
		exitCode = 1;
	}
}

String _render(CatalogClassificationSnapshot snapshot) {
	final groups = {for (final category in catalogCategoryTitles.keys) category: <CatalogClassificationItem>[]};
	for (final item in snapshot.items) {
		groups[item.primaryCategory]!.add(item);
	}
	final roleCounts = {for (final role in catalogRoles) role: snapshot.items.where((item) => item.role == role).length};
	final buffer = StringBuffer()
		..writeln('# 固定 Catalog 分類審閱')
		..writeln()
		..writeln('> 此頁由 `classification.json` 與固定 legacy baseline 產生，請勿手動修改。分類服務 consumer 導航，不代表 module ownership、公開處置或 migration 完成。')
		..writeln()
		..writeln('- 分類狀態：`${snapshot.reviewStatus}`')
		..writeln('- 接受時間：`${snapshot.acceptedAt ?? '尚未接受'}`')
		..writeln('- 規格 revision：`${snapshot.specRevision}`')
		..writeln('- 固定項目：`${snapshot.items.length}`')
		..writeln()
		..writeln('## 分類摘要')
		..writeln()
		..writeln('| ID | 分類 | 項數 |')
		..writeln('| --- | --- | ---: |');
	for (final entry in catalogCategoryTitles.entries) {
		buffer.writeln('| `${entry.key}` | ${entry.value} | ${groups[entry.key]!.length} |');
	}
	buffer
		..writeln()
		..writeln('## Role 摘要')
		..writeln()
		..writeln('| Role | 項數 |')
		..writeln('| --- | ---: |');
	for (final role in catalogRoles.toList()..sort()) {
		buffer.writeln('| `$role` | ${roleCounts[role]} |');
	}

	for (final category in catalogCategoryTitles.entries) {
		final items = groups[category.key]!;
		buffer
			..writeln()
			..writeln('## ${category.value} (`${category.key}`) — ${items.length}')
			..writeln();
		if (items.isEmpty) {
			buffer.writeln('固定 254 項目前沒有此分類；這是完整能力地平線中的已知缺口。');
			continue;
		}

		for (final item in items) {
			final legacy = snapshot.legacyEntries[item.legacyName]!;
			final secondary = item.secondaryCategories.isEmpty ? '無' : item.secondaryCategories.map((value) => '`$value`').join('、');
			final sources = legacy.sourcePaths.map((path) => '[`$path`](../../$path)').join('、');
			buffer
				..writeln('### `${item.legacyName}`')
				..writeln()
				..writeln('- Consumer intent：${item.consumerIntent}')
				..writeln('- Role：`${item.role}`')
				..writeln('- Secondary：$secondary')
				..writeln('- 舊 Catalog：${legacy.pageTitle}（`${legacy.pageLabel}`）')
				..writeln('- 舊來源：$sources')
				..writeln();
		}
	}
	return buffer.toString();
}

void _validateArguments(List<String> args) {
	const options = {'--baseline', '--classification', '--output'};
	for (var index = 0; index < args.length; index++) {
		final argument = args[index];
		if (!options.contains(argument)) throw FormatException('Unknown argument: $argument.');
		if (index + 1 >= args.length || args[index + 1].startsWith('--')) throw FormatException('Missing value for $argument.');
		index++;
	}
}

String _option(List<String> args, String name) {
	final index = args.indexOf(name);
	if (index < 0 || index + 1 >= args.length) throw FormatException('Missing required option $name.');
	return args[index + 1];
}
