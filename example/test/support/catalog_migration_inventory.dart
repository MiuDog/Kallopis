import 'dart:io';

import 'package:kallopis_catalog/catalog/registry.dart';

import '../../../tool/support/public_library_sources.dart';

/// 以實際 registry 與公開 library 圖取得基準；不解析 generated 檔內的字串猜清單。
Map<String, dynamic> captureLegacyCatalog(Directory root) {

	final pages = [
		for (final page in catalogPages)
			{
				'label': page.label,
				'title': page.title,
				'hasTokenView': page.tokenView != null,
				'specimens': [
					for (final specimen in page.specimens)
						{'name': specimen.name, 'hasDemo': specimen.hasDemo},
				],
				'coveredComponents': page.coveredComponents,
			},
	];
	final names = catalogedComponents.toList()..sort();
	final sources = <String, List<String>>{for (final name in names) name: []};

	// 公開 export 與 part 共同決定舊元件的來源，包含間接 covered 元件。
	final publicFiles = {
		...publicLibrarySources(File('${root.path}/lib/kallopis.dart')),
		...publicLibrarySources(File('${root.path}/lib/kallopis_declarative.dart')),
	};
	for (final file in publicFiles) {
		final code = dartCode(file.readAsStringSync());
		for (final name in names) {
			if (declaresSymbol(code, name)) {
				final relative = root.uri.relativize(file.absolute.uri).path;
				if (!sources[name]!.contains(relative)) sources[name]!.add(relative);
			}
		}
	}

	return {
		'schemaVersion': 1,
		'baseCommit': '2d761c29a7529ecf755cd9c9a058b0640051c3f1',
		'pages': pages,
		'components': [for (final name in names) {'name': name, 'legacySources': sources[name]}],
	};
}

/// 去除註解及字串，避免文件、import 或字串假裝成宣告與示範。
String dartCode(String source) {

	final trivia = RegExp(r'''r?"""[\s\S]*?"""|r?''' "'''[\\s\\S]*?'''" r'''|r?"(?:\\.|[^"\\])*"|r?'(?:\\.|[^'\\])*'|//[^\r\n]*|/\*[\s\S]*?\*/''');
	return source.replaceAllMapped(trivia, (match) => ' ' * match.group(0)!.length);
}

bool declaresSymbol(String code, String name) {

	return RegExp('\\b(?:class|enum|mixin|typedef|extension\\s+type)\\s+${RegExp.escape(name)}\\b').hasMatch(code);
}

extension on Uri {

	Uri relativize(Uri child) {

		final base = normalizePath().toString();
		final target = child.normalizePath().toString();
		if (!target.startsWith(base)) throw StateError('來源超出 repository：$target');

		return Uri.parse(target.substring(base.length));
	}
}
