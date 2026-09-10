part of 'klp_prepared_template.dart';

/// 表面風格在準備期固定，嵌入子項時不再解析語意。
final class KlpPreparedSurface extends KlpPreparedTemplate {
  final KlpColor background;
  final KlpRadius radius;
  final KlpDistance inset;
  final KlpPreparedTemplate child;

  const KlpPreparedSurface({
    required this.background,
    required this.radius,
    required this.inset,
    required this.child,
  });

  @override
  KlpBoundTemplate materialize(List<KlpBoundTemplate> children) =>
      KlpBoundSurface(
        background: background,
        radius: radius,
        inset: inset,
        child: child.materialize(children),
      );
}
