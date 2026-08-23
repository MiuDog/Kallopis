import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// JSON 主題的欄位完整性閘門。
///
/// `KlpVisualStyleJson` 的既有測試在行為面很完整——往返、路徑錯誤、未知鍵、數值
/// 範圍都有涵蓋。但它們全部是拿**現有**欄位去測，因此對「新增了一個 theme 欄位卻
/// 忘記加進 encode／decode」完全無感：測試照樣全綠，那個欄位只是悄悄變成 JSON
/// 改不到的。這正是這個庫最痛恨的失敗模式——沒有錯誤訊息，只是沒生效。
///
/// 這道閘門用原始碼掃描補上那個缺口，作法與 `theme_extension_contract_test`
/// 相同：宣告了什麼欄位，就必須在編解碼兩邊都出現。
void main() {
  /// 每一層與它的編解碼函式名。
  const layers = <String, ({String encode, String decode})>{
    'KlpThemeData': (encode: 'encodeColors', decode: 'decodeColors'),
    'KlpTypographyTheme': (
      encode: 'encodeTypography',
      decode: 'decodeTypography',
    ),
    'KlpSpacingTheme': (encode: 'encodeSpacing', decode: 'decodeSpacing'),
    'KlpShapeTheme': (encode: 'encodeShape', decode: 'decodeShape'),
    'KlpMotionTheme': (encode: 'encodeMotion', decode: 'decodeMotion'),
    'KlpSurfaceTheme': (encode: 'encodeSurface', decode: 'decodeSurface'),
    'KlpComponentTheme': (
      encode: 'encodeComponents',
      decode: 'decodeComponents',
    ),
    'KlpDataVisualizationTheme': (
      encode: 'encodeDataVisualization',
      decode: 'decodeDataVisualization',
    ),
  };

  late String codecSource;
  late Map<String, List<String>> fieldsOf;

  setUpAll(() {
    codecSource = Directory('lib/src/theme/internal')
        .listSync()
        .whereType<File>()
        .where((file) => file.path.endsWith('.dart'))
        .map((file) => file.readAsStringSync())
        .join('\n');

    fieldsOf = <String, List<String>>{};
    for (final file
        in Directory('lib/src/theme').listSync().whereType<File>().where(
          (file) => file.path.endsWith('.dart'),
        )) {
      final source = file.readAsStringSync();
      for (final className in layers.keys) {
        // 用正則而非字面比對：格式化器會把長的類別宣告折行，把 extends 推到
        // 下一行，這時用帶尾空白的字面字串是抓不到的。
        final start = RegExp(
          'class[ ]+$className(?![A-Za-z0-9_])',
        ).firstMatch(source)?.start;
        if (start == null) continue;
        final body = _classBody(source, start);
        if (body == null) continue;
        fieldsOf[className] = RegExp(
          r'^\s+final\s+[\w<>?, ]+\s+(\w+);',
          multiLine: true,
        ).allMatches(body).map((match) => match.group(1)!).toList();
      }
    }
  });

  test('每一層都找得到，閘門本身沒有失效', () {
    for (final className in layers.keys) {
      expect(
        fieldsOf[className],
        isNotNull,
        reason: '解析不到 $className 的欄位，這個閘門對它形同不存在',
      );
      expect(fieldsOf[className], isNotEmpty, reason: '$className 沒有解析到任何欄位');
    }
  });

  layers.forEach((className, codec) {
    group(className, () {
      test('每個欄位都出現在 ${codec.encode}', () {
        final body = _functionBody(codecSource, codec.encode);
        expect(body, isNotNull, reason: '找不到 ${codec.encode} 的函式本體');

        final missing = fieldsOf[className]!
            .where((field) => !RegExp(r'\b' + field + r'\b').hasMatch(body!))
            .toList();

        expect(
          missing,
          isEmpty,
          reason:
              '$className 的這些欄位沒有被 ${codec.encode} 輸出：${missing.join('、')}\n'
              '輸出不完整的 JSON 餵回 decode 就會靜默丟失這些值。',
        );
      });

      test('每個欄位都出現在 ${codec.decode}', () {
        final body = _functionBody(codecSource, codec.decode);
        expect(body, isNotNull, reason: '找不到 ${codec.decode} 的函式本體');

        final missing = fieldsOf[className]!
            .where((field) => !RegExp(r'\b' + field + r'\b').hasMatch(body!))
            .toList();

        expect(
          missing,
          isEmpty,
          reason:
              '$className 的這些欄位無法從 JSON 覆寫：${missing.join('、')}\n'
              '消費者在 JSON 裡寫這些鍵不會有任何效果，也不會有錯誤訊息。',
        );
      });
    });
  });
}

/// 從 `class X ` 的位置往後抓出整個類別本體。
String? _classBody(String source, int start) {
  final open = source.indexOf('{', start);
  if (open < 0) return null;
  return _balanced(source, open);
}

/// 抓出具名頂層函式的本體。
///
/// 涵蓋兩種寫法：`=> <String, Object?>{...}` 的表達式本體，
/// 以及 `{ ... }` 的區塊本體。
String? _functionBody(String source, String name) {
  final signature = RegExp(r'\b' + name + r'\s*\(').firstMatch(source);
  if (signature == null) return null;

  final afterParams = _skipBalanced(
    source,
    source.indexOf('(', signature.start),
  );
  if (afterParams < 0) return null;

  final arrow = source.indexOf('=>', afterParams);
  final brace = source.indexOf('{', afterParams);
  if (brace < 0) return null;
  if (arrow >= 0 && arrow < brace) return _balanced(source, brace);
  return _balanced(source, brace);
}

/// 從 `{` 開始配對到對應的 `}`。
String? _balanced(String source, int open) {
  var depth = 0;
  for (var i = open; i < source.length; i++) {
    if (source[i] == '{') depth++;
    if (source[i] == '}') {
      depth--;
      if (depth == 0) return source.substring(open, i + 1);
    }
  }
  return null;
}

/// 跳過一組配對的括號，回傳右括號之後的位置。
int _skipBalanced(String source, int open) {
  var depth = 0;
  for (var i = open; i < source.length; i++) {
    if (source[i] == '(') depth++;
    if (source[i] == ')') {
      depth--;
      if (depth == 0) return i + 1;
    }
  }
  return -1;
}
