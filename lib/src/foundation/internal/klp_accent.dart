part of '../klp_palette.dart';

/// 可選的強調色。
///
/// 每個值都對著 ink 色梯的表面重新校準過，對比 ≥ 4.70——刻意留 0.2 的餘裕，
/// **調整色梯時不會立刻踩線**。原本的值全部卡在 4.5 邊緣，色梯換掉後五個彩色全數
/// 掉出 AA，而那不會有任何徵兆：顏色看起來還是好的，只是讀不清楚。
enum KlpAccent {
  // 所有具體色值都由 palette library 定義，強調色只負責組成明暗配對。
  ink(light: _inkAccentLight, dark: _inkAccentDark),
  terracotta(light: _terracottaAccentLight, dark: _terracottaAccentDark),
  ochre(light: _ochreAccentLight, dark: _ochreAccentDark),
  olive(light: _oliveAccentLight, dark: _oliveAccentDark),
  slate(light: _slateAccentLight, dark: _slateAccentDark),
  crimson(light: _crimsonAccentLight, dark: _crimsonAccentDark);

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
