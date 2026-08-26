import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const assetDirectory = 'assets/icons/ui_oval';
  const provenancePath = 'spec/release/kallopis-0.8.0-asset-provenance.md';
  const localAssets = <String>{
    'grip-vertical-svgrepo-com.svg',
    'maximize-02-svgrepo-com.svg',
    'menu-hamburger-svgrepo-com.svg',
  };

  test('49 份外部圖示皆有固定上游與 SHA-256', () {
    final provenance = _readProvenance(provenancePath);
    final rows = _parseLucideRows(provenance);

    expect(rows, hasLength(49));
    expect(
      rows.map((row) => row.asset).toSet(),
      hasLength(49),
      reason: '每個 Kallopis 圖示只能有一筆上游對照',
    );
    expect(
      rows.every((row) => row.upstreamPath.endsWith('.svg')),
      isTrue,
      reason: '每筆來源都必須指向上游 SVG',
    );
    expect(
      _findHashMismatches(rows, (path) => File(path).readAsBytesSync()),
      isEmpty,
      reason: '本機 SVG 內容與 provenance 記錄的 SHA-256 不同',
    );
    expect(provenance, contains('4aec3f892fd6c23063bc2fead83c899b5d412b1c'));
  });

  test('竄改任一 SVG 時 SHA-256 gate 會失敗', () {
    final rows = _parseLucideRows(_readProvenance(provenancePath));
    final tamperedAsset = rows.first.asset;
    final mismatches = _findHashMismatches(rows, (path) {
      // 以記憶體 fixture 模擬檔案尾端被加入一個位元組，不污染真正資產。
      final bytes = File(path).readAsBytesSync();
      return path == '$assetDirectory/$tamperedAsset'
          ? <int>[...bytes, 0]
          : bytes;
    });

    expect(mismatches, <String>[tamperedAsset]);
  });

  test('來源清單完整涵蓋所有 SVG', () {
    final externalAssets = _parseLucideRows(
      _readProvenance(provenancePath),
    ).map((row) => row.asset).toSet();
    // 掃描實際資產目錄，確保新增 SVG 不會繞過來源清單。
    final actualAssets = Directory(assetDirectory)
        .listSync()
        .whereType<File>()
        .map((file) => file.uri.pathSegments.last)
        .where((name) => name.endsWith('.svg'))
        .toSet();

    expect(actualAssets, externalAssets.union(localAssets));
  });

  test('Lucide 授權原文隨資產散佈', () {
    // 直接讀取隨 package 散佈的授權原文，避免只驗證文件中的宣稱。
    final license = File(
      '$assetDirectory/LUCIDE_LICENSE.txt',
    ).readAsStringSync();

    expect(license, contains('ISC License'));
    expect(license, contains('The MIT License (MIT)'));
    expect(license, contains('Lucide Icons and Contributors'));
    expect(license, contains('Cole Bemis'));
  });
}

String _readProvenance(String path) {
  // 每次測試從版控文件讀回，避免測試與 manifest 各自保存一份資料。
  return File(path).readAsStringSync();
}

List<_LucideProvenanceRow> _parseLucideRows(String provenance) {
  final matches = RegExp(
    r'^\| ([^|]+\.svg) \| `icons/([^`]+\.svg)` \| `([a-f0-9]{64})` \|$',
    multiLine: true,
  ).allMatches(provenance);

  return matches
      .map(
        (match) => _LucideProvenanceRow(
          asset: match.group(1)!,
          upstreamPath: match.group(2)!,
          sha256: match.group(3)!,
        ),
      )
      .toList(growable: false);
}

List<String> _findHashMismatches(
  Iterable<_LucideProvenanceRow> rows,
  List<int> Function(String path) readBytes,
) {
  final mismatches = <String>[];

  for (final row in rows) {
    final path = 'assets/icons/ui_oval/${row.asset}';
    final actual = sha256.convert(readBytes(path)).toString();
    if (actual != row.sha256) mismatches.add(row.asset);
  }

  return mismatches;
}

final class _LucideProvenanceRow {
  const _LucideProvenanceRow({
    required this.asset,
    required this.upstreamPath,
    required this.sha256,
  });

  final String asset;
  final String upstreamPath;
  final String sha256;
}
