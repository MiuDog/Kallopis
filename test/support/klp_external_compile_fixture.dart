import 'dart:convert';
import 'dart:io';

import 'package:analyzer/dart/analysis/analysis_context_collection.dart';
import 'package:analyzer/dart/analysis/results.dart';

/// 在獨立套件解析公開入口，集中管理相依位置與暫存資源生命週期。
final class KlpExternalCompileFixture {
  final Directory _sandbox;
  final String _sandboxPath;
  final Map<String, String> _paths = {};
  AnalysisContextCollection? _collection;
  bool _disposed = false;

  KlpExternalCompileFixture._(this._sandbox, this._sandboxPath);

  static Future<KlpExternalCompileFixture> create(
    Map<String, String> sources,
  ) async {
    // 步驟 1：將既有相依轉成絕對 URI，並取得分析器要求的正規化 SDK 路徑。
    final original = File.fromUri(
      Directory.current.uri.resolve('.dart_tool/package_config.json'),
    );
    final config =
        jsonDecode(original.readAsStringSync()) as Map<String, dynamic>;
    final packages = (config['packages'] as List<dynamic>)
        .cast<Map<String, dynamic>>();
    for (final package in packages) {
      package['rootUri'] = original.uri
          .resolve(package['rootUri'] as String)
          .toString();
    }
    final flutter = packages.singleWhere(
      (package) => package['name'] == 'flutter',
    );
    final packageRoot = Directory.fromUri(
      Uri.parse(flutter['rootUri'] as String),
    );
    final sdkPath = Directory.fromUri(
      packageRoot.uri.resolve('../../bin/cache/dart-sdk/'),
    ).resolveSymbolicLinksSync();
    final sandbox = Directory.systemTemp.createTempSync(
      'klp-external-compile-',
    );
    final fixture = KlpExternalCompileFixture._(
      sandbox,
      sandbox.resolveSymbolicLinksSync(),
    );
    try {
      // 步驟 2：檔名由本工具生成，呼叫端案例名稱不能成為路徑。
      Directory.fromUri(sandbox.uri.resolve('.dart_tool/')).createSync();
      File.fromUri(
        sandbox.uri.resolve('.dart_tool/package_config.json'),
      ).writeAsStringSync(jsonEncode(config));
      File.fromUri(sandbox.uri.resolve('pubspec.yaml')).writeAsStringSync(
        "name: klp_external_compile_fixture\nenvironment:\n  sdk: '>=3.12.0 <4.0.0'\n",
      );
      var index = 0;
      for (final entry in sources.entries) {
        final file = File.fromUri(sandbox.uri.resolve('case_${index++}.dart'));
        file.writeAsStringSync(entry.value);
        fixture._paths[entry.key] = file.path;
      }
      fixture._collection = AnalysisContextCollection(
        includedPaths: [sandbox.path],
        sdkPath: sdkPath,
      );
      return fixture;
    } catch (_) {
      await fixture.dispose();
      rethrow;
    }
  }

  Future<ResolvedUnitResult> resolve(String name) async {
    if (_disposed) throw StateError('Compile fixture has been disposed.');

    final path = _paths[name];
    if (path == null) {
      throw ArgumentError.value(name, 'name', 'Unknown compile fixture');
    }

    final result = await _collection!
        .contextFor(path)
        .currentSession
        .getResolvedUnit(path);
    if (result is! ResolvedUnitResult) {
      throw StateError('External fixture did not resolve: $name ($result)');
    }

    return result;
  }

  Future<void> dispose() async {
    if (_disposed) return;

    _disposed = true;
    try {
      await _collection?.dispose();
    } finally {
      // 即使分析器清理失敗，也僅刪除本次建立且位置未改變的暫存資料夾。
      if (_sandbox.resolveSymbolicLinksSync() != _sandboxPath ||
          _sandbox.parent.resolveSymbolicLinksSync() !=
              Directory.systemTemp.resolveSymbolicLinksSync()) {
        throw StateError(
          'Compile fixture cleanup target changed: $_sandboxPath',
        );
      }
      _sandbox.deleteSync(recursive: true);
    }
  }
}
