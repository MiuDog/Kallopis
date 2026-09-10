part of 'klp_style_value.dart';

/// 經驗證的中立尺度原料，不指定元件用途。
final class KlpDuration extends KlpStyleValue {
  final int milliseconds;

  KlpDuration(this.milliseconds) {
    if (milliseconds < 0) {
      throw KlpContractError(
        'invalid_primitive_value',
        'duration.milliseconds: expected a non-negative integer.',
      );
    }
  }
}
