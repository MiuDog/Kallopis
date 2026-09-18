import 'dart:io';
import 'dart:convert';

import 'package:analyzer/dart/ast/ast.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis.dart';

import 'klp_lower_module_boundary_test.dart' show lowerUnits, lowerSynthetic;
import 'klp_prepared_module_boundary_test.dart' show preparedDeclarations, preparedDartFiles;

/// 從**消費者的位置**驗證這個庫。
///
/// 其餘測試都在庫內部，看得到 `lib/src/`，因此驗證不了「一個只 import
/// `package:kallopis/kallopis.dart` 的 app 能不能用」。這組測試只透過公開 barrel，
/// 而且刻意不提供任何 Kallopis 之外的鷹架——沒有 `Scaffold`、沒有手動包 `Material`。
///
/// 這道缺口是實測出來的：庫內 33 個測試全部通過的狀態下，第一個真實消費者一放上
/// `KlpTextField` 就拋 "No Material widget found"。編譯過不等於畫得出來。
void main() {
  test('public barrel exposes typed OKLCH chroma range', () {
    const range = KlpOklchChromaRange.custom(0.2);
    expect(range.upperBound, 0.2);
  });

  Future<void> pump(
    WidgetTester tester,
    Widget child, {
    KlpVisualStyle? style,
  }) {
    tester.view.physicalSize = const Size(1280, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    return tester.pumpWidget(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: buildKlpTheme(
          Brightness.light,
          style: style ?? KlpVisualStyle.defaultStyle,
        ),
        home: Center(child: child),
      ),
    );
  }

  group('元件不要求消費者自備 Material 祖先', () {
    final specimens = <String, Widget>{
      'KlpText': const KlpText('x'),
      'KlpSurface': const KlpSurface(child: KlpText('x')),
      'KlpBadge': const KlpBadge(label: 'x'),
      'KlpListTile': const KlpListTile(title: 'x'),
      'KlpDivider': const KlpDivider(),
      'KlpIcon': const KlpIcon(KlpIcons.check),
      'KlpButton': KlpButton(label: 'x', onPressed: () {}),
      'KlpIconButton': KlpIconButton(
        icon: KlpIcons.check,
        label: 'x',
        onPressed: () {},
      ),
      'KlpCheckbox': KlpCheckbox(value: true, label: 'x', onChanged: (_) {}),
      'KlpToggle': KlpToggle(value: true, label: 'x', onChanged: (_) {}),
      'KlpSelect': KlpSelect(label: 'x', value: 'one', onPressed: () {}),
      'KlpTabs': KlpTabs(
        tabs: const ['a', 'b'],
        selected: 0,
        onSelected: (_) {},
      ),
      // KlpTextField 內部使用 TextFormField，曾經要求消費者自己包一層 Material。
      'KlpTextField': const KlpTextField(label: 'x'),
    };

    specimens.forEach((name, widget) {
      testWidgets(name, (tester) async {
        await pump(tester, widget);
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      });
    });

    testWidgets('KlpSlider', (tester) async {
      await pump(
        tester,
        SizedBox(
          width: 240,
          child: KlpSlider(label: 'x', value: 0.5, onChanged: (_) {}),
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });
  });

  group('KlpAppScreen 提供 Material 祖先', () {
    // 少了 Material 祖先，MaterialApp 會在每一段文字下方畫黃色雙底線——那是 Flutter
    // 的除錯提示，不是設計。它不會拋錯、不會被 analyze 抓到，只會出現在畫面上。
    testWidgets('底下的文字不帶除錯用的底線裝飾', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: buildKlpTheme(Brightness.light),
          home: const KlpAppScreen(child: KlpText('x')),
        ),
      );
      await tester.pumpAndSettle();

      final style = DefaultTextStyle.of(
        tester.element(find.byType(KlpText)),
      ).style;

      expect(
        style.decoration,
        anyOf(isNull, TextDecoration.none),
        reason:
            'KlpAppScreen 之下的文字帶有 ${style.decoration} 裝飾，'
            '通常代表缺少 Material 祖先。',
      );
    });

    testWidgets('KlpAppScreen 之下可直接放需要 Material 的元件', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: buildKlpTheme(Brightness.light),
          home: const KlpAppScreen(child: KlpTextField(label: 'x')),
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });
  });

  group('客製面對消費者可用', () {
    testWidgets('只覆寫色彩層，其餘沿用現成風格', (tester) async {
      const brandAccent = Color(0xFF3355FF);
      final brand = KlpVisualStyle.defaultStyle.copyWith(
        colors: KlpThemeData.light.copyWith(
          accent: brandAccent,
          interaction: brandAccent,
        ),
      );

      late KlpTheme tokens;
      await pump(
        tester,
        Builder(
          builder: (context) {
            tokens = context.klp;
            return const KlpText('x');
          },
        ),
        style: brand,
      );

      expect(tokens.color.accent, brandAccent);
      expect(
        tokens.space.base,
        KlpSpacingTheme.comfortableDensity.base,
        reason: '只覆寫色彩時，其餘各層必須原封不動',
      );
    });

    testWidgets('primitive 層對消費者可見，足以從零寫一套色盤', (tester) async {
      // KlpPalette 曾經沒有從 barrel 匯出，消費者拿不到 primitive 層。
      const custom = KlpThemeData(
        app: KlpPalette.ink950,
        surface: KlpPalette.ink900,
        surfaceInset: KlpPalette.ink800,
        surfaceMuted: KlpPalette.ink800,
        component: KlpPalette.ink950,
        stageSurface: KlpPalette.ink950,
        overlay: KlpPalette.ink800,
        surfaceRaised: KlpPalette.ink800,
        modalScrim: KlpPalette.scrim,
        guide: KlpPalette.ink500,
        divider: KlpPalette.ink700,
        text: KlpPalette.ink50,
        textMuted: KlpPalette.ink200,
        textFaint: KlpPalette.ink500,
        border: KlpPalette.line,
        borderStrong: KlpPalette.line,
        accent: KlpPalette.ink50,
        accentSoft: KlpPalette.ink900,
        interaction: KlpPalette.ink50,
        interactionSoft: KlpPalette.ink800,
        success: KlpPalette.green500,
        warning: KlpPalette.amber500,
        danger: KlpPalette.red300,
        info: KlpPalette.blue500,
      );

      late KlpTheme tokens;
      await pump(
        tester,
        Builder(
          builder: (context) {
            tokens = context.klp;
            return const KlpText('x');
          },
        ),
        style: KlpVisualStyle.defaultStyle.copyWith(colors: custom),
      );

      expect(tokens.color.app, KlpPalette.ink950);
    });
  });

	test('seven public entries validate export visibility and owned parts', () {
		expect(preparedDartFiles('lib', recursive: false).toSet(), _consumerRoots);
		final units = lowerUnits();
		final violations = _consumerPublicViolations(units, _consumerRoots, externalExists: _consumerExternalExists(), legacyPartsDigest: _legacyPartsDigest);
		expect(violations, isEmpty, reason: violations.join('\n'));
		final legacy = _consumerSymbols('lib/kallopis_legacy_file_picker.dart', units);
		expect(legacy, {'KlpLocalFilePicker'});
		expect(units['lib/kallopis_legacy_file_picker.dart']!.directives.whereType<ExportDirective>().map((directive) => directive.toSource()), ["export 'src/application/legacy/klp_local_file_picker.dart' show KlpLocalFilePicker;"]);
		expect(_consumerSymbols('lib/kallopis_declarative.dart', units), contains('KlpPickFileAction'));
		expect(_consumerSymbols('lib/kallopis_declarative.dart', units), isNot(contains('KlpLocalFilePicker')));
	});

	test('five preserved roots retain exact baseline internal part public identities', () {
		final roots = _consumerRoots.where((root) => root != 'lib/kallopis_declarative.dart' && root != 'lib/kallopis_legacy_file_picker.dart');
		final violations = _consumerPublicViolations(lowerUnits(), roots, externalExists: _consumerExternalExists(), legacyPartsDigest: _legacyPartsDigest);
		expect(violations, isEmpty, reason: violations.join('\n'));
	});

	test('public graph external package resolver recognizes existing sibling packages', () {
		final exists = _consumerExternalExists();
		expect(exists('package:krepis_canva/krepis_canva.dart'), isTrue);
		expect(exists('package:krepis_block_note/krepis_block_note.dart'), isTrue);
		expect(exists('package:krepis_canva/nonexistent-host-ports.dart'), isFalse);
	});

	test('public graph legacy part baseline allows only the original owner and public symbol set', () {
		const root = 'lib/public.dart';
		const owner = 'lib/src/a/api.dart';
		const part = 'lib/src/a/internal/body.dart';
		final baseline = _consumerDigest([{'owner': owner, 'part': part, 'names': ['Legacy']}]);
		final accepted = {root: "export 'src/a/api.dart';", owner: "part 'internal/body.dart';", part: "part of '../api.dart'; class Legacy {} class _Private {}"};
		expect(_consumerPublicViolations(lowerSynthetic(accepted), [root], legacyPartsDigest: baseline), isEmpty);
		for (final source in ['class Renamed {}', 'class Legacy {} class Added {}', 'class _Removed {}']) {
			final changed = {...accepted, part: "part of '../api.dart'; $source"};
			expect(_consumerPublicViolations(lowerSynthetic(changed), [root], legacyPartsDigest: baseline), contains(startsWith('Legacy part identity drift:')));
		}
		final movedOwner = {root: "export 'src/a/new_owner.dart';", 'lib/src/a/new_owner.dart': "part 'internal/body.dart';", part: "part of '../new_owner.dart'; class Legacy {}"};
		expect(_consumerPublicViolations(lowerSynthetic(movedOwner), [root], legacyPartsDigest: baseline), contains(startsWith('Legacy part identity drift:')));
	});

	test('public graph probes resolve package URIs restrictions and private owned parts', () {
		final units = lowerSynthetic({
			'lib/public.dart': "export 'package:kallopis/src/application/api.dart' show Visible, Hidden; export 'src/application/api.dart' hide Hidden; export 'package:foreign/api.dart' show External;",
			'lib/src/application/api.dart': "library owned; part 'internal/body.dart'; class Visible {} class Hidden {} class Other {}",
			'lib/src/application/internal/body.dart': 'part of owned; class _Implementation {}',
			'lib/src/application/unexported.dart': 'class Unexported {}',
		});
		expect(_consumerPublicViolations(units, ['lib/public.dart'], externalExists: (uri) => uri == 'package:foreign/api.dart'), isEmpty);
		expect(_consumerSymbols('lib/public.dart', units), {'Visible', 'Hidden', 'Other'});
		final restricted = lowerSynthetic({
			'lib/public.dart': "export 'src/application/api.dart' show Visible, Hidden hide Hidden;",
			'lib/src/application/api.dart': 'class Visible {} class Hidden {}',
		});
		expect(_consumerSymbols('lib/public.dart', restricted), {'Visible'});
	});

	for (final probe in <({String name, Map<String, String> sources, String violation})>[
		(name: 'missing export', sources: {'lib/public.dart': "export 'missing.dart';"}, violation: 'Missing export:'),
		(name: 'conditional missing export', sources: {'lib/public.dart': "export 'valid.dart' if (dart.library.io) 'missing.dart';", 'lib/valid.dart': ''}, violation: 'Missing export:'),
		(name: 'missing package export', sources: {'lib/public.dart': "export 'package:unknown/missing.dart';"}, violation: 'Missing external export:'),
		(name: 'missing part', sources: {'lib/public.dart': "export 'src/a/api.dart';", 'lib/src/a/api.dart': "part 'missing.dart';"}, violation: 'Missing part:'),
		(name: 'wrong part owner', sources: {'lib/public.dart': "export 'src/a/api.dart';", 'lib/src/a/api.dart': "part 'body.dart';", 'lib/src/a/body.dart': "part of 'other.dart';"}, violation: 'Part owner mismatch:'),
		(name: 'cross module part', sources: {'lib/public.dart': "export 'src/a/api.dart';", 'lib/src/a/api.dart': "part '../b/body.dart';", 'lib/src/b/body.dart': "part of '../a/api.dart';"}, violation: 'Cross module part:'),
		(name: 'internal export', sources: {'lib/public.dart': "export 'src/a/internal/leak.dart' show Safe;", 'lib/src/a/internal/leak.dart': 'class Safe {}'}, violation: 'Private export:'),
		(name: 'internal part public declaration', sources: {'lib/public.dart': "export 'src/a/api.dart';", 'lib/src/a/api.dart': "part 'internal/body.dart';", 'lib/src/a/internal/body.dart': "part of '../api.dart'; class Leaked {}"}, violation: 'Public declaration in internal part:'),
		(name: 'host port export', sources: {'lib/public.dart': "export 'src/capabilities/files/klp_file_selection.dart';", 'lib/src/capabilities/files/klp_file_selection.dart': 'class KlpFileSelectionPort {}'}, violation: 'Private export:'),
		(name: 'direct part export', sources: {'lib/public.dart': "export 'src/a/body.dart';", 'lib/src/a/body.dart': "part of 'api.dart';"}, violation: 'Part exported directly:'),
		(name: 'URI escapes package', sources: {'lib/public.dart': "export '../outside.dart';", 'outside.dart': ''}, violation: 'Invalid export URI:'),
	]) {
		test('public graph rejects ${probe.name}', () {
			final violations = _consumerPublicViolations(lowerSynthetic(probe.sources), ['lib/public.dart']);
			expect(violations.any((value) => value.startsWith(probe.violation)), isTrue, reason: violations.join('\n'));
		});
	}
}

const _consumerRoots = {
	'lib/kallopis.dart',
	'lib/kallopis_declarative.dart',
	'lib/kallopis_editing_provider.dart',
	'lib/kallopis_experimental.dart',
	'lib/kallopis_foundation.dart',
	'lib/kallopis_theme.dart',
	'lib/kallopis_legacy_file_picker.dart',
};

const _consumerPrivateSources = {
	'lib/src/capabilities/environment/klp_environment_snapshot.dart',
	'lib/src/capabilities/files/klp_file_selection.dart',
	'lib/src/application/environment/klp_file_selection_adapter.dart',
	'lib/src/features/workspace/components/klp_local_file_picker.dart',
};

// 精確凍結 f783f028 原五個保留根可達 internal parts 的 owner、part 路徑與公開宣告名稱集合。
const _legacyPartsDigest = '74fb2fdb77a0019b3e8d0c733b071510215bd55b26a0cd80ad8a26c59760c2bc';

String _consumerDigest(Object value) => sha256.convert(utf8.encode(jsonEncode(value))).toString();

String _consumerTarget(String owner, String uri) {
	if (uri.startsWith('package:kallopis/')) return Uri.parse('lib/${uri.substring('package:kallopis/'.length)}').normalizePath().path;
	if (Uri.parse(uri).hasScheme) return uri;

	return Uri.parse(owner).resolve(uri).normalizePath().path;
}

List<String> _consumerPublicViolations(Map<String, CompilationUnit> units, Iterable<String> roots, {bool Function(String)? externalExists, String? legacyPartsDigest}) {
	final issues = <String>[];
	final reached = <String>{};
	final owners = <String, String>{};
	final legacyParts = <Map<String, Object>>[];
	void visit(String path) {
		if (!path.startsWith('lib/')) {
			if (path.startsWith('package:')) {
				if (!(externalExists?.call(path) ?? false)) issues.add('Missing external export: $path');
			}
			else {
				issues.add('Invalid export URI: $path');
			}
			return;
		}
		if (path.split('/').contains('internal') || _consumerPrivateSources.contains(path)) issues.add('Private export: $path');
		final unit = units[path];
		if (unit == null) {
			issues.add('Missing export: $path');
			return;
		}
		if (unit.directives.any((directive) => directive is PartOfDirective)) issues.add('Part exported directly: $path');
		if (!reached.add(path)) return;

		for (final directive in unit.directives) {
			if (directive is ExportDirective) {
				for (final uri in [directive.uri, ...directive.configurations.map((configuration) => configuration.uri)]) {
					visit(_consumerTarget(path, uri.stringValue!));
				}
			}
			if (directive is! PartDirective) continue;

			final target = _consumerTarget(path, directive.uri.stringValue!);
			final part = units[target];
			if (part == null) {
				issues.add('Missing part: $target');
				continue;
			}
			if (owners.containsKey(target)) issues.add('Multiple part owners: $target');
			owners[target] = path;
			if (path.split('/').take(3).join('/') != target.split('/').take(3).join('/')) issues.add('Cross module part: $path -> $target');
			final reverse = part.directives.whereType<PartOfDirective>().toList();
			final named = unit.directives.whereType<LibraryDirective>().map((value) => value.name?.toSource()).whereType<String>().toList();
			final valid = reverse.length == 1 && (reverse.single.uri != null ? _consumerTarget(target, reverse.single.uri!.stringValue!) == path : named.length == 1 && reverse.single.libraryName?.toSource() == named.single);
			if (!valid) issues.add('Part owner mismatch: $target');
			if (part.directives.any((value) => value is PartDirective || value is ExportDirective || value is ImportDirective || value is LibraryDirective)) issues.add('Invalid owned part directives: $target');
			final publicNames = preparedDeclarations(part).where((name) => !name.startsWith('_')).toList()..sort();
			if (target.split('/').contains('internal') && publicNames.isNotEmpty) {
				if (legacyPartsDigest == null) issues.add('Public declaration in internal part: $target');
				legacyParts.add({'owner': path, 'part': target, 'names': publicNames});
			}
			if (_consumerPrivateSources.contains(target)) issues.add('Private part exposed: $target');
		}
	}
	for (final root in roots) {
		visit(root);
		final symbols = _consumerSymbols(root, units);
		const privateNames = {'KlpEnvironmentSnapshot', 'KlpFileSelectionPort', 'KlpFileSelectionRequest', 'KlpFileSelectionResult', 'KlpFileSelected', 'KlpFileSelectionCancelled', 'KlpFileSelectionFailed', 'KlpFileSelectionAdapter'};
		for (final symbol in symbols.intersection(privateNames)) {
			issues.add('Private symbol exported: $root -> $symbol');
		}
	}
	legacyParts.sort((left, right) => (left['part'] as String).compareTo(right['part'] as String));
	if (legacyPartsDigest != null && _consumerDigest(legacyParts) != legacyPartsDigest) issues.add('Legacy part identity drift: ${legacyParts.length} parts ${_consumerDigest(legacyParts)}');
	return issues;
}

Set<String> _consumerSymbols(String path, Map<String, CompilationUnit> units, [Set<String> visited = const {}]) {
	if (visited.contains(path) || !units.containsKey(path)) return {};

	final unit = units[path]!;
	final result = preparedDeclarations(unit).where((name) => !name.startsWith('_')).toSet();
	final active = {...visited, path};
	for (final directive in unit.directives) {
		if (directive is PartDirective) result.addAll(_consumerSymbols(_consumerTarget(path, directive.uri.stringValue!), units, active));
		if (directive is! ExportDirective) continue;

		for (final uri in [directive.uri, ...directive.configurations.map((configuration) => configuration.uri)]) {
			final names = _consumerSymbols(_consumerTarget(path, uri.stringValue!), units, active);
			for (final combinator in directive.combinators) {
				if (combinator is ShowCombinator) names.retainAll(combinator.shownNames.map((name) => name.name));
				if (combinator is HideCombinator) names.removeAll(combinator.hiddenNames.map((name) => name.name));
			}
			result.addAll(names);
		}
	}
	return result;
}

bool Function(String) _consumerExternalExists() {
	// 以既有 package config 驗證外部 export 的來源存在，不把外部套件歸為本庫私有路徑。
	final configFile = File('.dart_tool/package_config.json').absolute;
	final packages = (jsonDecode(configFile.readAsStringSync()) as Map)['packages'] as List;
	final roots = <String, Uri>{};
	for (final package in packages.cast<Map>()) {
		final directory = Directory.fromUri(configFile.uri.resolve(package['rootUri'] as String)).uri;
		roots[package['name'] as String] = directory.resolve((package['packageUri'] as String?) ?? 'lib/');
	}
	return (value) {
		final uri = Uri.parse(value);
		final segments = uri.pathSegments;
		if (uri.scheme != 'package' || segments.length < 2 || segments.contains('..') || uri.hasQuery || uri.hasFragment) return false;

		final root = roots[segments.first];
		return root != null && File.fromUri(root.resolve(segments.skip(1).join('/'))).existsSync();
	};
}
