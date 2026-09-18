part of 'klp_workspace_presentation.dart';

/// 已解析 app layout 呈現資料；僅 renderer 可解讀其 kind。
final class KlpBoundAppLayout extends KlpBoundTemplate {

	final int kind;
	final KlpDistance inset;
	final KlpDistance? headerExtent;
	final void Function()? onHeaderDrag;
	final KlpColor background;
	final KlpRadius radius;
	final KlpColor? reliefShadow;
	final KlpColor? reliefHighlight;
	final KlpDistance? reliefScale;
	final int flex;
	final KlpDistance? laneExtent;
	final bool bare;
	final int alignment;
	final bool gapless;
	final List<KlpBoundTemplate> children;

	KlpBoundAppLayout({required this.kind, required this.inset, this.headerExtent, this.onHeaderDrag, required this.background, required this.radius, required this.flex, required this.laneExtent, required this.bare, required this.alignment, required this.gapless, this.reliefShadow, this.reliefHighlight, this.reliefScale, required Iterable<KlpBoundTemplate> children}) : children = List.unmodifiable(children);
}
