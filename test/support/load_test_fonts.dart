import 'package:flutter/services.dart';
import 'package:kallopis/kallopis.dart';

/// 載入 widget/golden 測試需要的 Kallopis 字型。
///
/// `flutter_test` 不會自動載入 pubspec 登記的自訂字型；少了這一步會靜默
/// fallback，私用區字碼就會顯示成缺字方框。
Future<void> loadKlpTestFonts() async {
  if (KlpTypography.sansFamily.isNotEmpty) {
    final sans = FontLoader(KlpTypography.sansFamily)
      ..addFont(rootBundle.load('assets/fonts/IBMPlexSansTC-Regular.ttf'));
    await sans.load();
  }
  if (KlpTypography.monoFamily.isNotEmpty) {
    final mono = FontLoader(KlpTypography.monoFamily)
      ..addFont(rootBundle.load('assets/fonts/IBMPlexMono-Regular.ttf'));
    await mono.load();
  }

  final icons = FontLoader(
    'packages/kallopis/${KlpIcon.fontFamily}',
  )..addFont(rootBundle.load('assets/fonts/FlaticonUIcons-RegularRounded.ttf'));
  await icons.load();
}
