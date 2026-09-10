part of 'klp_bound_template.dart';

/// 表面結果只保存本庫解析值，沒有外部覆寫或後續求值回呼。
final class KlpBoundSurface extends KlpBoundTemplate {
  final KlpColor background;
  final KlpRadius radius;
  final KlpDistance inset;
  final KlpBoundTemplate child;

  const KlpBoundSurface({
    required this.background,
    required this.radius,
    required this.inset,
    required this.child,
  });
}
