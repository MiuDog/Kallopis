part of 'klp_workspace_presentation.dart';

/// 套件內部的唯讀內容區塊呈現紀錄，攜帶文字、勾選輸入、回呼與已綁定子項目。
/// 不屬使用端 API，不擁有正文交易或勾選狀態。
final class KlpBoundWorkspaceContentBlock extends KlpBoundTemplate {
	final int kind;
	final String text;
	final String? subtitle;
	final int? icon;
	final bool? checked;
	final void Function()? onPressed;
	final void Function(bool)? onCheckedChanged;
	final int axis;
	final List<KlpBoundTemplate> children;
	KlpBoundWorkspaceContentBlock({required this.kind, required this.text, this.subtitle, this.icon, this.checked, this.onPressed, this.onCheckedChanged, required this.axis, required Iterable<KlpBoundTemplate> children}) : children = List.unmodifiable(children);
}
