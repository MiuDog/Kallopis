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
	final FutureOr<void> Function(String?) onInvoke;
	final void Function(KlpWorkspaceCommandResult)? onResult;
	const KlpBoundWorkspaceCommand({required this.label, required this.enabled, required this.destructive, this.inputLabel, this.initialValue, this.confirmation, required this.submitLabel, required this.cancelLabel, this.shortcut, required this.onInvoke, this.onResult});

	factory KlpBoundWorkspaceCommand.fromCommand(KlpWorkspaceCommand command) => KlpBoundWorkspaceCommand(
		label: command.label,
		enabled: command.enabled,
		destructive: command.destructive,
		inputLabel: command.inputLabel,
		initialValue: command.initialValue,
		confirmation: command.confirmation,
		submitLabel: command.submitLabel,
		cancelLabel: command.cancelLabel,
		shortcut: command.shortcut?.index,
		onInvoke: command.onInvoke,
		onResult: command.onResult,
	);
}
