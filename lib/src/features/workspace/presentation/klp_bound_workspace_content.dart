part of 'klp_workspace_presentation.dart';

/// 套件內部的唯讀線性內容呈現紀錄，攜帶軸向與已綁定子項目。
/// 不屬使用端 API，不建立另一棵使用端結構樹或正文模型。
final class KlpBoundWorkspaceContent extends KlpBoundTemplate {
	final int axis;
	final List<KlpBoundTemplate> children;
	KlpBoundWorkspaceContent({required this.axis, required Iterable<KlpBoundTemplate> children}) : children = List.unmodifiable(children);
}
