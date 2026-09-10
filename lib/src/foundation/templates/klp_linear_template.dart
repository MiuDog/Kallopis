part of 'klp_template.dart';

/// 線性組合只接受相同資料契約的受控模板，並保存子項快照。
final class KlpLinearTemplate<T extends KlpNode> extends KlpTemplate<T> {

	final KlpAxis axis;
	final List<KlpTemplate<T>> children;
	final KlpSemanticKey<KlpDistance> gap;

	KlpLinearTemplate({required this.axis, required List<KlpTemplate<T>> children, required this.gap}) : children = List.unmodifiable(children);
}
