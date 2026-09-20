part of 'klp_anchored_popup.dart';

enum KlpWorkspaceCommandStatus { completed, canceled, failed }

/// 呈現流程的結果；不宣稱產品資料已提交或持久化。
final class KlpWorkspaceCommandResult {
	const KlpWorkspaceCommandResult.completed()
		: status = KlpWorkspaceCommandStatus.completed,
			error = null,
			stackTrace = null;

	const KlpWorkspaceCommandResult.canceled()
		: status = KlpWorkspaceCommandStatus.canceled,
			error = null,
			stackTrace = null;

	const KlpWorkspaceCommandResult.failed(this.error, this.stackTrace)
		: status = KlpWorkspaceCommandStatus.failed;

	final KlpWorkspaceCommandStatus status;
	final Object? error;
	final StackTrace? stackTrace;
}

/// 可選快捷鍵語意；元件不從顯示文字推測命令用途。
enum KlpWorkspaceCommandShortcut { rename, delete }

/// 工作區命令資料；互動流程由 Kallopis 呈現，產品變更由 [onInvoke] 執行。
final class KlpWorkspaceCommand {
	KlpWorkspaceCommand({
		required this.label,
		this.enabled = true,
		this.destructive = false,
		this.inputLabel,
		this.initialValue,
		this.confirmation,
		this.submitLabel = 'OK',
		this.cancelLabel = 'Cancel',
		this.shortcut,
		required this.onInvoke,
		this.onResult,
	}) {
		if (label.trim().isEmpty) throw ArgumentError.value(label, 'label', 'Workspace command label must not be empty.');
		if (inputLabel != null && inputLabel!.trim().isEmpty) throw ArgumentError.value(inputLabel, 'inputLabel', 'Workspace command input label must not be empty.');
		if (confirmation != null && confirmation!.trim().isEmpty) throw ArgumentError.value(confirmation, 'confirmation', 'Workspace command confirmation must not be empty.');
		if (submitLabel.trim().isEmpty) throw ArgumentError.value(submitLabel, 'submitLabel', 'Workspace command submit label must not be empty.');
		if (cancelLabel.trim().isEmpty) throw ArgumentError.value(cancelLabel, 'cancelLabel', 'Workspace command cancel label must not be empty.');
	}

	final String label;
	final bool enabled;
	final bool destructive;
	final String? inputLabel;
	final String? initialValue;
	final String? confirmation;
	final String submitLabel;
	final String cancelLabel;
	final KlpWorkspaceCommandShortcut? shortcut;
	final FutureOr<void> Function(String? value) onInvoke;
	final ValueChanged<KlpWorkspaceCommandResult>? onResult;
}

/// 以 Kallopis 對話框完成命令的輸入、確認與結果流程。
Future<KlpWorkspaceCommandResult> showKlpWorkspaceCommand(BuildContext context, KlpWorkspaceCommand command) {
	return _runKlpWorkspaceCommand(context, command, () => context.mounted);
}
