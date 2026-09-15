part of 'klp_template.dart';

/// 紙張微浮僅接受所屬定義可讀取的顏色與尺度語意。
final class KlpSurfaceShadowSemantics {

	final KlpSemanticKey<KlpColor> color;
	final KlpSemanticKey<KlpDistance> scale;

	const KlpSurfaceShadowSemantics({required this.color, required this.scale});
}
