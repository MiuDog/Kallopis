part of 'klp_bound_template.dart';

/// 元件定義期提供的可及性文字已完成投影，不能攜帶 Widget 或 callback。
final class KlpBoundAccessibility extends KlpBoundTemplate {
  final String label;
  final KlpBoundTemplate child;

  const KlpBoundAccessibility({required this.label, required this.child});
}
