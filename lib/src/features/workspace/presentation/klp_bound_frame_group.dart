part of 'klp_workspace_presentation.dart';

/// 已解析的一段 Frame 內容，保留內距與分隔線的語意結果。
final class KlpBoundFrameGroup extends KlpBoundTemplate {

	final List<KlpBoundTemplate> children;
	final KlpDistance horizontalInset;
	final int divider;
	final KlpColor dividerColor;
	final KlpStrokeWidth dividerStroke;
	final KlpDistance groupGap;
	final KlpDistance contentGap;

	KlpBoundFrameGroup({
		required Iterable<KlpBoundTemplate> children,
		required this.horizontalInset,
		required this.divider,
		required this.dividerColor,
		required this.dividerStroke,
		required this.groupGap,
		required this.contentGap,
	}) : children = List.unmodifiable(children);
}
