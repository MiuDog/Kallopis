import 'klp_visual_style_json_helpers.dart';

double? readNullableNonNegativeDouble(
  KlpJsonMap json,
  String key,
  String path,
  double? fallback,
) {
  final value = readNullableDouble(json, key, path, fallback);
  if (value != null && value < 0) {
    jsonError(jsonPath(path, key), 'must be greater than or equal to 0');
  }
  return value;
}

double readNonNegativeDouble(
  KlpJsonMap json,
  String key,
  String path,
  double fallback,
) {
  final value = readDouble(json, key, path, fallback);
  if (value < 0) {
    jsonError(jsonPath(path, key), 'must be greater than or equal to 0');
  }
  return value;
}

double readPositiveDouble(
  KlpJsonMap json,
  String key,
  String path,
  double fallback,
) {
  final value = readDouble(json, key, path, fallback);
  if (value <= 0) jsonError(jsonPath(path, key), 'must be greater than 0');
  return value;
}

double readOpacity(KlpJsonMap json, String key, String path, double fallback) {
  final value = readDouble(json, key, path, fallback);
  if (value < 0 || value > 1) {
    jsonError(jsonPath(path, key), 'must be between 0 and 1');
  }
  return value;
}

int readPositiveInt(KlpJsonMap json, String key, String path, int fallback) {
  final value = readInt(json, key, path, fallback);
  if (value <= 0) jsonError(jsonPath(path, key), 'must be greater than 0');
  return value;
}

int encodeDuration(Duration value, String path) {
  if (value.isNegative) {
    jsonError(path, 'must be greater than or equal to 0');
  }
  if (value.inMicroseconds % Duration.microsecondsPerMillisecond != 0) {
    jsonError(path, 'must use whole milliseconds');
  }
  return value.inMilliseconds;
}
