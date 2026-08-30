import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const fontPath = 'assets/fonts/FlaticonUIcons-RegularRounded.ttf';
  const licensePath = 'assets/fonts/LICENSE-FLATICON-UICONS.txt';
  const provenancePath = 'spec/release/kallopis-0.8.0-asset-provenance.md';

  test('Flaticon UIcons 字型固定版本與 SHA-256', () {
    final provenance = File(provenancePath).readAsStringSync();
    final actual = sha256.convert(File(fontPath).readAsBytesSync()).toString();

    expect(provenance, contains('@flaticon/flaticon-uicons` 3.3.1'));
    expect(
      provenance,
      contains(
        'e718df7cfcea3e10b7307ff9c3689102d3b73252a6d6e73f43e25503f68e4cf5',
      ),
    );
    expect(
      actual,
      'e718df7cfcea3e10b7307ff9c3689102d3b73252a6d6e73f43e25503f68e4cf5',
    );
  });

  test('Flaticon 授權原文固定且隨套件散佈', () {
    final actual = sha256
        .convert(File(licensePath).readAsBytesSync())
        .toString();

    expect(
      actual,
      'fb5651df9951685a33e6e8a450d9cc1194956d641b46e2521493c5d7395ece4f',
    );
  });

  test('來源文件包含免費方案必要歸因', () {
    final provenance = File(provenancePath).readAsStringSync();

    expect(provenance, contains('Uicons by Flaticon'));
    expect(provenance, contains('https://www.flaticon.com/uicons'));
  });
}
