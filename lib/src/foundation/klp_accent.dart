import 'package:flutter/material.dart';

/// 可選的強調色。
///
/// 每個值都對著 ink 色梯的表面重新校準過，對比 ≥ 4.70——刻意留 0.2 的餘裕，
/// **調整色梯時不會立刻踩線**。原本的值全部卡在 4.5 邊緣，色梯換掉後五個彩色全數
/// 掉出 AA，而那不會有任何徵兆：顏色看起來還是好的，只是讀不清楚。
enum KlpAccent {
  ink(light: Color(0xFF111213), dark: Color(0xFFF5F5F6)),
  terracotta(light: Color(0xFF92563C), dark: Color(0xFFC18468)),
  ochre(light: Color(0xFF7D612F), dark: Color(0xFFAE8D55)),
  olive(light: Color(0xFF5E6A39), dark: Color(0xFF8A995C)),
  slate(light: Color(0xFF4E678A), dark: Color(0xFF7D94B3)),
  crimson(light: Color(0xFF9F4B59), dark: Color(0xFFC37F8A));

  const KlpAccent({required this.light, required this.dark});

  final Color light;
  final Color dark;

  Color resolve(Brightness brightness) => switch (brightness) {
    Brightness.light => light,
    Brightness.dark => dark,
  };

  static KlpAccent parse(String? value) {
    return KlpAccent.values
            .where((accent) => accent.name == value)
            .firstOrNull ??
        KlpAccent.ink;
  }
}
