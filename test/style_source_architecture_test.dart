import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import '../tool/generate_catalog_style_semantics.dart';
import '../tool/support/owned_library_sources.dart';
import '../tool/support/public_library_sources.dart';
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

	test('Style trace discovers public widgets and private styles in owned parts', () {
		final entry = write('entry.dart', "export 'toggle.dart';");
		write('toggle.dart', "part 'toggle_widget.dart';\npart 'toggle_style.dart';");
		write(
			'toggle_widget.dart',
			"part of 'toggle.dart';\nclass KlpToggle extends StatelessWidget {\nfinal style = _KlpToggleStyle.resolve(context.klp);\n}",
		);
		write(
			'toggle_style.dart',
			"part of 'toggle.dart';\nclass _KlpToggleStyle {\nfactory _KlpToggleStyle.resolve(KlpTheme klp) {\nreturn klp.space.controlGap;\n}\n}",
		);
		final output = generateCatalogStyleSemantics(root, publicEntry: entry);
		expect(output, contains("'KlpToggle': CatalogStyleSemantics("));
		expect(output, contains('context.klp.space.controlGap'));
	});

	test('Public library source discovery excludes imports and includes owned parts', () {
		final entry = write('entry.dart', "export 'owner.dart';");
		write('owner.dart', "import 'hidden.dart';\npart 'widget.dart';");
		write('widget.dart', "part of 'owner.dart';");
		write('hidden.dart', 'class Hidden {}');
		final paths = publicLibrarySources(entry).map((file) => file.path.replaceAll(r'\', '/')).toList();
		expect(paths.where((path) => path.endsWith('/entry.dart')), hasLength(1));
		expect(paths.where((path) => path.endsWith('/owner.dart')), hasLength(1));
		expect(paths.where((path) => path.endsWith('/widget.dart')), hasLength(1));
		expect(paths.where((path) => path.endsWith('/hidden.dart')), isEmpty);
	});

	test('Owned library source discovery resolves an internal part back to its owner', () {
		final owner = write('owner.dart', "part 'internal/widget.dart';\npart 'internal/state.dart';");
		final widget = write('internal/widget.dart', "part of '../owner.dart';");
		write('internal/state.dart', "part of '../owner.dart';");
		final paths = ownedLibrarySources(widget).map((file) => file.absolute.uri.normalizePath()).toSet();
		expect(paths, hasLength(3));
		expect(paths, contains(owner.absolute.uri.normalizePath()));
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

	test('Isolated public entries jointly cover sources and owned parts', () {
		final legacy = write('legacy.dart', "export 'src/legacy.dart';");
		final next = write('next.dart', "export 'src/next.dart';");
		write('src/legacy.dart', 'class Legacy {}');
		write('src/next.dart', "part 'next_part.dart';");
		write('src/next_part.dart', "part of 'next.dart';");
		expect(publicLibraryViolations(legacy, Directory('${root.path}/src'), isolatedEntries: [next]), isEmpty);
		write('src/unexported.dart', 'class Unexported {}');
		final issues = publicLibraryViolations(legacy, Directory('${root.path}/src'), isolatedEntries: [next]);
		expect(issues.single, contains('Not exported:'));
		expect(issues.single, contains('unexported.dart'));
	});

	test('Isolated public entries reject shared sources and cross exports', () {
		final legacy = write('legacy.dart', "export 'src/legacy.dart';");
		final next = write('next.dart', "export 'src/next.dart';\nexport 'legacy.dart';");
		write('src/legacy.dart', 'class Legacy {}');
		write('src/next.dart', 'class Next {}');
		final issues = publicLibraryViolations(legacy, Directory('${root.path}/src'), isolatedEntries: [next]);
		expect(issues, hasLength(2));
		expect(issues.every((issue) => issue.startsWith('Shared source across isolated entries:')), isTrue);
	});

	for (final directive in ["export 'src/legacy.dart' show Legacy;", "export 'src/legacy.dart' hide Legacy;", "export\n'src/legacy.dart'\nshow Legacy;", "export 'src/next.dart' if (dart.library.io) 'src/legacy.dart';"]) {
		test('AST catches cross entry export $directive', () {
			final legacy = write('legacy.dart', "export 'src/legacy.dart';");
			final next = write('next.dart', "export 'src/next.dart';\n$directive");
			write('src/legacy.dart', 'class Legacy {}');
			write('src/next.dart', 'class Next {}');
			final issues = publicLibraryViolations(legacy, Directory('${root.path}/src'), isolatedEntries: [next]);
			expect(issues.any((issue) => issue.startsWith('Shared source across isolated entries:')), isTrue);
		});
	}

	for (final uri in ['package:kallopis/src/legacy.dart', 'package:foreign/legacy.dart']) {
		test('Package export URI is rejected explicitly $uri', () {
			final entry = write('entry.dart', "export 'src/legacy.dart';\nexport '$uri';");
			write('src/legacy.dart', 'class Legacy {}');
			final issues = publicLibraryViolations(entry, Directory('${root.path}/src'));
			expect(issues.single, startsWith('Unsupported directive URI: $uri'));
		});
	}

	test('AST resolves named and multiline part owners', () {
		final entry = write('entry.dart', "export\n'src/owner.dart';");
		write('src/owner.dart', "library example.owner;\npart\n'named.dart';\npart 'uri.dart';");
		write('src/named.dart', 'part of\nexample.owner;');
		write('src/uri.dart', "part of\n'owner.dart';");
		expect(publicLibraryViolations(entry, Directory('${root.path}/src')), isEmpty);
		write('src/named.dart', 'part of example.wrong;');
		expect(publicLibraryViolations(entry, Directory('${root.path}/src')).join('\n'), contains('Part owner mismatch'));
	});
}
