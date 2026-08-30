import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('目錄透過 KlpApp 接入且不自行指定 app icon 尺寸', () {
    final source = File('lib/main.dart').readAsStringSync();

    expect(source, contains('return KlpApp('));
    expect(source, contains('appIcon: const KlpIcon(KlpIcons.sparkles),'));
    expect(source, isNot(contains('FlutterLogo')));
  });
}
