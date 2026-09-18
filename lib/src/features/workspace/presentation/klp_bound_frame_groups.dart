part of 'klp_workspace_presentation.dart';

/// 已解析的 Frame 群組清單，僅 renderer 決定其垂直排列方式。
final class KlpBoundFrameGroups extends KlpBoundTemplate {

	final List<KlpBoundTemplate> children;
	final bool hasFooter;

	KlpBoundFrameGroups(Iterable<KlpBoundTemplate> children, {this.hasFooter = false}) : children = List.unmodifiable(children);
}
