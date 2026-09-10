part of 'klp_template.dart';

/// 表面僅保存所屬語意參照，不接受原始風格值或求值函式。
final class KlpSurfaceTemplate<T extends KlpNode> extends KlpTemplate<T> {
  final KlpTemplate<T> child;
  final KlpSemanticKey<KlpColor> background;
  final KlpSemanticKey<KlpRadius> radius;
  final KlpSemanticKey<KlpDistance> inset;

  const KlpSurfaceTemplate({
    required this.child,
    required this.background,
    required this.radius,
    required this.inset,
  });
}
