part of 'klp_workspace_presentation.dart';

/// 套件內部的唯讀命令呈現資料，攜帶輸入、確認文案與呼叫回呼。
/// 不屬使用端 API，不自行執行產品命令或決定授權。
final class KlpBoundWorkspaceCommand {
	final String label;
	final bool enabled;
	final bool destructive;
	final String? inputLabel;
	final String? initialValue;
	final String? confirmation;
	final String submitLabel;
	final String cancelLabel;
	final int? shortcut;
	final void Function(String?) onInvoke;
	const KlpBoundWorkspaceCommand({required this.label, required this.enabled, required this.destructive, this.inputLabel, this.initialValue, this.confirmation, required this.submitLabel, required this.cancelLabel, this.shortcut, required this.onInvoke});
}
