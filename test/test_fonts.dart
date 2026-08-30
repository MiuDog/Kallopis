import 'package:flutter/services.dart';
import 'package:kallopis/kallopis.dart';

Future<void> loadKlpIconFont() async {
  final icons = FontLoader(
    'packages/kallopis/${KlpIcon.fontFamily}',
  )..addFont(rootBundle.load('assets/fonts/FlaticonUIcons-RegularRounded.ttf'));
  await icons.load();
}
