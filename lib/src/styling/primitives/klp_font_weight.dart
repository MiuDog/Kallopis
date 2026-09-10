part of 'klp_style_value.dart';

/// 經驗證的中立字體原料，不指定元件用途。
final class KlpFontWeight extends KlpStyleValue {
  final int value;

  KlpFontWeight(this.value) {
    if (value < 1 || value > 1000) {
      throw KlpContractError(
        'invalid_primitive_value',
        'font_weight.value: expected an integer from 1 to 1000.',
      );
    }
  }
}
