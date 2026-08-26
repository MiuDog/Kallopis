import 'dart:io';

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
    final provenance = File(provenancePath).readAsStringSync();
    final rows = RegExp(
      r'^\| ([^|]+\.svg) \| `icons/([^`]+\.svg)` \| `([a-f0-9]{64})` \|$',
      multiLine: true,
    ).allMatches(provenance).toList();

    expect(rows, hasLength(49));
    expect(
      rows.map((row) => row.group(1)).toSet(),
      hasLength(49),
      reason: '每個 Kallopis 圖示只能有一筆上游對照',
    );
    expect(provenance, contains('4aec3f892fd6c23063bc2fead83c899b5d412b1c'));
  });

  test('來源清單完整涵蓋所有 SVG', () {
    final provenance = File(provenancePath).readAsStringSync();
    final externalAssets = RegExp(
      r'^\| ([^|]+\.svg) \| `icons/[^`]+\.svg` \| `[a-f0-9]{64}` \|$',
      multiLine: true,
    ).allMatches(provenance).map((row) => row.group(1)!).toSet();
    final actualAssets = Directory(assetDirectory)
        .listSync()
        .whereType<File>()
        .map((file) => file.uri.pathSegments.last)
        .where((name) => name.endsWith('.svg'))
        .toSet();

    expect(actualAssets, externalAssets.union(localAssets));
  });

  test('Lucide 授權原文隨資產散佈', () {
    final license = File(
      '$assetDirectory/LUCIDE_LICENSE.txt',
    ).readAsStringSync();

    expect(license, contains('ISC License'));
    expect(license, contains('The MIT License (MIT)'));
    expect(license, contains('Lucide Icons and Contributors'));
    expect(license, contains('Cole Bemis'));
  });
}
