part of 'klp_bound_template.dart';

/// 畫面語意在資料準備期固定，renderer 不讀取消費端畫面物件。
final class KlpBoundScreen extends KlpBoundTemplate {
  final String accessibilityLabel;
  final KlpBoundTemplate child;

  const KlpBoundScreen({required this.accessibilityLabel, required this.child});
}
