import 'package:flutter/material.dart';

enum KlpAccent {
  ink(light: Color(0xFF1C1C1C), dark: Color(0xFFF5F2EC)),
  terracotta(light: Color(0xFF9E5D41), dark: Color(0xFFBE7D60)),
  ochre(light: Color(0xFF876833), dark: Color(0xFFA98850)),
  olive(light: Color(0xFF66733E), dark: Color(0xFF859359)),
  slate(light: Color(0xFF546F95), dark: Color(0xFF778FB0)),
  crimson(light: Color(0xFFAB5160), dark: Color(0xFFC07984));

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
