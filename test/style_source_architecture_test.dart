import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import '../tool/generate_catalog_style_semantics.dart';
import 'support/public_library_graph.dart';

void main() {
	late Directory root;
	File write(String path, String source) {
		final file = File('${root.path}/$path');
		file.parent.createSync(recursive: true);
		file.writeAsStringSync(source);
		return file;
	}
	setUp(() { root = Directory.systemTemp.createTempSync('kallopis-style-source-'); });
	tearDown(() { root.deleteSync(recursive: true); });

	test('Style trace follows only explicitly called imported resolvers', () {
		write('button.dart', "import 'button_style.dart';\nimport 'unused_style.dart';\nclass KlpButton extends StatelessWidget {\nfinal style = KlpButtonStyle.resolve(klp: context.klp);\n}");
		write('button_style.dart', 'class KlpButtonStyle {\nfactory KlpButtonStyle.resolve({required KlpTheme klp}) {\nreturn klp.space.controlPaddingX;\n}\n}');
		write('unused_style.dart', 'class KlpUnusedStyle {\nfactory KlpUnusedStyle.resolve(KlpTheme klp) => klp.space.unrelated;\n}');
		final output = generateCatalogStyleSemantics(root);
		expect(output, contains('context.klp.space.controlPaddingX'));
		expect(output, isNot(contains('unrelated')));
	});

	test('Public source traversal accepts transitive exports and owned parts', () {
		final entry = write('entry.dart', "export 'src/barrel.dart';");
		write('src/barrel.dart', "export 'owner.dart';");
		write('src/owner.dart', "part 'default.dart';");
		write('src/default.dart', "part of 'owner.dart';");
		expect(publicLibraryViolations(entry, Directory('${root.path}/src')), isEmpty);
	});

	test('Public source traversal rejects hidden and orphan source files', () {
		final entry = write('entry.dart', "export 'src/owner.dart';");
		write('src/owner.dart', "import 'hidden.dart';");
		write('src/hidden.dart', 'class Hidden {}');
		write('src/orphan.dart', "part of 'owner.dart';");
		final issues = publicLibraryViolations(entry, Directory('${root.path}/src'));
		expect(issues, hasLength(2));
		expect(issues.join('\n'), contains('hidden.dart'));
		expect(issues.join('\n'), contains('orphan.dart'));
	});

	test('Public source traversal rejects direct part export and wrong owner', () {
		final entry = write('entry.dart', "export 'src/owner.dart';\nexport 'src/direct.dart';");
		write('src/owner.dart', "part 'wrong.dart';\npart 'direct.dart';");
		write('src/wrong.dart', "part of 'other.dart';");
		write('src/direct.dart', "part of 'owner.dart';");
		final issues = publicLibraryViolations(entry, Directory('${root.path}/src'));
		expect(issues.join('\n'), contains('Part owner mismatch'));
		expect(issues.join('\n'), contains('Part exported directly'));
	});
}
