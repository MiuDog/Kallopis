import 'package:flutter/material.dart';

typedef KlpJsonMap = Map<String, Object?>;

Never jsonError(String path, String message) {
  throw FormatException('$path: $message');
}

String jsonPath(String parent, String key) =>
    parent.isEmpty ? key : '$parent.$key';

void rejectUnknown(KlpJsonMap json, Set<String> known, String path) {
  for (final key in json.keys) {
    if (known.contains(key)) continue;

    jsonError(path.isEmpty ? key : '$path.$key', 'unknown field');
  }
}

KlpJsonMap expectMap(Object? value, String path) {
  if (value is! Map) jsonError(path, 'must be a JSON object');

  final result = <String, Object?>{};
  for (final entry in value.entries) {
    if (entry.key is! String) jsonError(path, 'field names must be strings');
    result[entry.key as String] = entry.value;
  }
  return result;
}

KlpJsonMap? readMap(KlpJsonMap json, String key, String path) {
  if (!json.containsKey(key)) return null;
  return expectMap(json[key], jsonPath(path, key));
}

String readString(KlpJsonMap json, String key, String path, String fallback) {
  if (!json.containsKey(key)) return fallback;
  final value = json[key];
  if (value is! String) jsonError(jsonPath(path, key), 'must be a string');
  return value;
}

List<String> readStrings(
  KlpJsonMap json,
  String key,
  String path,
  List<String> fallback,
) {
  if (!json.containsKey(key)) return fallback;
  final value = json[key];
  if (value is! List) jsonError('$path.$key', 'must be an array of strings');

  return <String>[
    for (var index = 0; index < value.length; index++)
      _expectString(value[index], '$path.$key[$index]'),
  ];
}

String _expectString(Object? value, String path) {
  if (value is! String) jsonError(path, 'must be a string');
  return value;
}

double readDouble(KlpJsonMap json, String key, String path, double fallback) {
  if (!json.containsKey(key)) return fallback;
  return expectDouble(json[key], '$path.$key');
}

double? readNullableDouble(
  KlpJsonMap json,
  String key,
  String path,
  double? fallback,
) {
  if (!json.containsKey(key)) return fallback;
  if (json[key] == null) return null;
  return expectDouble(json[key], '$path.$key');
}

double expectDouble(Object? value, String path) {
  if (value is! num) jsonError(path, 'must be a finite number');
  final result = value.toDouble();
  if (!result.isFinite) jsonError(path, 'must be a finite number');
  return result;
}

int readInt(KlpJsonMap json, String key, String path, int fallback) {
  if (!json.containsKey(key)) return fallback;
  final value = json[key];
  if (value is! int) jsonError(jsonPath(path, key), 'must be an integer');
  return value;
}

Color readColor(KlpJsonMap json, String key, String path, Color fallback) {
  if (!json.containsKey(key)) return fallback;
  return expectColor(json[key], '$path.$key');
}

Color expectColor(Object? value, String path) {
  if (value is! String ||
      !RegExp(r'^#[0-9A-Fa-f]{6}([0-9A-Fa-f]{2})?$').hasMatch(value)) {
    jsonError(path, 'must be #RRGGBB or #AARRGGBB');
  }
  final hex = value.substring(1);
  return Color(int.parse(hex.length == 6 ? 'FF$hex' : hex, radix: 16));
}

String encodeColor(Color color) {
  final value = color.toARGB32().toRadixString(16).padLeft(8, '0');
  return '#${value.toUpperCase()}';
}

List<Color> readColors(
  KlpJsonMap json,
  String key,
  String path,
  List<Color> fallback,
) {
  if (!json.containsKey(key)) return fallback;
  final value = json[key];
  if (value is! List) jsonError('$path.$key', 'must be an array of colors');
  return <Color>[
    for (var index = 0; index < value.length; index++)
      expectColor(value[index], '$path.$key[$index]'),
  ];
}

Duration readDuration(
  KlpJsonMap json,
  String key,
  String path,
  Duration fallback,
) {
  if (!json.containsKey(key)) return fallback;
  final value = json[key];
  if (value is! int || value < 0) {
    jsonError(
      '$path.$key',
      'must be whole milliseconds greater than or equal to 0',
    );
  }
  return Duration(milliseconds: value);
}

FontWeight readFontWeight(
  KlpJsonMap json,
  String key,
  String path,
  FontWeight fallback,
) {
  if (!json.containsKey(key)) return fallback;
  final value = json[key];
  if (value is! int || value < 100 || value > 900) {
    jsonError('$path.$key', 'must be an integer from 100 to 900');
  }
  return FontWeight(value);
}

Curve readCurve(KlpJsonMap json, String key, String path, Curve fallback) {
  if (!json.containsKey(key)) return fallback;
  final value = json[key];
  if (value is! List || value.length != 4) {
    jsonError('$path.$key', 'must be a four-number cubic array');
  }
  final points = <double>[
    for (var index = 0; index < value.length; index++)
      expectDouble(value[index], '$path.$key[$index]'),
  ];
  if (points[0] < 0 || points[0] > 1) {
    jsonError('$path.$key[0]', 'cubic x1 must be between 0 and 1');
  }
  if (points[2] < 0 || points[2] > 1) {
    jsonError('$path.$key[2]', 'cubic x2 must be between 0 and 1');
  }
  return Cubic(points[0], points[1], points[2], points[3]);
}

List<double> encodeCurve(Curve curve, String path) {
  if (curve is! Cubic) jsonError(path, 'only Cubic curves are supported');
  return <double>[curve.a, curve.b, curve.c, curve.d];
}

T readEnum<T extends Enum>(
  KlpJsonMap json,
  String key,
  String path,
  T fallback,
  List<T> values,
) {
  if (!json.containsKey(key)) return fallback;
  final value = json[key];
  if (value is! String) jsonError('$path.$key', 'must be a string');
  for (final candidate in values) {
    if (candidate.name == value) return candidate;
  }
  jsonError('$path.$key', 'unknown value $value');
}
