part of 'klp_style_value.dart';

/// 經驗證的中立尺度原料，不指定元件用途。
final class KlpStrokeWidth extends KlpStyleValue {
  final double value;

  KlpStrokeWidth(this.value) {
    if (!value.isFinite || value < 0) {
      throw KlpContractError(
        'invalid_primitive_value',
        'stroke_width.value: expected a finite non-negative number.',
      );
    }
  }
}
